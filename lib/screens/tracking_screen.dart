import 'dart:async';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/location_data.dart';
import '../services/database_service.dart';
import '../services/geolocation_service.dart';
import '../services/permission_service.dart';
import '../widgets/location_card.dart';
import '../widgets/map_view.dart';
import '../widgets/status_card.dart';

class TrackingScreen extends StatefulWidget {
  final String serviceOrderId;

  const TrackingScreen({
    super.key,
    required this.serviceOrderId,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> with WidgetsBindingObserver {
  final _geoService = GeolocationService();

  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  final List<LocationData> _locationHistory = [];
  DateTime? _startTime;
  bool _isShowingDialog = false;
  int _permissionDeniedCount = 0;
  static const _maxPermissionRetries = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now().toUtc();
    _startTracking();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSubscription?.cancel();
    _geoService.stopTracking();
    _geoService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_geoService.isTracking && !_isShowingDialog) {
      _startTracking();
    }
  }

  Future<void> _startTracking() async {
    final hasPermission = await PermissionService.requestLocationPermissions();
    if (!hasPermission) {
      _permissionDeniedCount++;
      if (!mounted) return;
      if (_permissionDeniedCount >= _maxPermissionRetries) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.enableLocationService)),
        );
        Navigator.pop(context);
        return;
      }
      _showPermissionDialog();
      return;
    }

    final success = await _geoService.startTracking(
      serviceOrderId: widget.serviceOrderId,
    );

    if (success) {
      _permissionDeniedCount = 0;
      _locationSubscription = _geoService.locationStream.listen((location) {
        setState(() {
          _currentLocation = location;
          _locationHistory.add(location);
        });
      });

      // Get initial location
      final initial = await _geoService.getCurrentLocation(
        serviceOrderId: widget.serviceOrderId,
      );
      if (initial != null && mounted) {
        setState(() {
          _currentLocation = initial;
        });
      }
    }
  }

  Future<void> _refreshLocation() async {
    final location = await _geoService.getCurrentLocation(
      serviceOrderId: widget.serviceOrderId,
    );
    if (location != null && mounted) {
      setState(() {
        _currentLocation = location;
      });
      await DatabaseService.insertLocation(location);
    }
  }

  Future<void> _confirmFinish() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmFinish),
        content: Text(l10n.confirmFinishMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _geoService.stopTracking();
      if (mounted) Navigator.pop(context);
    }
  }

  void _showPermissionDialog() {
    if (_isShowingDialog) return;
    _isShowingDialog = true;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.permissionRequired),
        content: Text(l10n.enableLocationService),
        actions: [
          TextButton(
            onPressed: () {
              _isShowingDialog = false;
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              _isShowingDialog = false;
              Navigator.pop(ctx);
              await _startTracking();
            },
            child: Text(l10n.grant),
          ),
        ],
      ),
    );
  }

  String _formatDuration() {
    if (_startTime == null) return '00:00';
    final diff = DateTime.now().toUtc().difference(_startTime!);
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return diff.inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  double get _totalDistance => GeolocationService.totalDistance(_locationHistory);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${l10n.serviceOrder}: ${widget.serviceOrderId}', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: const Icon(Icons.map, color: Colors.white), text: l10n.map),
              Tab(icon: const Icon(Icons.list_alt, color: Colors.white), text: l10n.details),
            ],
          ),
        ),
        body: Column(
          children: [
            // Stats bar
            Material(
              elevation: 2,
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      icon: Icons.straighten,
                      label: l10n.distance,
                      value: _totalDistance >= 1000 ? '${(_totalDistance / 1000).toStringAsFixed(1)} km' : '${_totalDistance.toStringAsFixed(0)} ${l10n.meters}',
                    ),
                    _StatChip(
                      icon: Icons.timer,
                      label: l10n.duration,
                      value: _formatDuration(),
                    ),
                    _StatChip(
                      icon: Icons.place,
                      label: l10n.points,
                      value: '${_locationHistory.length}',
                    ),
                  ],
                ),
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  // Map tab
                  MapView(
                    locations: _locationHistory,
                    currentLocation: _currentLocation,
                  ),

                  // Details tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StatusCard(
                          isTracking: _geoService.isTracking,
                          serviceOrderId: widget.serviceOrderId,
                          elapsed: _formatDuration(),
                        ),
                        const SizedBox(height: 16),
                        LocationCard(
                          location: _currentLocation,
                          onRefresh: _refreshLocation,
                        ),
                        if (_locationHistory.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildHistoryCard(colorScheme),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action bar
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _refreshLocation,
                            icon: const Icon(Icons.my_location),
                            label: Text(l10n.refresh, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _confirmFinish,
                            icon: const Icon(Icons.stop),
                            label: Text(l10n.stopTracking, maxLines: 1, overflow: TextOverflow.ellipsis),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    // Show last 10 entries, most recent first
    final recent = _locationHistory.reversed.take(10).toList();

    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.history, color: colorScheme.onTertiaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.points}: ${_locationHistory.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final loc = recent[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: colorScheme.tertiaryContainer,
                    child: Text(
                      '${_locationHistory.length - index}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                  title: Text(
                    '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    '${loc.timestamp.toLocal().hour.toString().padLeft(2, '0')}:'
                    '${loc.timestamp.toLocal().minute.toString().padLeft(2, '0')}:'
                    '${loc.timestamp.toLocal().second.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: loc.accuracy != null
                      ? Text(
                          '${loc.accuracy!.toStringAsFixed(0)}${l10n.meters}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurface),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colorScheme.onSurface,
              )),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  )),
        ],
      ),
    );
  }
}

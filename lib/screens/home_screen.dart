import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../services/settings_service.dart';
import 'settings_screen.dart';
import 'tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceOrderController = TextEditingController();

  String? _technicianName;
  String? _technicianId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _serviceOrderController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final name = await SettingsService.getTechnicianName();
    final id = await SettingsService.getTechnicianId();
    setState(() {
      _technicianName = name;
      _technicianId = id;
      _loading = false;
    });
  }

  bool get _hasProfile => _technicianName != null && _technicianName!.isNotEmpty && _technicianId != null && _technicianId!.isNotEmpty;

  void _startTracking() {
    if (!_hasProfile) {
      _goToSettings();
      return;
    }
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackingScreen(
            serviceOrderId: _serviceOrderController.text,
          ),
        ),
      );
    }
  }

  void _goToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _goToSettings,
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primary.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 64,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.appDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Service order form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.serviceOrder,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _serviceOrderController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.serviceOrderNumber,
                          prefixIcon: const Icon(Icons.assignment),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.serviceOrderRequired;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Start button
              FilledButton.icon(
                onPressed: _startTracking,
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.startTracking),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

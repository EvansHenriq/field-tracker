import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/location_data.dart';

class MapView extends StatefulWidget {
  final List<LocationData> locations;
  final LocationData? currentLocation;

  const MapView({
    super.key,
    required this.locations,
    this.currentLocation,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();

  LatLng get _center {
    if (widget.currentLocation != null) {
      return LatLng(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
      );
    }
    if (widget.locations.isNotEmpty) {
      final last = widget.locations.last;
      return LatLng(last.latitude, last.longitude);
    }
    // Default: center of Brazil
    return const LatLng(-15.78, -47.93);
  }

  List<LatLng> get _polylinePoints =>
      widget.locations.map((l) => LatLng(l.latitude, l.longitude)).toList();

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocation != null &&
        (oldWidget.currentLocation == null ||
            widget.currentLocation!.latitude !=
                oldWidget.currentLocation!.latitude)) {
      _mapController.move(_center, _mapController.camera.zoom);
    }
  }

  void _zoomIn() {
    final zoom = _mapController.camera.zoom + 1;
    _mapController.move(_mapController.camera.center, zoom.clamp(1, 18));
  }

  void _zoomOut() {
    final zoom = _mapController.camera.zoom - 1;
    _mapController.move(_mapController.camera.center, zoom.clamp(1, 18));
  }

  void _reCenter() {
    _mapController.move(_center, _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.fieldtracker.app',
            ),
            if (_polylinePoints.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _polylinePoints,
                    strokeWidth: 4,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (widget.currentLocation != null)
                  Marker(
                    point: _center,
                    width: 28,
                    height: 28,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: _zoomOut,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'recenter',
                onPressed: _reCenter,
                child: const Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

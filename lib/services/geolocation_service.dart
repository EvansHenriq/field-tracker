import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../models/location_data.dart';
import '../services/database_service.dart';
import '../services/permission_service.dart';

class GeolocationService {
  final _locationController = StreamController<LocationData>.broadcast();
  StreamSubscription<Position>? _positionSubscription;

  Stream<LocationData> get locationStream => _locationController.stream;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  String? _serviceOrderId;

  static const int distanceFilter = 10;
  static const LocationAccuracy accuracy = LocationAccuracy.high;

  Future<bool> startTracking({required String serviceOrderId}) async {
    try {
      final hasPermission =
          await PermissionService.requestLocationPermissions();
      if (!hasPermission) {
        throw Exception('Location permissions not granted');
      }

      _serviceOrderId = serviceOrderId;

      await _positionSubscription?.cancel();

      const locationSettings = LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) async {
          final locationData = LocationData(
            latitude: position.latitude,
            longitude: position.longitude,
            timestamp: position.timestamp.toUtc(),
            accuracy: position.accuracy,
            altitude: position.altitude,
            speed: position.speed,
            serviceOrderId: _serviceOrderId,
          );

          _locationController.add(locationData);
          await DatabaseService.insertLocation(locationData);
        },
        onError: (error) {
          // Stream error — location updates will resume when possible
        },
      );

      _isTracking = true;
      return true;
    } catch (e) {
      _isTracking = false;
      return false;
    }
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _isTracking = false;
    _serviceOrderId = null;
  }

  Future<LocationData?> getCurrentLocation({String? serviceOrderId}) async {
    try {
      final hasPermission =
          await PermissionService.requestLocationPermissions();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: accuracy),
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp.toUtc(),
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        serviceOrderId: serviceOrderId,
      );
    } catch (e) {
      return null;
    }
  }

  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  static double totalDistance(List<LocationData> locations) {
    double total = 0;
    for (int i = 1; i < locations.length; i++) {
      total += calculateDistance(
        locations[i - 1].latitude,
        locations[i - 1].longitude,
        locations[i].latitude,
        locations[i].longitude,
      );
    }
    return total;
  }

  void dispose() {
    _positionSubscription?.cancel();
    _locationController.close();
  }
}

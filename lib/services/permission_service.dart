import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Requests foreground location permission (required).
  /// Returns true if granted.
  static Future<bool> requestLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Re-check after user returns from settings
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      return false;
    }

    return true;
  }

  /// Requests background location permission (optional).
  /// Returns true if granted.
  static Future<bool> requestBackgroundPermission() async {
    if (!Platform.isAndroid) return false;
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  static Future<Map<String, bool>> checkPermissionStatus() async {
    return {
      'location_service': await Geolocator.isLocationServiceEnabled(),
      'location_permission':
          await Geolocator.checkPermission() != LocationPermission.denied,
      'background_permission': await Permission.locationAlways.isGranted,
    };
  }
}

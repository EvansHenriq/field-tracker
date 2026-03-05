// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Field Tracker';

  @override
  String get homeTitle => 'Service Order';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get trackingTitle => 'Tracking';

  @override
  String get technicianName => 'Technician Name';

  @override
  String get technicianId => 'Technician ID';

  @override
  String get serviceOrderNumber => 'Service Order Number';

  @override
  String get startTracking => 'Start Tracking';

  @override
  String get stopTracking => 'Finish Service Order';

  @override
  String get refresh => 'Refresh';

  @override
  String get map => 'Map';

  @override
  String get details => 'Details';

  @override
  String get trackingActive => 'Tracking Active';

  @override
  String get waitingLocation => 'Waiting for location...';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get altitude => 'Altitude';

  @override
  String get speed => 'Speed';

  @override
  String get lastUpdate => 'Last update';

  @override
  String get distance => 'Distance';

  @override
  String get duration => 'Duration';

  @override
  String get points => 'Points';

  @override
  String get confirmFinish => 'Finish Service Order?';

  @override
  String get confirmFinishMessage =>
      'This will stop tracking and save the route. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get profileNotConfigured => 'Technician profile not configured';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get technician => 'Technician';

  @override
  String get language => 'Language';

  @override
  String get portuguese => 'Portuguese (BR)';

  @override
  String get english => 'English';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get appDescription =>
      'Field technician GPS tracking app for service orders. 100% offline.';

  @override
  String get save => 'Save';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get serviceOrderRequired => 'Service order number is required';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get idRequired => 'ID is required';

  @override
  String get elapsed => 'Elapsed';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationServiceDisabled => 'Location service is disabled';

  @override
  String get enableLocationService => 'Please enable location services';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get backgroundPermissionInfo =>
      'Background location permission allows tracking when the app is minimized. This is optional.';

  @override
  String get grant => 'Grant';

  @override
  String get skip => 'Skip';

  @override
  String get noSessionsYet => 'No tracking sessions yet';

  @override
  String get serviceOrder => 'Service Order';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get meters => 'm';

  @override
  String get kmh => 'km/h';

  @override
  String get sessionSaved => 'Session saved successfully';

  @override
  String get errorSavingSession => 'Error saving session';
}

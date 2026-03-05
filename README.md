# Field Tracker

> Offline GPS tracking app for field technicians managing service orders.

A mobile field service tracking app built with Flutter. Track technician routes during service order execution with real-time GPS, interactive maps, and full offline support via SQLite and OpenStreetMap.

![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white)
![OpenStreetMap](https://img.shields.io/badge/OpenStreetMap-7EBC6F?logo=openstreetmap&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## About the Project

**Field Tracker** was built to solve a real need in field service operations: tracking technician routes and locations during service order execution without relying on internet connectivity. The app runs offline-first, storing all GPS data locally in SQLite and rendering maps via OpenStreetMap tile caching.

### Features

- **Real-Time GPS Tracking** — Continuous location recording during active service orders
- **Interactive Map** — Route visualization with polyline rendering via OpenStreetMap (flutter_map)
- **100% Offline** — All data persisted locally with SQLite; no server or internet required
- **Technician Profile** — Configure name and ID once in settings, applied to all service orders
- **Bilingual Interface** — Full Portuguese (BR) and English localization with runtime switching
- **Dark Mode** — Follows system theme with Material Design 3
- **Tracking Statistics** — Distance traveled, duration, and point count per service order
- **Location Details** — Accuracy, altitude, speed, and timestamps for each recorded point

## Screenshots

| Home | Tracking Map | Settings |
|:----:|:------------:|:--------:|
| *screenshot* | *screenshot* | *screenshot* |

## Built With

| Technology | Purpose |
|---|---|
| **Flutter** 3.27+ | Cross-platform mobile framework |
| **Dart** 3.0+ | Programming language |
| **sqflite** | Local SQLite database for location persistence |
| **flutter_map** | OpenStreetMap-based interactive map rendering |
| **latlong2** | Geographic coordinate handling |
| **geolocator** | GPS location streaming and distance calculations |
| **permission_handler** | Runtime permission management (location, GPS) |
| **shared_preferences** | Lightweight key-value storage for settings |
| **intl** | Internationalization and locale formatting |
| **Material Design 3** | UI design system with dynamic theming |

## Architecture

The project follows a **service-based architecture** with clear separation of concerns:

```
lib/
├── main.dart                    # App entry point, theme, i18n config
├── l10n/                        # Localization
│   ├── app_en.arb               # English translations
│   ├── app_pt.arb               # Portuguese translations
│   ├── app_localizations.dart   # Generated localization delegate
│   ├── app_localizations_en.dart
│   └── app_localizations_pt.dart
├── models/
│   └── location_data.dart       # Location data model with serialization
├── screens/
│   ├── home_screen.dart         # Service order entry and tracking start
│   ├── tracking_screen.dart     # Map + stats with tabbed detail view
│   └── settings_screen.dart     # Technician profile and language config
├── services/
│   ├── database_service.dart    # SQLite CRUD operations
│   ├── geolocation_service.dart # GPS streaming and lifecycle management
│   ├── permission_service.dart  # Location permission requests
│   └── settings_service.dart    # SharedPreferences wrapper
└── widgets/
    ├── map_view.dart            # OpenStreetMap with route polyline
    ├── status_card.dart         # Tracking status indicator
    └── location_card.dart       # Current location detail card
```

## Getting Started

### Prerequisites

- Flutter SDK 3.27 or higher ([install guide](https://docs.flutter.dev/get-started/install))
- Android Studio (for Android) or Xcode (for iOS)
- GPS-enabled device or emulator with location simulation

### Installation

```bash
# Clone the repository
git clone https://github.com/EvansHenriq/field-tracker.git
cd field-tracker

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run on connected device or emulator
flutter run
```

## Challenges & Solutions

### 1. GPS Lifecycle Management

Continuous GPS tracking must handle app backgrounding, permission revocation, and battery optimization. A naive implementation leads to memory leaks or lost tracking data when the OS suspends the app.

**Solution:** The geolocation service manages stream subscriptions with explicit start/stop lifecycle methods, properly disposing of resources. Permission checks are performed before every tracking session, with graceful degradation when permissions are denied mid-session.

### 2. Offline Map Tile Rendering

Displaying interactive maps without guaranteed internet access requires careful tile source management. Standard Google Maps SDK requires an API key and network connectivity.

**Solution:** Used `flutter_map` with OpenStreetMap tiles, which are freely available and can be cached locally. The map renders the technician's route as a polyline overlay with real-time position updates, working even in areas with intermittent connectivity.

### 3. Bilingual Localization with Runtime Switching

Supporting Portuguese and English with the ability to switch languages at runtime — without restarting the app — required proper integration of Flutter's localization framework with persisted user preferences.

**Solution:** Combined Flutter's `intl` package with ARB-based translations and a settings service that persists the locale choice via `SharedPreferences`. The app rebuilds its widget tree with the new locale when the user switches languages, providing instant feedback.

## Future Improvements

- [ ] Data export to CSV/PDF for service order reports
- [ ] Background GPS tracking with foreground service notification
- [ ] Route replay animation on the map view
- [ ] Cloud sync option for multi-device fleet management
- [ ] Photo capture at service order checkpoints
- [ ] Geofencing alerts for designated work areas

## Author

**Evandro Henrique** — Flutter Developer

- GitHub: [@EvansHenriq](https://github.com/EvansHenriq)
- LinkedIn: [linkedin.com/in/evandro-henrique-mobile](https://linkedin.com/in/evandro-henrique-mobile)

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

import 'package:flutter_test/flutter_test.dart';
import 'package:field_tracker/models/location_data.dart';

void main() {
  group('LocationData', () {
    test('toJson round-trip preserves all fields', () {
      final original = LocationData(
        id: 1,
        latitude: -23.550520,
        longitude: -46.633308,
        timestamp: DateTime.utc(2024, 6, 15, 10, 30, 0),
        accuracy: 5.2,
        altitude: 760.0,
        speed: 1.5,
        serviceOrderId: 'OS-2024-001',
      );

      final json = original.toJson();
      final restored = LocationData.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.latitude, original.latitude);
      expect(restored.longitude, original.longitude);
      expect(restored.timestamp, original.timestamp);
      expect(restored.accuracy, original.accuracy);
      expect(restored.altitude, original.altitude);
      expect(restored.speed, original.speed);
      expect(restored.serviceOrderId, original.serviceOrderId);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'latitude': -23.5,
        'longitude': -46.6,
        'timestamp': '2024-06-15T10:30:00.000Z',
      };

      final data = LocationData.fromJson(json);

      expect(data.latitude, -23.5);
      expect(data.longitude, -46.6);
      expect(data.accuracy, isNull);
      expect(data.altitude, isNull);
      expect(data.speed, isNull);
      expect(data.serviceOrderId, isNull);
      expect(data.id, isNull);
    });

    test('toMap produces correct SQLite-compatible map', () {
      final data = LocationData(
        latitude: -23.55,
        longitude: -46.63,
        timestamp: DateTime.utc(2024, 1, 1),
        serviceOrderId: 'OS-001',
      );

      final map = data.toMap();

      expect(map['latitude'], -23.55);
      expect(map['longitude'], -46.63);
      expect(map['timestamp'], '2024-01-01T00:00:00.000Z');
      expect(map['service_order_id'], 'OS-001');
      expect(map.containsKey('id'), isFalse);
    });

    test('fromMap round-trip with id', () {
      final map = {
        'id': 42,
        'latitude': -23.55,
        'longitude': -46.63,
        'timestamp': '2024-01-01T00:00:00.000Z',
        'accuracy': 3.0,
        'altitude': null,
        'speed': null,
        'service_order_id': 'OS-001',
      };

      final data = LocationData.fromMap(map);

      expect(data.id, 42);
      expect(data.latitude, -23.55);
      expect(data.serviceOrderId, 'OS-001');
    });
  });
}

class LocationData {
  final int? id;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final String? serviceOrderId;

  LocationData({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.altitude,
    this.speed,
    this.serviceOrderId,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'accuracy': accuracy,
        'altitude': altitude,
        'speed': speed,
        'service_order_id': serviceOrderId,
      };

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'accuracy': accuracy,
        'altitude': altitude,
        'speed': speed,
        'service_order_id': serviceOrderId,
      };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        id: json['id'] as int?,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String).toUtc(),
        accuracy: (json['accuracy'] as num?)?.toDouble(),
        altitude: (json['altitude'] as num?)?.toDouble(),
        speed: (json['speed'] as num?)?.toDouble(),
        serviceOrderId: json['service_order_id'] as String?,
      );

  factory LocationData.fromMap(Map<String, dynamic> map) => LocationData(
        id: map['id'] as int?,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        timestamp: DateTime.parse(map['timestamp'] as String).toUtc(),
        accuracy: (map['accuracy'] as num?)?.toDouble(),
        altitude: (map['altitude'] as num?)?.toDouble(),
        speed: (map['speed'] as num?)?.toDouble(),
        serviceOrderId: map['service_order_id'] as String?,
      );
}

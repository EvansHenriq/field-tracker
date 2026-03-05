import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/location_data.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'field_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            timestamp TEXT NOT NULL,
            accuracy REAL,
            altitude REAL,
            speed REAL,
            service_order_id TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertLocation(LocationData location) async {
    final db = await database;
    return db.insert('locations', location.toMap());
  }

  static Future<List<LocationData>> getLocationsForSession(
    String serviceOrderId,
  ) async {
    final db = await database;
    final maps = await db.query(
      'locations',
      where: 'service_order_id = ?',
      whereArgs: [serviceOrderId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((map) => LocationData.fromMap(map)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        service_order_id,
        COUNT(*) as point_count,
        MIN(timestamp) as start_time,
        MAX(timestamp) as end_time
      FROM locations
      WHERE service_order_id IS NOT NULL
      GROUP BY service_order_id
      ORDER BY MAX(timestamp) DESC
    ''');
    return result;
  }

  static Future<int> deleteSession(String serviceOrderId) async {
    final db = await database;
    return db.delete(
      'locations',
      where: 'service_order_id = ?',
      whereArgs: [serviceOrderId],
    );
  }
}

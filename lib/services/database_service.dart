import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/attendance_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'learnmark.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE checkin_records (
        checkinId TEXT PRIMARY KEY,
        studentId TEXT NOT NULL,
        classId TEXT NOT NULL,
        checkinTime TEXT NOT NULL,
        gpsLatitude REAL NOT NULL,
        gpsLongitude REAL NOT NULL,
        previousTopic TEXT NOT NULL,
        expectedTopic TEXT NOT NULL,
        preMood INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE checkout_records (
        checkoutId TEXT PRIMARY KEY,
        checkinId TEXT NOT NULL,
        checkoutTime TEXT NOT NULL,
        gpsLatitude REAL NOT NULL,
        gpsLongitude REAL NOT NULL,
        whatLearned TEXT NOT NULL,
        classFeedback TEXT NOT NULL,
        postMood INTEGER,
        FOREIGN KEY (checkinId) REFERENCES checkin_records(checkinId)
      )
    ''');
  }

  // CheckIn Operations
  Future<bool> insertCheckIn(CheckInRecord record) async {
    if (kIsWeb) {
      final list = await _loadWebList('checkins');
      list.add(record.toMap());
      return _saveWebList('checkins', list);
    }
    try {
      final db = await database;
      await db.insert('checkin_records', record.toMap());
      return true;
    } catch (e) {
      print('Error inserting check-in: $e');
      return false;
    }
  }

  Future<CheckInRecord?> getCheckInById(String checkinId) async {
    if (kIsWeb) {
      final list = await _loadWebList('checkins');
      final match = list.firstWhere(
        (e) => e['checkinId'] == checkinId,
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        return CheckInRecord.fromMap(Map<String, dynamic>.from(match));
      }
      return null;
    }
    final db = await database;
    final maps = await db.query(
      'checkin_records',
      where: 'checkinId = ?',
      whereArgs: [checkinId],
    );
    if (maps.isNotEmpty) {
      return CheckInRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CheckInRecord>> getAllCheckIns() async {
    if (kIsWeb) {
      final list = await _loadWebList('checkins');
      return list
          .map((e) => CheckInRecord.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
    final db = await database;
    final maps = await db.query('checkin_records');
    return List.generate(
      maps.length,
      (i) => CheckInRecord.fromMap(maps[i]),
    );
  }

  // CheckOut Operations
  Future<bool> insertCheckOut(CheckOutRecord record) async {
    if (kIsWeb) {
      final list = await _loadWebList('checkouts');
      list.add(record.toMap());
      return _saveWebList('checkouts', list);
    }
    try {
      final db = await database;
      await db.insert('checkout_records', record.toMap());
      return true;
    } catch (e) {
      print('Error inserting check-out: $e');
      return false;
    }
  }

  Future<CheckOutRecord?> getCheckOutByCheckinId(String checkinId) async {
    if (kIsWeb) {
      final list = await _loadWebList('checkouts');
      final match = list.firstWhere(
        (e) => e['checkinId'] == checkinId,
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        return CheckOutRecord.fromMap(Map<String, dynamic>.from(match));
      }
      return null;
    }
    final db = await database;
    final maps = await db.query(
      'checkout_records',
      where: 'checkinId = ?',
      whereArgs: [checkinId],
    );
    if (maps.isNotEmpty) {
      return CheckOutRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CheckOutRecord>> getAllCheckOuts() async {
    if (kIsWeb) {
      final list = await _loadWebList('checkouts');
      return list
          .map((e) => CheckOutRecord.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
    final db = await database;
    final maps = await db.query('checkout_records');
    return List.generate(
      maps.length,
      (i) => CheckOutRecord.fromMap(maps[i]),
    );
  }

  // Session Operations
  Future<List<AttendanceSession>> getAllSessions() async {
    final checkIns = await getAllCheckIns();
    final sessions = <AttendanceSession>[];

    for (final checkIn in checkIns) {
      final checkOut = await getCheckOutByCheckinId(checkIn.checkinId);
      sessions.add(AttendanceSession(checkIn: checkIn, checkOut: checkOut));
    }

    return sessions;
  }

  Future<void> clearAllData() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('checkins');
      await prefs.remove('checkouts');
      return;
    }
    final db = await database;
    await db.delete('checkout_records');
    await db.delete('checkin_records');
  }

  // Web storage helpers (simple JSON arrays in SharedPreferences)
  Future<List<Map<String, dynamic>>> _loadWebList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<bool> _saveWebList(
    String key,
    List<Map<String, dynamic>> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, jsonEncode(items));
  }
}

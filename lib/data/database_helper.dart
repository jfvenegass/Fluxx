import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fluxx_app.db');

    return await openDatabase(
      path,
      version: 2, // Incrementar la versión para activar onUpgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crear tabla para usuarios
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Crear tabla para actividades booleanas
    await db.execute('''
      CREATE TABLE boolean_activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        isChecked INTEGER NOT NULL
      )
    ''');

    // Crear tabla para actividades cuantitativas
    await db.execute('''
      CREATE TABLE quantitative_activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        initialCount INTEGER NOT NULL,
        currentCount INTEGER NOT NULL
      )
    ''');

    // Crear tabla para logros
    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    // Crear tabla para streak
    await db.execute('''
      CREATE TABLE streak (
        id INTEGER PRIMARY KEY,
        value INTEGER NOT NULL
      )
    ''');

    // Crear tabla para puntos totales
    await db.execute('''
      CREATE TABLE points (
        id INTEGER PRIMARY KEY,
        value INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Crear tabla streak si no existe
      await db.execute('''
        CREATE TABLE streak (
          id INTEGER PRIMARY KEY,
          value INTEGER NOT NULL
        )
      ''');

      // Crear tabla para puntos totales si no existe
      await db.execute('''
        CREATE TABLE points (
          id INTEGER PRIMARY KEY,
          value INTEGER NOT NULL
        )
      ''');
    }
  }

  // Métodos para manejar usuarios
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Métodos para actividades booleanas
  Future<void> insertBooleanActivity(Map<String, bool> activity) async {
    final db = await database;
    await db.insert('boolean_activities', {
      'name': activity.keys.first,
      'isChecked': activity.values.first ? 1 : 0,
    });
  }

  Future<List<Map<String, bool>>> getBooleanActivities() async {
    final db = await database;
    final result = await db.query('boolean_activities');
    return result
        .map((e) => {e['name'] as String: (e['isChecked'] as int) == 1})
        .toList();
  }

  Future<void> updateBooleanActivity(String name, bool isChecked) async {
    final db = await database;
    await db.update(
      'boolean_activities',
      {'isChecked': isChecked ? 1 : 0},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> deleteBooleanActivity(String name) async {
    final db = await database;
    await db.delete(
      'boolean_activities',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  // Métodos para actividades cuantitativas
  Future<void> insertQuantitativeActivity(Map<String, Map<String, int>> activity) async {
    final db = await database;
    await db.insert('quantitative_activities', {
      'name': activity.keys.first,
      'initialCount': activity.values.first['initial'],
      'currentCount': activity.values.first['current'],
    });
  }

  Future<List<Map<String, Map<String, int>>>> getQuantitativeActivities() async {
    final db = await database;
    final result = await db.query('quantitative_activities');
    return result.map((e) {
      return {
        e['name'] as String: {
          'initial': e['initialCount'] as int,
          'current': e['currentCount'] as int,
        },
      };
    }).toList();
  }

  Future<void> updateQuantitativeActivity(String name, int currentCount) async {
    final db = await database;
    await db.update(
      'quantitative_activities',
      {'currentCount': currentCount},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> deleteQuantitativeActivity(String name) async {
    final db = await database;
    await db.delete(
      'quantitative_activities',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  // Métodos para logros
  Future<void> insertAchievement(String name) async {
    final db = await database;
    await db.insert('achievements', {'name': name});
  }

  Future<List<String>> getAchievements() async {
    final db = await database;
    final result = await db.query('achievements');
    return result.map((e) => e['name'] as String).toList();
  }

  // Métodos para manejar streak
  Future<void> saveStreak(int streak) async {
    final db = await database;
    await db.insert('streak', {'id': 1, 'value': streak},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getStreak() async {
    final db = await database;
    final result = await db.query('streak', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first['value'] as int;
    }
    return 0;
  }

  // Métodos para manejar puntos totales
  Future<void> saveTotalPoints(int points) async {
    final db = await database;
    await db.insert('points', {'id': 1, 'value': points},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getTotalPoints() async {
    final db = await database;
    final result = await db.query('points', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first['value'] as int;
    }
    return 0;
  }
}




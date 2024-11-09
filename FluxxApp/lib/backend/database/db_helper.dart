import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      '$dbPath/fluxxapp.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // Obtener todos los registros de una tabla
  static Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Insertar un registro en una tabla
  static Future<void> insert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(tableName, data);
  }

  // Obtener información del usuario
  static Future<Map<String, dynamic>> getUserInfo() async {
    final db = await database;
    final result = await db.query('users', limit: 1);
    return result.isNotEmpty ? result.first : {};
  }

  // Guardar información del usuario
  static Future<void> saveUserInfo(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user);
  }
}

import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  // Inicializar y obtener la instancia de la base de datos
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Crear la base de datos y sus tablas
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      '$dbPath/fluxxapp.db',
      version: 2, // Incrementamos la versión para migraciones
      onUpgrade: _onUpgrade,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE, -- Email único para evitar duplicados
            password TEXT -- Nueva columna para almacenar contraseñas
          )
        ''');
        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            type TEXT,
            status INTEGER,
            initial_count INTEGER,
            current_count INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE achievements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            unlocked INTEGER
          )
        ''');
      },
    );
  }

  // Manejo de migraciones
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migración de la versión 1 a la 2: añadir columna 'password' a la tabla 'users'
      await db.execute('ALTER TABLE users ADD COLUMN password TEXT');
    }
  }

  // Insertar un registro en cualquier tabla
  static Future<void> insert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplaza si hay conflictos
    );
  }

  // Obtener todos los registros de una tabla
  static Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Obtener un usuario por email
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Obtener información del usuario actual (primer registro)
  static Future<Map<String, dynamic>> getUserInfo() async {
    final db = await database;
    final result = await db.query('users', limit: 1);
    return result.isNotEmpty ? result.first : {};
  }

  // Guardar la información del usuario
  static Future<void> saveUserInfo(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace, // Evitar duplicados
    );
  }

  // Actualizar un registro en cualquier tabla
  static Future<void> update(
      String tableName, Map<String, dynamic> data, String where, List whereArgs) async {
    final db = await database;
    await db.update(
      tableName,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  // Eliminar un registro de cualquier tabla
  static Future<void> delete(String tableName, String where, List whereArgs) async {
    final db = await database;
    await db.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }
}

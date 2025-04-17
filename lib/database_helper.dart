import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'quote.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quotes.db');
    return _database!;
  }

  Future<void> deleteDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quotes.db');
    
    if (await File(path).exists()) {
      await File(path).delete();
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quotes(
        id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        userId TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        imagePath TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        profilePicture TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  // Quote methods
  Future<String> insertQuote(Quote quote) async {
    final db = await database;
    await db.insert('quotes', quote.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);
    return quote.id;
  }

  Future<Quote?> getQuote(String id) async {
    final db = await database;
    final maps = await db.query(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Quote>> getAllQuotes() async {
    final db = await database;
    final result = await db.query('quotes', orderBy: 'updatedAt DESC');
    return result.map((map) => Quote.fromMap(map)).toList();
  }

  Future<int> updateQuote(Quote quote) async {
    final db = await database;
    return db.update(
      'quotes',
      quote.toMap(),
      where: 'id = ?',
      whereArgs: [quote.id],
    );
  }

  Future<int> deleteQuote(String id) async {
    final db = await database;
    return await db.delete(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<String> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    return user.id;
  }
  
  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
  
  Future<User?> getUserByUserId(String userId) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
  
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users', orderBy: 'name ASC');
    return result.map((map) => User.fromMap(map)).toList();
  }
  
  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  
  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
import 'dart:async';

import 'package:flutter_project/logic/user_repo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserRepoManeger implements UserRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users(
            email TEXT PRIMARY KEY,
            password TEXT NOT NULL,
            name TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<void> registrationUser(String email, String password, String name) 
  async {
    final db = await database;

    await db.insert(
      'users',
      {'email': email, 'password': password, 'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Метод для отримання всіх користувачів
  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Метод для очищення бази даних
  @override
  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users');
  }
}

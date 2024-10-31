
import 'package:flutter_project/logic/books.dart';
import 'package:flutter_project/logic/books_repo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookRepositoryImpl implements BookRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            currentPage INTEGER,
            totalPages INTEGER,
            isRead INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<void> addBook(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap());
  }

  @override
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update('books', book.toMap(), where: 'id = ?',
    whereArgs: [book.id],);
  }

  @override
  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:flutter_project/logic/books.dart';

abstract class BookRepository {
  Future<void> addBook(Book book);
  Future<List<Book>> getAllBooks();
  Future<void> updateBook(Book book);
  Future<void> deleteBook(int id);
}

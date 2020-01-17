import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flash/book.dart';
import 'package:flash/flashcard.dart';

class DbProvider {
  static Database _db;
  static DbProvider _cache = DbProvider._internal();
  String path = "";

  factory DbProvider() {
    return _cache;
  }
  DbProvider._internal();

  Future<Database> get database async {
    if (_db == null) {
      //dbDir = await getDatabasesPath();
      Directory dbDir = await getExternalStorageDirectory();
      path = join(dbDir.path, "flash.db");

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database newDb, int version) {
          newDb.execute("""
              CREATE TABLE book
                (
                  book_id INTEGER PRIMARY KEY,
                  title TEXT
                )
              """);
          newDb.execute("""
              CREATE TABLE card
                (
                  card_id INTEGER PRIMARY KEY,
                  book_id INTEGER, 
                  question TEXT,
                  answer TEXT,
                  FOREIGN KEY (book_id) REFERENCES book(book_id) 
                )
              """);
        },
      );
    }

    return _db;
  }

  Future<void> clearDB() async {
    deleteDatabase(path);
  }

  Future<int> addBook(Book data) async {
    return await _db.insert('book', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteBook(int index) async {
    await _db.delete('book', where: 'book_id = ?', whereArgs: [index]);
  }

  Future<void> updateBook(Book data, int index) async {
    await _db
        .update('book', data.toMap(), where: 'book_id = ?', whereArgs: [index]);
  }

  Future<int> insertCard(Flashcard data) async {
    return await _db.insert('card', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCard(int index) async {
    await _db.delete('card', where: 'card_id = ?', whereArgs: [index]);
  }

  Future<void> updateCard(Flashcard data, int index) async {
    await _db
        .update('card', data.toMap(), where: 'card_id = ?', whereArgs: [index]);
  }

  Future<List<Book>> getBookAll() async {
    List<Map<String, dynamic>> maps = await _db.query('book');
    return List.generate(maps.length, (i) {
      return Book(
        book_id: maps[i]['book_id'],
        title: maps[i]['title'],
      );
    });
  }

  Future<String> getBookTitle(int index) async {
    List<Map<String, dynamic>> maps =
        await _db.query('book', where: 'book_id = ?', whereArgs: [index]);
    return maps.length > 0 ? maps[0]['title'] : "";
  }

  Future<List<Flashcard>> getCardAll(int index) async {
    List<Map<String, dynamic>> maps =
        await _db.query('card', where: 'book_id = ?', whereArgs: [index]);
    return List.generate(maps.length, (i) {
      return Flashcard(
          card_id: maps[i]['card_id'],
          book_id: maps[i]['book_id'],
          question: maps[i]['question'],
          answer: maps[i]['answer']);
    });
  }
}

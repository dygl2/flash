import 'package:flash/flashcard.dart';

class Book {
  int book_id;
  String title;

  Book({this.book_id, this.title});

  Map<String, dynamic> toMap() {
    return {
      'book_id': book_id,
      'title': title,
    };
  }
}

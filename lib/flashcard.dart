class Flashcard {
  int card_id;
  int book_id;
  String question;
  String answer;

  Flashcard({this.card_id, this.book_id, this.question, this.answer});

  Map<String, dynamic> toMap() {
    return {
      'card_id': card_id,
      'book_id': book_id,
      'question': question,
      'answer': answer,
    };
  }
}

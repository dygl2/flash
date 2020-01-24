import 'package:flash/flashcard.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PlayFlashcardPage extends StatefulWidget {
  String _book_title;
  List<Flashcard> _cards;
  bool _isFwdDir;

  PlayFlashcardPage(this._book_title, this._cards, this._isFwdDir);

  @override
  _PlayFlashcardPageState createState() =>
      _PlayFlashcardPageState(this._book_title, _cards, _isFwdDir);
}

class _PlayFlashcardPageState extends State<PlayFlashcardPage> {
  final String _book_title;
  final List<Flashcard> _cards;
  int _index = 0;
  bool _isAnswer;
  bool _isFwdDir;
  Random rdm;

  _PlayFlashcardPageState(this._book_title, this._cards, this._isFwdDir);

  void _init() async {
    rdm = new Random();
    _index = rdm.nextInt(_cards.length);
    _isAnswer = !_isFwdDir;

    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_book_title),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.pause_circle_outline),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (_isFwdDir == _isAnswer) {
              _index = rdm.nextInt(_cards.length);
            }
            _isAnswer = !_isAnswer;
          });
        },
        child: Center(
          child: Text(
            _isAnswer ? _cards[_index].answer : _cards[_index].question,
            style: TextStyle(
              fontSize: 40.0,
              fontStyle: _isAnswer ? FontStyle.italic : FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

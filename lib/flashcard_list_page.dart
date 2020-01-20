import 'package:flash/edit_card.dart';
import 'package:flash/flashcard.dart';
import 'package:flash/play_flashcard_page.dart';
import 'package:flutter/material.dart';
import 'package:flash/db_provider.dart';

class FlashcardListPage extends StatefulWidget {
  final int _book_id;
  final bool _isFwdDir;

  FlashcardListPage(this._book_id, this._isFwdDir);

  @override
  _FlashcardListPageState createState() =>
      _FlashcardListPageState(_book_id, _isFwdDir);
}

class _FlashcardListPageState extends State<FlashcardListPage> {
  final int _book_id;
  String _book_title;
  List<Flashcard> _cardList = [];
  int _index = 0;
  bool _isFwdDir;

  _FlashcardListPageState(this._book_id, this._isFwdDir);

  void _init() async {
    _book_title = await DbProvider().getBookTitle(_book_id);
    _cardList = await DbProvider().getCardAll(_book_id);

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
        leading: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.play_circle_outline),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return new PlayFlashcardPage(_book_title, _cardList, _isFwdDir);
              }));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _add();
        },
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView.builder(
              itemCount: _cardList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(_cardList[index].card_id.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      DbProvider().deleteCard(_cardList[index].card_id);
                      _cardList.removeAt(index);
                    });
                    if (direction == DismissDirection.endToStart) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted'),
                        ),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.orangeAccent,
                  ),
                  child: Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(_cardList[index].question),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _edit(_cardList[index], index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _add() {
    setState(() {
      _index = _cardList.length;
      int id = DateTime.now().millisecondsSinceEpoch;
      Flashcard card = new Flashcard(
          card_id: id, book_id: _book_id, question: "", answer: "");
      DbProvider().insertCard(card);
      _cardList.add(card);

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditCard(card, _onChanged);
      }));
    });
  }

  void _edit(Flashcard card, int index) {
    setState(() {
      _index = index;

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditCard(card, _onChanged);
      }));
    });
  }

  void _onChanged(Flashcard card) {
    setState(() {
      _cardList[_index].card_id = card.card_id;
      _cardList[_index].book_id = card.book_id;
      _cardList[_index].question = card.question;
      _cardList[_index].answer = card.answer;

      DbProvider().updateCard(card, _cardList[_index].card_id);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flash/flashcard.dart';

class EditCard extends StatelessWidget {
  final Flashcard card;
  final Function onChanged;

  EditCard(this.card, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Card'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.check),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ],
        leading: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            new TextField(
              controller: TextEditingController(text: card.question),
              decoration: InputDecoration(
                labelText: "question",
              ),
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                card.question = text;
                onChanged(card);
              },
            ),
            new TextField(
              controller: TextEditingController(text: card.answer),
              decoration: InputDecoration(
                labelText: "answer",
              ),
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                card.answer = text;
                onChanged(card);
              },
            )
          ],
        ),
      ),
    );
  }
}

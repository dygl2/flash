import 'package:flutter/material.dart';
import 'package:flash/book.dart';

class EditBook extends StatelessWidget {
  final Book book;
  final Function onChanged;

  EditBook(this.book, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Book'),
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
              controller: TextEditingController(text: book.title),
              decoration: InputDecoration(
                labelText: "title",
              ),
              style: new TextStyle(color: Colors.black),
              onChanged: (text) {
                book.title = text;
                onChanged(book);
              },
            ),
          ],
        ),
      ),
    );
  }
}

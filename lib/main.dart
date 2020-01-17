import 'package:flash/flashcard_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flash/db_provider.dart';
import 'package:flash/book.dart';
import 'package:flash/flashcard.dart';
import 'package:flash/edit_card.dart';
import 'package:flash/edit_book.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flash';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListPage(),
    );
  }
}

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  DbProvider db = DbProvider();
  List<Book> _bookList = [];
  int _index = 0;

  void _init() async {
    await db.database;
    _bookList = await DbProvider().getBookAll();

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
        title: Text('Flash'),
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
              itemCount: _bookList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(_bookList[index].book_id.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      DbProvider().deleteBook(_bookList[index].book_id);
                      _bookList.removeAt(index);
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
                              child: Text(_bookList[index].title),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                              return new FlashcardListPage(
                                  _bookList[index].book_id);
                            }));
                          });
                        }),
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
      _index = _bookList.length;
      int id = DateTime.now().millisecondsSinceEpoch;
      Book book = new Book(book_id: id, title: "");
      DbProvider().addBook(book);
      _bookList.add(book);

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditBook(book, _onChanged);
      }));
    });
  }

  void _edit(Book book, int index) {
    setState(() {
      _index = index;

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditBook(book, _onChanged);
      }));
    });
  }

  void _onChanged(Book book) {
    setState(() {
      _bookList[_index].book_id = book.book_id;
      _bookList[_index].title = book.title;

      DbProvider().updateBook(book, _bookList[_index].book_id);
    });
  }
}

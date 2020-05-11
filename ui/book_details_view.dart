import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';

class BookDetailsView extends StatelessWidget {
  final Book book;

  BookDetailsView({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Text('Title'),
          title: Text(book.title),
        ),
      ],
    );
  }

  Widget getListTile(String title, String info) {
    return ListTile();
  }
}

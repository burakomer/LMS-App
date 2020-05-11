import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';

class BookSearchResultsView extends StatelessWidget {
  BookSearchResultsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Book> searchResults = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.book),
              title: Text(searchResults[index].title ?? 'null'),
              subtitle: Text('ISBN: ' + searchResults[index].isbn.toString()),
            );
          }),
    );
  }
}

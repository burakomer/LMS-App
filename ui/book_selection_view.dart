import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';

class BookSelectionView extends StatefulWidget {
  BookSelectionView({Key key}) : super(key: key);

  @override
  _BookSelectionViewState createState() => _BookSelectionViewState();
}

class _BookSelectionViewState extends State<BookSelectionView> {
  List<Book> booksSelected = List<Book>();

  @override
  Widget build(BuildContext context) {
    final List<Book> searchResults = ModalRoute.of(context).settings.arguments;
    searchResults.removeWhere((book) => book.currentStock <= 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Books'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop(booksSelected);
        },
        label: Row(children: <Widget>[Icon(Icons.check), Text('Confirm')]),
      ),
      body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.book),
              title: Text(searchResults[index].title ?? 'null'),
              subtitle: Text('ISBN: ' + searchResults[index].isbn.toString()),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    booksSelected.add(searchResults[
                        index]); // Add to the selected books list.
                    searchResults.removeAt(index); // Remove from the list view.
                  });
                },
              ),
            );
          }),
    );
  }
}

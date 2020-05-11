import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';
import 'package:lms_project/services/database_service.dart';
import 'package:lms_project/ui/widgets/my_text_field.dart';

class BookSearchView extends StatefulWidget {
  BookSearchView({Key key}) : super(key: key);

  @override
  _BookSearchViewState createState() => _BookSearchViewState();
}

class _BookSearchViewState extends State<BookSearchView> {
  bool busy = false;

  TextEditingController titleField = TextEditingController();
  TextEditingController isbnField = TextEditingController();
  TextEditingController pageCountField = TextEditingController();
  TextEditingController currentStockField = TextEditingController();
  TextEditingController totalStockField = TextEditingController();
  TextEditingController authorField = TextEditingController();
  TextEditingController editorField = TextEditingController();
  TextEditingController publishYearField = TextEditingController();
  TextEditingController publisherField = TextEditingController();
  TextEditingController editionField = TextEditingController();
  TextEditingController languageField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String resultsRoute = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Book Search'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              busy = true;
            });
            var bookSnapshots = await DatabaseService.instance.findBooks(
              title: titleField.text.isEmpty ? '' : titleField.text,
              isbn: isbnField.text.isEmpty ? -1 : int.parse(isbnField.text),
              pageCount: pageCountField.text.isEmpty
                  ? -1
                  : int.parse(pageCountField.text),
              currentStock: currentStockField.text.isEmpty
                  ? -1
                  : int.parse(currentStockField.text),
              totalStock: totalStockField.text.isEmpty
                  ? -1
                  : int.parse(totalStockField.text),
              author: authorField.text.isEmpty ? '' : authorField.text,
              editor: editorField.text.isEmpty ? '' : editorField.text,
              publishYear: publishYearField.text.isEmpty
                  ? -1
                  : int.parse(publishYearField.text),
              publisher: publisherField.text.isEmpty ? '' : publisherField.text,
              edition: editionField.text.isEmpty 
                  ? -1
                  : int.parse(editionField.text),
              language: languageField.text.isEmpty ? '' : languageField.text,
            );

            List<Book> results = List<Book>();
            bookSnapshots
                .forEach((book) => results.add(Book.fromMap(book.data, uid: book.documentID)));

            openResultsView(routeName: resultsRoute, arguments: results);

            setState(() {
              busy = false;
            });
          },
          child: Icon(Icons.search),
        ),
        body: getBody());
  }

  void openResultsView({String routeName, Object arguments}) async {
    var data =
        await Navigator.of(context).pushNamed(routeName, arguments: arguments);
    if (data != null) {
      Navigator.of(context).pop(data);
    }
  }

  Widget getBody() {
    if (busy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: <Widget>[
          MyTextField('Title', titleField),
          MyTextField('ISBN', isbnField),
          MyTextField('Page Count', pageCountField),
          MyTextField('Current Stock', currentStockField),
          MyTextField('Total Stock', totalStockField),
          MyTextField('Author', authorField),
          MyTextField('Editor', editorField),
          MyTextField('Publish Year', publishYearField),
          MyTextField('Publisher', publisherField),
          MyTextField('Edition', editionField),
          MyTextField('Language', languageField),
        ],
      );
    }
  }
}

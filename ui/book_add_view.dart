import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';
import 'package:lms_project/services/database_service.dart';
import 'package:lms_project/ui/widgets/my_text_field.dart';

class BookAddView extends StatefulWidget {
  BookAddView({Key key}) : super(key: key);

  @override
  _BookAddViewState createState() => _BookAddViewState();
}

class _BookAddViewState extends State<BookAddView> {
  bool addingBook = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('New Book'),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addingBook
              ? null
              : () {
                  if (titleField.text.isEmpty ||
                      isbnField.text.isEmpty ||
                      pageCountField.text.isEmpty ||
                      currentStockField.text.isEmpty ||
                      totalStockField.text.isEmpty) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Fields required: ' +
                          (titleField.text.isEmpty ? 'Title, ' : '') +
                          (isbnField.text.isEmpty ? 'ISBN, ' : '') +
                          (pageCountField.text.isEmpty ? 'Page Count, ' : '') +
                          (currentStockField.text.isEmpty
                              ? 'Current Stock, '
                              : '') +
                          (totalStockField.text.isEmpty ? 'Total Stock' : '')),
                    ));
                    return;
                  }

                  setState(() {
                    addingBook = true;
                  });

                  DatabaseService.instance.addBook(
                      book: Book(
                        int.parse(isbnField.text),
                        titleField.text,
                        int.parse(pageCountField.text),
                        int.parse(currentStockField.text),
                        int.parse(totalStockField.text),
                        author: authorField.text,
                        editor: editorField.text,
                        publishYear: int.parse(publishYearField.text),
                        publisher: publisherField.text,
                        edition: int.parse(editionField.text),
                        language: languageField.text,
                      ),
                      onSuccess: () {
                        Navigator.of(context).pop();
                        setState(() {
                          addingBook = false;
                        });
                      },
                      onFailure: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: ListTile(
                              leading: Icon(Icons.error),
                              title: Text('Error adding borrower.')),
                        ));
                        setState(() {
                          addingBook = false;
                        });
                      });
                },
        ),
      ),
      body: ListView(
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
      ),
    );
  }
}

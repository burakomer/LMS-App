import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';
import 'package:lms_project/models/borrower_model.dart';
import 'package:lms_project/services/database_service.dart';
import 'package:lms_project/ui/widgets/my_text_field.dart';

class BorrowerAddView extends StatefulWidget {
  BorrowerAddView({Key key}) : super(key: key);

  @override
  _BorrowerAddViewState createState() => _BorrowerAddViewState();
}

class _BorrowerAddViewState extends State<BorrowerAddView> {
  bool addingBorrower = false;

  TextEditingController borrowerNameField = TextEditingController();
  TextEditingController borrowerSurnameField = TextEditingController();

  DateTime borrowDate = DateTime.now();
  DateTime borrowDueDate = DateTime.now();
  bool dueDateSelected = false;

  List<Book> booksSelected = List<Book>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Borrower'),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.person_add),
          onPressed: addingBorrower
              ? null
              : () {
                  if (borrowerNameField.text.isEmpty ||
                      borrowerSurnameField.text.isEmpty ||
                      dueDateSelected) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Fields required: ' +
                          (borrowerNameField.text.isEmpty ? 'Name, ' : '') +
                          (borrowerSurnameField.text.isEmpty
                              ? 'Surname, '
                              : '') +
                          (dueDateSelected ? 'Due Date' : '')),
                    ));
                    return;
                  }

                  setState(() {
                    addingBorrower = true;
                  });

                  List<String> bookUidList = List<String>();
                  booksSelected.forEach((book) => bookUidList.add(book.uid));

                  DatabaseService.instance.addBorrower(
                      borrower: Borrower(
                          borrowerNameField.text,
                          borrowerSurnameField.text,
                          borrowDate,
                          borrowDueDate,
                          bookUidList),
                      onSuccess: () {
                        Navigator.of(context).pop();
                        setState(() {
                          addingBorrower = false;
                        });
                      },
                      onFailure: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: ListTile(
                              leading: Icon(Icons.error),
                              title: Text('Error adding borrower.')),
                        ));
                        setState(() {
                          addingBorrower = false;
                        });
                      });
                },
        ),
      ),
      body: ListView(
        children: <Widget>[
          MyTextField('Name', borrowerNameField),
          MyTextField('Surname', borrowerSurnameField),
          Container(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text(
                'Select Due Date',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => selectDueDate(context),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text(
                'Choose Books',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => openBookSearchView(),
            ),
          ),
          Container(
              height: 200,
              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: ListView.builder(
                  itemCount: booksSelected.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.book),
                      title: Text(booksSelected[index].title ?? 'null'),
                      subtitle:
                          Text('ISBN: ' + booksSelected[index].isbn.toString()),
                    );
                  }))
        ],
      ),
    );
  }

  Future<Null> selectDueDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: borrowDueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != borrowDueDate)
      setState(() {
        borrowDueDate = picked;
      });
  }

  void openBookSearchView() async {
    final books = await Navigator.pushNamed(context, 'bookSearch',
        arguments: 'bookSelection');
    updateBookList(books);
  }

  void updateBookList(List<Book> books) async {
    setState(() {
      booksSelected = books;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:lms_project/models/borrower_model.dart';
import 'package:lms_project/services/database_service.dart';
import 'package:lms_project/ui/widgets/my_text_field.dart';

class BorrowerDetailsView extends StatefulWidget {
  BorrowerDetailsView({Key key}) : super(key: key);

  @override
  _BorrowerDetailsViewState createState() => _BorrowerDetailsViewState();
}

class _BorrowerDetailsViewState extends State<BorrowerDetailsView> {
  bool fieldsEnabled = false;

  TextEditingController nameField = TextEditingController();
  TextEditingController surnameField = TextEditingController();
  TextEditingController dueDateField = TextEditingController();

  DateTime borrowDate;
  DateTime borrowDueDate;
  bool dueDatePicked = false;

  @override
  Widget build(BuildContext context) {
    final Borrower borrower = ModalRoute.of(context).settings.arguments;
    borrowDate = borrower.borrowDate;
    borrowDueDate = dueDatePicked ? borrowDueDate : borrower.borrowDueDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(borrower.name + ' ' + borrower.surname),
        actions: <Widget>[
          IconButton(
            icon: Icon(fieldsEnabled ? Icons.cancel : Icons.edit),
            onPressed: () {
              setState(() {
                fieldsEnabled = !fieldsEnabled;

                if (!fieldsEnabled) {
                  nameField.text = '';
                  surnameField.text = '';
                }
              });
            },
          )
        ],
      ),
      floatingActionButton: fieldsEnabled
          ? FloatingActionButton.extended(
              onPressed: () async {
                bool success = await DatabaseService.instance.updateBorrower(
                    borrowerDocID: borrower.uid,
                    updatedBorrower: Borrower(
                      nameField.text.isNotEmpty
                          ? nameField.text
                          : borrower.name,
                      surnameField.text.isNotEmpty
                          ? surnameField.text
                          : borrower.surname,
                      borrowDate,
                      borrowDueDate,
                      borrower.books,
                    ));
                if (success) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName('borrowerSearch'));
                }
              },
              label: Row(
                children: <Widget>[Icon(Icons.check), Text(' Update Data')],
              ),
            )
          : null,
      body: ListView(
        children: <Widget>[
          MyTextField(
            'Name',
            nameField,
            enabled: fieldsEnabled,
            enabledHintText: borrower.name,
            disabledHintText: borrower.name,
          ),
          MyTextField(
            'Surname',
            surnameField,
            enabled: fieldsEnabled,
            enabledHintText: borrower.surname,
            disabledHintText: borrower.surname,
          ),
          MyTextField(
            'Due Date',
            dueDateField,
            enabled: false,
            enabledHintText: borrowDueDate.toString().split(' ')[0],
            disabledHintText: borrowDueDate.toString().split(' ')[0],
            onTap: () => fieldsEnabled ? selectDueDate(context) : null,
            fillOnTap: false,
            trailing: fieldsEnabled
                ? IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => selectDueDate(context),
                  )
                : SizedBox(),
          ),
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
        dueDatePicked = true;
        borrowDueDate = picked;
      });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_project/models/borrower_model.dart';
import 'package:lms_project/services/database_service.dart';
import 'package:lms_project/ui/widgets/my_text_field.dart';

class BorrowerSearchView extends StatefulWidget {
  BorrowerSearchView({Key key}) : super(key: key);

  @override
  _BorrowerSearchViewState createState() => _BorrowerSearchViewState();
}

class _BorrowerSearchViewState extends State<BorrowerSearchView> {
  bool busy = false;

  TextEditingController nameField = TextEditingController();
  TextEditingController surnameField = TextEditingController();

  DateTime dueDate = DateTime.now();
  int pickedDateInMilliseconds = -1;
  String dueDateSearchType;

  final List<String> dateSearchTypes = <String>[
    'lessThan',
    'greaterThan',
    'equalTo'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrower Search'),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: busy
              ? null
              : () async {
                  setState(() {
                    busy = true;
                  });
                  var borrowersFromName =
                      await DatabaseService.instance.findBorrowersByName(
                    name: nameField.text.isEmpty ? '' : nameField.text,
                    surname: surnameField.text.isEmpty ? '' : surnameField.text,
                  );
                  var borrowersFromDueDate = await DatabaseService.instance
                      .findBorrowersByDueDate(
                          dueDateUnix: pickedDateInMilliseconds,
                          lessThan: dueDateSearchType == 'lessThan',
                          greaterThan: dueDateSearchType == 'greaterThan',
                          equalTo: dueDateSearchType == 'equalTo');

                  List<Borrower> resultsFromName = List<Borrower>();
                  List<Borrower> resultsFromDueDate = List<Borrower>();

                  borrowersFromName.forEach((borrower) => resultsFromName.add(
                      Borrower.fromMap(borrower.data,
                          uid: borrower.documentID)));
                  borrowersFromDueDate.forEach((borrower) =>
                      resultsFromDueDate.add(Borrower.fromMap(borrower.data,
                          uid: borrower.documentID)));

                  List<Borrower> toBeRemoved = List<Borrower>();

                  resultsFromName.forEach((element1) {
                    if (resultsFromDueDate.firstWhere(
                            (element2) => element1 == element2, orElse: () {
                          return null;
                        }) ==
                        null) {
                      toBeRemoved.add(element1);
                    }
                  });

                  toBeRemoved
                      .forEach((element) => resultsFromName.remove(element));
                  toBeRemoved.clear();

                  Navigator.of(context).pushNamed('borrowerSearchResults',
                      arguments: resultsFromName);

                  setState(() {
                    busy = false;
                  });
                }),
    );
  }

  Widget getBody() {
    if (busy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: <Widget>[
          MyTextField('Name', nameField),
          MyTextField('Surname', surnameField),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text('Select a Date'),
                    onPressed: () => selectDueDate(context),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                DropdownButton(
                  value: dueDateSearchType,
                  onChanged: (String value) {
                    setState(() {
                      dueDateSearchType = value;
                    });
                  },
                  items: dateSearchTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 5.0,
                ),
                MaterialButton(
                  color: Colors.red,
                  child: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      pickedDateInMilliseconds = -1;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Future<Null> selectDueDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dueDate)
      setState(() {
        dueDate = picked;
        pickedDateInMilliseconds = picked.millisecondsSinceEpoch;
        debugPrint(pickedDateInMilliseconds.toString());
      });
  }
}

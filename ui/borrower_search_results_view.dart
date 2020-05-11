import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_project/models/borrower_model.dart';
import 'package:lms_project/services/database_service.dart';

class BorrowerSearchResultsView extends StatefulWidget {
  BorrowerSearchResultsView({Key key}) : super(key: key);

  @override
  _BorrowerSearchResultsViewState createState() =>
      _BorrowerSearchResultsViewState();
}

class _BorrowerSearchResultsViewState extends State<BorrowerSearchResultsView> {
  @override
  Widget build(BuildContext context) {
    final List<Borrower> searchResults =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(searchResults[index].name +
                  ' ' +
                  searchResults[index].surname),
              subtitle: Text(searchResults[index].books.length.toString() +
                  ' books borrowed.'),
              onTap: () => Navigator.of(context).pushNamed('borrowerDetails',
                  arguments: searchResults[index]),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  bool success = await DatabaseService.instance.deleteBorrower(
                      borrowerDocID: searchResults[index].uid,
                      books: searchResults[index].books);
                  if (success) {
                    setState(() {
                      searchResults.removeAt(index);
                    });
                  }
                },
              ),
            );
          }),
    );
  }
}

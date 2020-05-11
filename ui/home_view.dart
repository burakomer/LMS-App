import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';
import 'package:lms_project/services/database_service.dart';
import 'package:lms_project/ui/widgets/fancy_fab.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      /*
      floatingActionButton: FloatingActionButton(onPressed: () {
        var data = jsonDecode(Book.sampleBooks);
        List<Map<String, dynamic>> books =
            data['books'].cast<Map<String, dynamic>>();

        books.forEach((element) {
          //debugPrint(element.toString());
          DatabaseService.instance.addBook(book: Book.fromMap(element));
        });
      }),
      */
      floatingActionButton: FancyFab(color: Theme.of(context).primaryColor),
      body: getBookList(context),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 64,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.pushNamed(context, 'bookAdd'),
              ),
              IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () => Navigator.pushNamed(context, 'borrowerAdd'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBookList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.bookCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else if (snapshot.data == null) {
            return Center(child: Text('ERROR'));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  Book book = Book.fromMap(snapshot.data.documents[index].data);
                  return ListTile(
                    leading: Icon(Icons.book),
                    title: Text(book.title ?? 'null'),
                    subtitle: Text('ISBN: ' + book.isbn.toString()),
                  );
                });
          }
        });
  }
}

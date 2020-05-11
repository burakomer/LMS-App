import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_project/models/book_model.dart';
import 'package:lms_project/models/borrower_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService();

  CollectionReference bookCollection = Firestore.instance.collection('books');
  CollectionReference borrowerCollection =
      Firestore.instance.collection('borrowers');

  void addBook({Book book, Function onSuccess, Function onFailure}) {
    Firestore.instance.runTransaction((transaction) async {
      var matchedBooks = await bookCollection
          .where('isbn', isEqualTo: book.isbn)
          .limit(1)
          .getDocuments();

      // Check if there is any match
      if (matchedBooks.documents.length > 0) {
        // If there's a match, the book exists. Execute the onFailure function.
        if (onFailure != null) onFailure();
      } else {
        // If there's not a match, create the book.
        try {
          await transaction.set(bookCollection.document(), book.toMap());
          if (onSuccess != null) onSuccess();
        } on Exception catch (e) {
          debugPrint(e.toString());
          if (onFailure != null) onFailure();
        }
      }
    });
  }

  void addBorrower(
      {Borrower borrower, Function onSuccess, Function onFailure}) {
    Firestore.instance.runTransaction((transaction) async {
      try {
        // First, get the books that are borrowed.
        List<DocumentSnapshot> bookSnaps = List<DocumentSnapshot>();
        await Future.forEach(borrower.books, (uid) async {
          var bookSnap = await transaction.get(bookCollection.document(uid));
          bookSnaps.add(bookSnap);
        });

        // Then, try to update their current stocks
        await Future.forEach(bookSnaps, (bookSnap) {
          var newData = bookSnap.data;

          // Decrease the current stock by one.
          newData['currentStock'] -= 1;

          // Update the database.
          transaction.update(bookSnap.reference, newData);
        });

        // Get a document reference with a random id.
        DocumentReference borrowerRef = borrowerCollection.document();

        // Finally, create the borrower document.
        await transaction.set(borrowerRef, borrower.toMap());

        if (onSuccess != null) onSuccess();
      } on Exception catch (e) {
        debugPrint(e.toString());
        if (onFailure != null) onFailure();
      }
    });
  }

  void updateBook({int isbn, Book updatedBook}) {
    Firestore.instance.runTransaction((transaction) async {
      var matchedBooks = await bookCollection
          .where('isbn', isEqualTo: isbn)
          .limit(1)
          .getDocuments();

      // Check if there is any match
      if (matchedBooks.documents.length > 0) {
        // If there's a match, update the book.
        Book bookToUpdate = Book.fromMap(matchedBooks.documents[0].data);

        var newBook = Book.updateBook(bookToUpdate, updatedBook);
      }
    });
  }

  Future<bool> updateBorrower(
      {@required String borrowerDocID,
      @required Borrower updatedBorrower}) async {
    bool success = true;

    await Firestore.instance.runTransaction((transaction) async {
      var borrowerSnap =
          await transaction.get(borrowerCollection.document(borrowerDocID));
      await transaction.set(borrowerSnap.reference, updatedBorrower.toMap());
    }).catchError((e) {
      success = false;
    });
    return success;
  }

  Future<bool> deleteBorrower(
      {@required String borrowerDocID, @required List<String> books}) async {
    bool success = true;
    await Firestore.instance.runTransaction((transaction) async {
      // Prepare the borrower document.
      var borrowerSnap =
          await transaction.get(borrowerCollection.document(borrowerDocID));

      List<DocumentSnapshot> bookSnaps = List<DocumentSnapshot>();
      // Get the borrowed books documents first.
      await Future.forEach(books, (uid) async {
        var bookSnap = await transaction.get(bookCollection.document(uid));
        bookSnaps.add(bookSnap);
      });

      // Then update their values.
      await Future.forEach(bookSnaps, (bookSnap) async {
        var newData = bookSnap.data;

        // Increase the current stock by one.
        newData['currentStock'] += 1;

        // Update the database.
        transaction.update(bookSnap.reference, newData);
      });

      // Lastly, delete the borrower.
      await transaction.delete(borrowerSnap.reference);
    }).catchError((e) {
      success = false;
    });
    return success;
  }

  Future<List<DocumentSnapshot>> findBooks({
    String title,
    int isbn: -1,
    int pageCount: -1,
    int currentStock: -1,
    int totalStock: -1,
    int publishYear: -1,
    String author: '',
    String editor: '',
    String publisher: '',
    int edition: -1,
    String language: '',
    int limit: 999,
  }) async {
    Query query = bookCollection;
    if (title.isNotEmpty) {
      query = query.where('title', isEqualTo: title);
    }
    if (isbn >= 0) {
      query = query.where('isbn', isEqualTo: isbn);
    }
    if (pageCount >= 0) {
      query = query.where('pageCount', isEqualTo: pageCount);
    }
    if (currentStock >= 0) {
      query = query.where('amountInLibrary', isEqualTo: currentStock);
    }
    if (totalStock >= 0) {
      query = query.where('amountTotal', isEqualTo: totalStock);
    }
    if (publishYear >= 0) {
      query = query.where('publishYear', isEqualTo: publishYear);
    }
    if (author.isNotEmpty) {
      query = query.where('author', isEqualTo: author);
    }
    if (editor.isNotEmpty) {
      query = query.where('editor', isEqualTo: editor);
    }
    if (publisher.isNotEmpty) {
      query = query.where('publisher', isEqualTo: publisher);
    }
    if (edition >= 0) {
      query = query.where('edition', isEqualTo: edition);
    }
    if (language.isNotEmpty) {
      query = query.where('language', isEqualTo: language);
    }

    try {
      var books = await query.limit(limit).getDocuments();
      return books.documents;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return List<DocumentSnapshot>();
    }
  }

  Future<List<DocumentSnapshot>> findBorrowersByName(
      {String name: '', String surname: ''}) async {
    Query query = borrowerCollection;
    if (name.isNotEmpty) {
      query = query.where('name', isEqualTo: name);
    }
    if (surname.isNotEmpty) {
      query = query.where('surname', isEqualTo: surname);
    }

    try {
      var borrowers = await query.getDocuments();
      return borrowers.documents;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return List<DocumentSnapshot>();
    }
  }

  /// Only set one bool to true.
  Future<List<DocumentSnapshot>> findBorrowersByDueDate(
      {int dueDateUnix: -1,
      bool lessThan: false,
      bool greaterThan: false,
      bool equalTo: false}) async {
    Query query = borrowerCollection;
    if (dueDateUnix > 0) {
      if (lessThan) {
        query = query.where('borrowDueDate', isLessThanOrEqualTo: dueDateUnix);
        greaterThan = false;
        equalTo = false;
      } else if (greaterThan) {
        query =
            query.where('borrowDueDate', isGreaterThanOrEqualTo: dueDateUnix);
        lessThan = false;
        equalTo = false;
      } else if (equalTo) {
        query = query.where('borrowDueDate', isEqualTo: dueDateUnix);
        lessThan = false;
        greaterThan = false;
      }
    }

    try {
      var borrowers = await query.getDocuments();
      return borrowers.documents;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return List<DocumentSnapshot>();
    }
  }
}

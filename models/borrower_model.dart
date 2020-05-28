import 'package:equatable/equatable.dart';

class Borrower extends Equatable{
  final String uid;
  final String name;
  final String surname;
  final DateTime borrowDate;
  final DateTime borrowDueDate;
  final List<String> books; // Their document ID

  Borrower(
      this.name, this.surname, this.borrowDate, this.borrowDueDate, this.books, {this.uid: ''});

  Borrower.fromMap(Map<String, dynamic> map, {String uid: ''}) :
    this.name = map['name'],
    this.surname = map['surname'],
    this.borrowDate = DateTime.fromMillisecondsSinceEpoch(map['borrowDate']),
    this.borrowDueDate =
        DateTime.fromMillisecondsSinceEpoch(map['borrowDueDate']),
    this.books = map['books'].cast<String>(),
    this.uid = uid;
  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'borrowDate': borrowDate.millisecondsSinceEpoch,
      'borrowDueDate': borrowDueDate.millisecondsSinceEpoch,
      'books': books
    };
  }

  @override
  List<Object> get props => [name, surname, borrowDate, borrowDueDate];
}

/*
Sample
{
      "name": "Burak",
      "surname": "Ömer",
      "borrowDate": 1589204129254,
      "borrowDueDate": 1589403600000,
      "books": [
            "0hOtuqTJOOpxzWZGpv2O",
            "7WFCBJijOUF3pa9YUj3D",
            "NOfqMOZAYk3kaKtsPORo"
      ]
}
*/
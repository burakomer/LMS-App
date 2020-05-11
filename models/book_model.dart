class Book {
  int isbn;
  String title;
  int pageCount;
  int totalStock;
  int currentStock;
  String author;
  String editor;
  int publishYear;
  String publisher;
  int edition;
  String language;
  String uid;

  Book(
      this.isbn, this.title, this.pageCount, this.currentStock, this.totalStock,
      {this.author,
      this.editor,
      this.publishYear,
      this.publisher,
      this.edition,
      this.language,
      this.uid: ''});

  Book.fromMap(Map<String, dynamic> map, {String uid: ''}) {
    this.isbn = map['isbn'];
    this.title = map['title'];
    this.pageCount = map['pageCount'];
    this.currentStock = map['currentStock'];
    this.totalStock = map['totalStock'];
    this.editor = map['editor'];
    this.author = map['author'];
    this.publishYear = map['publishYear'];
    this.publisher = map['publisher'];
    this.edition = map['edition'];
    this.language = map['language'];
    this.uid = uid;
  }

  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'title': title,
      'pageCount': pageCount,
      'currentStock': currentStock,
      'totalStock': totalStock,
      'author': author,
      'editor': editor,
      'publishYear': publishYear,
      'publisher': publisher,
      'edition': edition,
      'language': language,
    };
  }

  static Book updateBook(Book bookToUpdate, Book updatedBook) {
    bookToUpdate.isbn = updatedBook.isbn > 0 ? updatedBook.isbn : bookToUpdate.isbn;
  
    return bookToUpdate;
  }

  static const String sampleBooks = '''{
  "books": [
    {
      "isbn": 9781593275846,
      "title": "Eloquent JavaScript, Second Edition",
      "author": "Marijn Haverbeke",
      "publishYear": 2014,
      "publisher": "No Starch Press",
      "pageCount": 472,
      "language": "English",
      "currentStock": 2, 
      "totalStock": 2,
      "editor": "John Walker",
      "edition": 1
    },
    {
      "isbn": 9781449331818,
      "title": "Learning JavaScript Design Patterns",
      "author": "Addy Osmani",
      "publishYear": 2012,
      "publisher": "O'Reilly Media",
      "pageCount": 254,
      "language": "English",
      "currentStock": 2,
      "totalStock": 2,
      "editor": "John Walker",
      "edition": 2
    },
    {
      "isbn": 9781449365035,
      "title": "Speaking JavaScript",
      "author": "Axel Rauschmayer",
      "publishYear": 2014,
      "publisher": "O'Reilly Media",
      "pageCount": 460,
      "language": "English",
      "currentStock": 2, 
      "totalStock": 2,
      "editor": "John Walker",
      "edition": 2
    },
    {
      "isbn": 9781491950296,
      "title": "Programming JavaScript Applications",
      "author": "Eric Elliott",
      "publishYear": 2014,
      "publisher": "O'Reilly Media",
      "pageCount": 254,
      "language": "English",
      "currentStock": 2,
      "totalStock": 2,
      "editor": "John Walker",
      "edition": 5
    },
    {
      "isbn": 9781593277574,
      "title": "Understanding ECMAScript 6",
      "author": "Nicholas C. Zakas",
      "publishYear": 2016,
      "publisher": "No Starch Press",
      "pageCount": 352,
      "language": "English",
      "currentStock": 2,
      "totalStock": 2,
      "editor": "Sebastian League",
      "edition": 4
    },
    {
      "isbn": 9781491904244,
      "title": "You Don't Know JS",
      "author": "Kyle Simpson",
      "publishYear": 2015,
      "publisher": "O'Reilly Media",
      "pageCount": 278,
      "language": "English",
      "currentStock": 2, 
      "totalStock": 2,
      "editor": "John Walker",
      "edition": 1
    },
    {
      "isbn": 9781449325862,
      "title": "Git Pocket Guide",
      "author": "Richard E. Silverman",
      "publishYear": 2013,
      "publisher": "O'Reilly Media",
      "pageCount": 234,
      "language": "English",
      "currentStock": 2, 
      "totalStock": 2,
      "editor": "Larry Comet",
      "edition": 3
    },
    {
      "isbn": 9781449337711,
      "title": "Designing Evolvable Web APIs with ASP.NET",
      "author": "Glenn Block, et al.",
      "publishYear": 2014,
      "publisher": "O'Reilly Media",
      "pageCount": 538,
      "language": "English",
      "currentStock": 2, 
      "totalStock": 2,
      "editor": "Larry Comet",
      "edition": 3
    }
  ]
}''';
}

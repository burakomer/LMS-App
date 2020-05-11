import 'package:flutter/material.dart';
import 'package:lms_project/ui/book_add_view.dart';
import 'package:lms_project/ui/book_search_results_view.dart';
import 'package:lms_project/ui/book_search_view.dart';
import 'package:lms_project/ui/book_selection_view.dart';
import 'package:lms_project/ui/borrower_add_view.dart';
import 'package:lms_project/ui/borrower_details_view.dart';
import 'package:lms_project/ui/borrower_search_results_view.dart';
import 'package:lms_project/ui/borrower_search_view.dart';
import 'package:lms_project/ui/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LMS Project',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomeView(title: 'Library Management System'),
      routes: {
        'home': (context) => HomeView(),
        'bookAdd': (context) => BookAddView(),
        'bookSearch': (context) => BookSearchView(),
        'bookSearchResults': (context) => BookSearchResultsView(),
        'borrowerAdd': (context) => BorrowerAddView(),
        'bookSelection': (context) => BookSelectionView(),
        'borrowerSearch': (context) => BorrowerSearchView(),
        'borrowerSearchResults': (context) => BorrowerSearchResultsView(),
        'borrowerDetails': (context) => BorrowerDetailsView(),
      },
    );
  }
}

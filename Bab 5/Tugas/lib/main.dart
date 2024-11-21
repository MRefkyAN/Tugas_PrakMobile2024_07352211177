import 'package:flutter/material.dart';
import 'pages/book_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Buku',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookListPage(),
    );
  }
}

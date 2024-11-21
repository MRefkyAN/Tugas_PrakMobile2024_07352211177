import 'package:flutter/material.dart';
import '/models/book.dart';
import '/services/api_services.dart';
import 'edit_book_page.dart';

class BookDetailPage extends StatelessWidget {
  final int id;

  BookDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Buku')),
      body: FutureBuilder<Book>(
        future: ApiService().fetchBookById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Buku tidak ditemukan'));
          } else {
            final book = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Judul: ${book.title}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Penulis: ${book.author}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Deskripsi:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 4),
                  Text(book.description, style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book: book),
                            ),
                          );
                        },
                        child: Text('Edit'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Hapus Buku'),
                              content: Text('Apakah Anda yakin ingin menghapus buku ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Tidak'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Ya'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await ApiService().deleteBook(id);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

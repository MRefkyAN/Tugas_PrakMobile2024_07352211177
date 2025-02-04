import 'package:flutter/material.dart';

class MataKuliahPage extends StatelessWidget {
  final List<String> mataKuliah = [
    "Pemrograman Mobile",
    "Basis Data",
    "Kecerdasan Buatan",
    "Jaringan Komputer",
    "Keamanan Jaringan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: mataKuliah.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0, // Remove shadow by setting elevation to 0
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.book,
                color: Colors.black,
                size: 40,
              ),
              title: Text(
                mataKuliah[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Menghapus trailing icon agar tidak ada tombol apapun
            ),
          );
        },
      ),
    );
  }
}

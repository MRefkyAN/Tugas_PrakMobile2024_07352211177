import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://crud-f8a1c-default-rtdb.firebaseio.com/form.json'));

    if (response.statusCode == 200) {
      print(response.body); 
      setState(() {
        var decodedData = json.decode(response.body);
        if (decodedData is Map) {
          _data = decodedData.values.toList();
        } else {
          _data = decodedData;
        }
      });
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                var item = _data[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      "Nama: ${item['nama']}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("NPM: ${item['npm']}"),
                        Text("Semester: ${item['semester']}"),
                        Text("Mata Kuliah: ${item['mataKuliah']}"),
                        Text("Nilai: ${item['nilai']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

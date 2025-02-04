import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan2/pages/riwayat_pendaftaran_page.dart';

class FormPendaftaranPage extends StatefulWidget {
  @override
  _FormPendaftaranPageState createState() => _FormPendaftaranPageState();
}

class _FormPendaftaranPageState extends State<FormPendaftaranPage> {
  final List<String> mataKuliah = [
    "Pemrograman Mobile",
    "Basis Data",
    "Kecerdasan Buatan",
    "Jaringan Komputer",
    "Keamanan Jaringan",
  ];

  String? selectedCourse;
  String? selectedSemester;
  String? courseGrade;
  String? namaMahasiswa;
  String? npmMahasiswa;

  final List<String> semesterList = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8",
  ];

  final String databaseUrl =
      "https://crud-f8a1c-default-rtdb.firebaseio.com/form.json";

  Future<void> submitForm() async {
    if (namaMahasiswa == null ||
        namaMahasiswa!.isEmpty ||
        npmMahasiswa == null ||
        npmMahasiswa!.isEmpty ||
        selectedSemester == null ||
        selectedCourse == null ||
        courseGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap lengkapi semua data."),
        ),
      );
      return;
    }

    // Data yang akan dikirim ke Firebase
    final formData = {
      "nama": namaMahasiswa,
      "npm": npmMahasiswa,
      "semester": selectedSemester,
      "mataKuliah": selectedCourse,
      "nilai": courseGrade,
    };

    try {
      final response = await http.post(
        Uri.parse(databaseUrl),
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pendaftaran Berhasil"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan data: ${response.body}"),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Nama
              Text(
                "Nama Mahasiswa:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    namaMahasiswa = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Input NPM
              Text(
                "NPM Mahasiswa:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "NPM",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    npmMahasiswa = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Dropdown untuk memilih semester
              Text(
                "Pilih Semester:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedSemester,
                hint: Text("Pilih Semester"),
                items: semesterList.map((semester) {
                  return DropdownMenuItem(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSemester = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // RadioListTile untuk memilih satu mata kuliah
              Text(
                "Pilih Mata Kuliah:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mataKuliah.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    title: Text(mataKuliah[index]),
                    value: mataKuliah[index],
                    groupValue: selectedCourse,
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value;
                        courseGrade =
                            null; // Reset nilai jika mata kuliah berubah
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 16),

              // Input nilai hanya untuk mata kuliah yang dipilih
              if (selectedCourse != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nilai Mata Kuliah (${selectedCourse!}):",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nilai",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          courseGrade = value;
                        });
                      },
                    ),
                  ],
                ),
              SizedBox(height: 24),

              // Tombol daftar
              Center(
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5, // Efek bayangan
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

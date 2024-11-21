import 'package:flutter/material.dart';
import '/services/api_services.dart';

class AddBookPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Buku')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (value) => value!.isEmpty ? 'Judul harus diisi' : null,
              ),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Penulis'),
                validator: (value) => value!.isEmpty ? 'Penulis harus diisi' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Deskripsi harus diisi' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await ApiService().addBook(
                      titleController.text,
                      authorController.text,
                      descriptionController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Tambah Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

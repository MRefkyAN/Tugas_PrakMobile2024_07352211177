import 'package:flutter/material.dart';
import '/models/book.dart';
import '/services/api_services.dart';

class EditBookPage extends StatelessWidget {
  final Book book;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController descriptionController;

  EditBookPage({required this.book})
      : titleController = TextEditingController(text: book.title),
        authorController = TextEditingController(text: book.author),
        descriptionController = TextEditingController(text: book.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Buku')),
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
                    await ApiService().updateBook(
                      book.id,
                      titleController.text,
                      authorController.text,
                      descriptionController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

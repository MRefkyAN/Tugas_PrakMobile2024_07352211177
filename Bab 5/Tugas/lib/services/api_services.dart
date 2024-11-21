import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

const String baseUrl = "https://events.hmti.unkhair.ac.id/api";

class ApiService {
  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception("Gagal memuat buku");
    }
  }

  Future<Book> fetchBookById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$id'));
    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception("Buku tidak ditemukan");
    }
  }

  Future<void> addBook(String title, String author, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'author': author,
        'description': description,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception("Gagal menambahkan buku");
    }
  }

  Future<void> updateBook(
      int id, String title, String author, String description) async {
    final response = await http.put(
      Uri.parse('$baseUrl/books/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'author': author,
        'description': description,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Gagal memperbarui buku");
    }
  }

  Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/books/$id'));
    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus buku");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan2/partials/sidebar.dart';
import 'package:latihan2/home_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String apiUrl;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isSaving = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController? nameController;
  TextEditingController? npmController;
  TextEditingController? jurusanController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();
    apiUrl =
        "https://677a19ba671ca0306833119f.mockapi.io/user/${widget.userId}";
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          nameController = TextEditingController(text: userData!['name']);
          npmController = TextEditingController(text: userData!['npm']);
          jurusanController = TextEditingController(text: userData!['jurusan']);
          phoneController = TextEditingController(text: userData!['phone']);
          emailController = TextEditingController(text: userData!['email']);
          passwordController =
              TextEditingController(text: userData!['password']);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": nameController?.text,
          "npm": npmController?.text,
          "jurusan": jurusanController?.text,
          "phone": phoneController?.text,
          "email": emailController?.text,
          "password": passwordController?.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    } catch (e) {
      print("Error updating user data: $e");
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Sidebar(userId: widget.userId),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Name is required'
                          : null,
                      decoration: _inputDecoration("Enter your name"),
                    ),
                    const SizedBox(height: 20),
                    const Text("NPM"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: npmController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'NPM is required'
                          : null,
                      decoration: _inputDecoration("Enter your NPM"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Jurusan"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: jurusanController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Jurusan is required'
                          : null,
                      decoration: _inputDecoration("Enter your major"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Phone"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Phone number is required'
                          : null,
                      decoration: _inputDecoration("Enter your phone number"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Email"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Email is required'
                          : null,
                      decoration: _inputDecoration("Enter your email"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Password"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password is required'
                          : null,
                      decoration: _inputDecoration("Enter your password"),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: updateUserData,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(17.6),
                            ),
                            child: const Center(
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          if (isSaving)
                            Positioned(
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(17.6),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17.6),
      ),
    );
  }
}

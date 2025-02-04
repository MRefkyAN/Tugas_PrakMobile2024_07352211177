import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihan2/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAV8NiOyH0q2vFA-2I6oUV0uBgcboZoHnU",
            authDomain: "project1-2be1c.firebaseapp.com",
            projectId: "project1-2be1c",
            storageBucket: "project1-2be1c.firebasestorage.app",
            messagingSenderId: "507018990303",
            appId: "1:507018990303:web:ccf87328a229b3d6620f6a",
            measurementId: "G-S5T595TT11"));
    runApp(const MainApp());
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dialogBackgroundColor: const Color(0xfff5f5f5),
        scaffoldBackgroundColor: const Color(0xfff5f5f5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xfff5f5f5),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

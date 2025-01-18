import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pages/anggota/list.dart';
import 'pages/anggota/member_list.dart';
import 'pages/auth/login_form.dart';
import 'pages/auth/register_form.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/member/member_dashboard.dart';
import 'pages/member/member_about.dart';
import 'pages/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyOrmawa - Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginForm(),
        '/register': (context) => RegisterForm(),
        '/home': (context) => HomePage(),
        '/anggota/list': (context) => AnggotaListPage(),
        '/anggota/member_list': (context) => AnggotaListPages(),
        '/about': (context) => AboutPage(),
        '/member_dashboard': (context) => MemberHomePage(),
        '/member_about': (context) => AboutPageMember(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'pages/mata_kuliah_page.dart';
import 'pages/form_pendaftaran_page.dart';
import 'pages/riwayat_pendaftaran_page.dart';
import 'partials/sidebar.dart'; // Import Sidebar

class HomePage extends StatefulWidget {
  final String userId; // Menambahkan parameter userId

  const HomePage({Key? key, required this.userId}) : super(key: key); // Konstruktor untuk menerima userId

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BerandaPage(), // Halaman beranda
    MataKuliahPage(),
    FormPendaftaranPage(),
    DataPage(),
  ];

  final List<String> _titles = [
    'Pendaftaran Semester Pendek',
    'Daftar Mata Kuliah',
    'Form Pendaftaran SP',
    'Riwayat Pendaftaran SP',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Sidebar(userId: widget.userId),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -2), // Bayangan di atas
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Mata Kuliah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined),
              activeIcon: Icon(Icons.edit),
              label: 'Pendaftaran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/home.png', // Path gambar aset
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Text(
            'Selamat Datang di Aplikasi\nPendaftaran Semester Pendek',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Aplikasi ini membantu Anda mendaftarkan\nmata kuliah dengan mudah dan cepat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              final homePageState =
                  context.findAncestorStateOfType<_HomePageState>();
              if (homePageState != null) {
                homePageState.setState(() {
                  homePageState._currentIndex =
                      2; // Indeks halaman FormPendaftaranPage
                });
              }
            },
            child: Text(
              'Mulai Daftar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                  horizontal: 40, vertical: 20), // Ukuran lebih besar
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Sudut tombol tetap melengkung
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}

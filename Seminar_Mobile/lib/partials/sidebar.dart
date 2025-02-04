import 'package:flutter/material.dart';
import 'package:latihan2/login.dart';
import 'package:latihan2/pages/profile.dart';

class Sidebar extends StatelessWidget {
  final String userId; // Menambahkan userId sebagai parameter

  const Sidebar({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 23, 27, 29)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('assets/images/admin.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(userId: userId), // Mengirimkan userId
                ),
              );
            },
          ),
          _buildSidebarItem(
            context,
            title: 'About',
            routeName: '/about',
            icon: Icons.info_outline,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required String title,
    required String routeName,
    required IconData icon,
  }) {
    final isSelected = ModalRoute.of(context)?.settings.name == routeName;

    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected ? Colors.grey : Colors.black, // Warna ikon saat dipilih
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? Colors.grey
              : Colors.black, // Warna teks saat dipilih
          fontWeight: isSelected
              ? FontWeight.bold // Tebal jika dipilih
              : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor:
          Colors.black.withOpacity(0.2), // Warna latar belakang saat dipilih
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}

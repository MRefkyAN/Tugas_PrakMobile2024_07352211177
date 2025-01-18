import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
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
                  'Dashboard - Admin',
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
          _buildSidebarItem(
            context,
            title: 'Home',
            routeName: '/home',
            icon: Icons.home,
          ),
          _buildSidebarItem(
            context,
            title: 'Data',
            routeName: '/anggota/list',
            icon: Icons.list_alt,
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
              Navigator.pushReplacementNamed(context, '/login');
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
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.2), // Highlight saat aktif
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}

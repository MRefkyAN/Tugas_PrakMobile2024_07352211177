import 'package:flutter/material.dart';
import '../partials/member_sidebar.dart';

class AboutPageMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      drawer: MemberSidebar(),
      appBar: AppBar(
        title: Text("Struktur Organisasi",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildOrganizationalMember(
              title: "Ketua Umum",
              name: "Abdullah Muhammad",
              imageUrl: "assets/images/ketum.jpeg",
              backgroundColor: Colors.blue.shade600,
            ),
            _buildOrganizationalMember(
              title: "Sekretaris Umum",
              name: "Syahran Sahupala",
              imageUrl: "assets/images/sekum.jpeg",
              backgroundColor: Colors.blue,
            ),
            _buildOrganizationalMember(
              title: "Bendahara",
              name: "Astuti Mutalib",
              imageUrl: "assets/images/bendahara.jpeg",
              backgroundColor: Colors.blue.shade400,
            ),
            _buildOrganizationalMember(
              title: "P.A.O",
              name: "Arwan Arsad",
              imageUrl: "assets/images/P.A.O.jpeg",
              backgroundColor: Colors.blue.shade300,
            ),
            _buildOrganizationalMember(
              title: "Pengembangan SDM",
              name: "Randi Sabtu",
              imageUrl: "assets/images/SDM.jpeg",
              backgroundColor: Colors.blue.shade200,
            ),
            _buildOrganizationalMember(
              title: "Administrasi",
              name: "Hardian Bontar",
              imageUrl: "assets/images/administrasi.jpeg",
              backgroundColor: Colors.blue.shade100,
            ),
            _buildOrganizationalMember(
              title: "Humas",
              name: "Risdi Yasin",
              imageUrl: "assets/images/humas.jpeg",
              backgroundColor: Colors.blue.shade100,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '© 2024 IPMMS-HT. Semua Hak Dilindungi.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kontak: soft_spoken@yahoo.com',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationalMember({
    required String title,
    required String name,
    required String imageUrl,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        tileColor: backgroundColor,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          name,
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        trailing: Icon(
          Icons.person,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}

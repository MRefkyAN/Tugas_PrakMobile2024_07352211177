import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/anggota.dart';
import '../partials/member_sidebar.dart';

class AnggotaListPages extends StatefulWidget {
  @override
  _AnggotaListPageState createState() => _AnggotaListPageState();
}

class _AnggotaListPageState extends State<AnggotaListPages> {
  List<Anggota> anggotaList = [];

  Future<List<Anggota>> fetchAnggotaList() async {
    final response = await http
        .get(Uri.parse('https://6772080aee76b92dd490f789.mockapi.io/anggota'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Anggota.fromJson(data)).toList();
    } else {
      throw Exception('Data anggota tidak dapat diambil');
    }
  }

  Future<void> refreshAnggotaList() async {
    final updatedList = await fetchAnggotaList();
    setState(() {
      anggotaList = updatedList;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAnggotaList().then((list) {
      setState(() {
        anggotaList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text(
          'Daftar Anggota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            Colors.transparent, // Set to transparent for gradient effect
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent
              ], // Two colors gradient
              begin: Alignment.topCenter, // Gradient starts from top
              end: Alignment.bottomCenter, // Gradient ends at the bottom
            ),
          ),
        ),
      ),
      drawer: MemberSidebar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: Colors.blueGrey.shade50,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: anggotaList.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada data anggota',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: refreshAnggotaList,
                      child: ListView.builder(
                        itemCount: anggotaList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Card(
                              elevation: 8.0,
                              shadowColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 28.0,
                                  backgroundColor:
                                      const Color.fromARGB(255, 244, 103, 183),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      anggotaList[index].nama[0],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  anggotaList[index].nama,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade800,
                                  ),
                                ),
                                subtitle: Text(
                                  'NPM: ${anggotaList[index].npm}\nBidang: ${anggotaList[index].bidang}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                isThreeLine: true,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (value == 'Detail') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AnggotaDetailPage(
                                            anggota: anggotaList[index],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return ['Detail'].map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          // Footer
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
    );
  }
}

class AnggotaDetailPage extends StatelessWidget {
  final Anggota anggota;

  AnggotaDetailPage({required this.anggota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text(
          'Detail Anggota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            Colors.transparent, // Set to transparent for gradient effect
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent
              ], // Two colors gradient
              begin: Alignment.topCenter, // Gradient starts from top
              end: Alignment.bottomCenter, // Gradient ends at the bottom
            ),
          ),
        ),
      ),
      drawer: MemberSidebar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Text(
                            anggota.nama[0],
                            style:
                                TextStyle(fontSize: 40.0, color: Colors.white),
                          ),
                          backgroundColor: Colors.pink.shade300,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          anggota.nama,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade800,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'NPM: ${anggota.npm}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Semester: ${anggota.semester}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Bidang: ${anggota.bidang}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer
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
    );
  }
}

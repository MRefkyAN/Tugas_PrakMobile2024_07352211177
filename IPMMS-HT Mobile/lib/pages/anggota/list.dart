import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/anggota.dart';
import '../partials/sidebar.dart';

class AnggotaListPage extends StatefulWidget {
  @override
  _AnggotaListPageState createState() => _AnggotaListPageState();
}

class _AnggotaListPageState extends State<AnggotaListPage> {
  List<Anggota> anggotaList = [];

  Future<List<Anggota>> fetchAnggotaList() async {
    try {
      final response = await http.get(
        Uri.parse('https://6772080aee76b92dd490f789.mockapi.io/anggota'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Anggota.fromJson(data)).toList();
      } else {
        throw Exception('Gagal mengambil data anggota');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> refreshAnggotaList() async {
    final List<Anggota> list = await fetchAnggotaList();
    setState(() {
      anggotaList = list;
    });
  }

  Future<void> deleteAnggota(String id) async {
    final response = await http.delete(
      Uri.parse('https://6772080aee76b92dd490f789.mockapi.io/anggota/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        anggotaList.removeWhere((anggota) => anggota.id == id);
      });
    } else {
      throw Exception('Gagal menghapus anggota');
    }
  }

  Future<void> addAnggota(
      String nama, int npm, String semester, String bidang) async {
    final response = await http.post(
      Uri.parse('https://6772080aee76b92dd490f789.mockapi.io/anggota'),
      body: {
        'nama': nama,
        'npm': npm.toString(),
        'semester': semester,
        'bidang': bidang,
      },
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final newAnggota = Anggota.fromJson(responseData);
      setState(() {
        anggotaList.add(newAnggota);
      });
    } else {
      throw Exception('Gagal menambah anggota');
    }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            'Daftar Anggota',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
      ),
      drawer: Sidebar(),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribusi atas-bawah
        children: [
          // Konten utama halaman
          Expanded(
            child: anggotaList.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada data anggota',
                      style: TextStyle(fontSize: 16.0),
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
                            elevation: 8.0, // Bayangan lebih kuat untuk efek 3D
                            shadowColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16.0), // Card dengan sudut lebih halus
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 24.0,
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 103, 183),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    anggotaList[index].nama[0],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                anggotaList[index].nama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle:Text(
                                  'NPM: ${anggotaList[index].npm}\nBidang: ${anggotaList[index].bidang}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                onSelected: (String value) {
                                  if (value == 'Hapus') {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Konfirmasi'),
                                        content: Text(
                                            'Apakah Anda yakin ingin menghapus anggota ini?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteAnggota(
                                                  anggotaList[index].id);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (value == 'Detail') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnggotaDetailPage(
                                          anggota: anggotaList[index],
                                        ),
                                      ),
                                    );
                                  } else if (value == 'Edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnggotaUpdatePage(
                                          anggota: anggotaList[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        fetchAnggotaList().then((list) {
                                          setState(() {
                                            anggotaList = list;
                                          });
                                        });
                                      }
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return ['Detail', 'Edit', 'Hapus']
                                      .map((String choice) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnggotaAddPage()),
          ).then((value) {
            if (value != null && value is Map) {
              final String nama = value['nama'];
              final int npm = value['npm'];
              final String semester = value['semester'];
              final String bidang = value['bidang'];
              addAnggota(nama, npm, semester, bidang);
            }
          });
        },
        child: Icon(Icons.add),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      drawer: Sidebar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Konten Utama
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.0),
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
                          backgroundColor:
                              const Color.fromARGB(255, 245, 104, 184),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          anggota.nama,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'NPM: ${anggota.npm}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade800),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Semester: ${anggota.semester}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade800),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Bidang: ${anggota.bidang}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnggotaUpdatePage(anggota: anggota),
                        ),
                      ).then((value) {
                        if (value == true) {
                          Navigator.pop(context, true);
                        }
                      });
                    },
                    icon: Icon(Icons.edit, size: 24.0),
                    label: Text('Edit Anggota'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.blueAccent,
                      elevation: 6.0,
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
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

class AnggotaAddPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController bidangController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text('Tambah Anggota',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16.0),
              _buildTextField(
                controller: namaController,
                label: 'Nama',
                icon: Icons.person,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: nimController,
                label: 'NPM',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: kelasController,
                label: 'Semester',
                icon: Icons.class_,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: bidangController,
                label: 'Bidang',
                icon: Icons.work,
              ),
              SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: () {
                  final String nama = namaController.text.trim();
                  final String npmText = nimController.text.trim();
                  final String semester = kelasController.text.trim();
                  final String bidang = bidangController.text.trim();

                  if (nama.isEmpty ||
                      npmText.isEmpty ||
                      semester.isEmpty ||
                      bidang.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Semua field harus diisi'),
                        backgroundColor:
                            const Color.fromARGB(255, 244, 54, 165),
                      ),
                    );
                    return;
                  }

                  final int? npm = int.tryParse(npmText);
                  if (npm == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('NPM harus berupa angka'),
                        backgroundColor:
                            const Color.fromARGB(255, 244, 54, 181),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'nama': nama,
                    'npm': npm,
                    'semester': semester,
                    'bidang': bidang,
                  });
                },
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white, fontSize: 18, // Ukuran teks
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 138, 243),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  elevation: 4.0,
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
      ),
      keyboardType: keyboardType,
    );
  }
}

class AnggotaUpdatePage extends StatelessWidget {
  final Anggota anggota;
  final TextEditingController namaController;
  final TextEditingController npmController;
  final TextEditingController semesterController;
  final TextEditingController bidangController;

  AnggotaUpdatePage({required this.anggota})
      : namaController = TextEditingController(text: anggota.nama),
        npmController = TextEditingController(text: anggota.npm.toString()),
        semesterController = TextEditingController(text: anggota.semester),
        bidangController = TextEditingController(text: anggota.bidang);

  Future<void> updateAnggota(
      String id, String nama, int npm, String semester, String bidang) async {
    final response = await http.put(
      Uri.parse('https://6772080aee76b92dd490f789.mockapi.io/anggota/$id'),
      body: {
        'nama': nama,
        'npm': npm.toString(),
        'semester': semester,
        'bidang': bidang,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update anggota');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text('Update Anggota',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16.0),
              _buildTextField(
                controller: namaController,
                label: 'Nama',
                icon: Icons.person,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: npmController,
                label: 'NPM',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: semesterController,
                label: 'Semester',
                icon: Icons.class_,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: bidangController,
                label: 'Bidang',
                icon: Icons.work,
              ),
              SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: () {
                  final String nama = namaController.text.trim();
                  final String npmText = npmController.text.trim();
                  final String semester = semesterController.text.trim();
                  final String bidang = bidangController.text.trim();

                  if (nama.isEmpty ||
                      npmText.isEmpty ||
                      semester.isEmpty ||
                      bidang.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Semua field harus diisi'),
                        backgroundColor:
                            const Color.fromARGB(255, 244, 54, 177),
                      ),
                    );
                    return;
                  }

                  final int? npm = int.tryParse(npmText);
                  if (npm == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('NPM harus berupa angka'),
                        backgroundColor:
                            const Color.fromARGB(255, 244, 54, 177),
                      ),
                    );
                    return;
                  }

                  updateAnggota(anggota.id, nama, npm, semester, bidang)
                      .then((_) {
                    Navigator.pop(context, true);
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal memperbarui data anggota'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  elevation: 4.0,
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
      ),
      keyboardType: keyboardType,
    );
  }
}

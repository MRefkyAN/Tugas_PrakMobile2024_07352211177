import 'dart:async';
import 'dart:io';

enum KategoriProduk { DataManagement, NetworkAutomation }

enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

mixin Kinerja {
  int _produktivitas = 50; 
  DateTime? _lastUpdate;  
  int get produktivitas => _produktivitas;

  void updateProduktivitas(int perubahan) {
    DateTime now = DateTime.now();
    if (_lastUpdate == null || now.difference(_lastUpdate!).inDays >= 30) {
      _produktivitas = (_produktivitas + perubahan).clamp(0, 100);
      _lastUpdate = now;
      print("Produktivitas diperbarui menjadi $_produktivitas.");
    } else {
      print("Produktivitas hanya dapat diperbarui setiap 30 hari.");
    }
  }
}

class Produk {
  String namaProduk;
  double harga;
  KategoriProduk kategori;
  int jumlahTerjual;

  Produk({
    required this.namaProduk,
    required this.harga,
    required this.kategori,
    this.jumlahTerjual = 0,
  }) {

    if (kategori == KategoriProduk.NetworkAutomation && harga < 200000) {
      throw Exception("Produk NetworkAutomation harus memiliki harga minimal 200000.");
    }
    if (kategori == KategoriProduk.DataManagement && harga >= 200000) {
      throw Exception("Produk DataManagement harus memiliki harga di bawah 200000.");
    }
  }

  double getHargaSetelahDiskon() {
    if (kategori == KategoriProduk.NetworkAutomation && jumlahTerjual > 50) {
      double hargaDiskon = harga * 0.85;
      return hargaDiskon >= 200000 ? hargaDiskon : 200000;
    }
    return harga;
  }
}

abstract class Karyawan with Kinerja {
  String nama;
  int umur;
  String peran;
  bool aktif;

  Karyawan({
    required this.nama,
    required this.umur,
    required this.peran,
    this.aktif = true,
  });

  void resign() {
    aktif = false;
    print("$nama telah resign dan statusnya menjadi non-aktif.");
  }
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap({
    required String nama,
    required int umur,
    required String peran,
  }) : super(nama: nama, umur: umur, peran: peran);
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak({
    required String nama,
    required int umur,
    required String peran,
  }) : super(nama: nama, umur: umur, peran: peran);
}

class Proyek {
  String namaProyek;
  List<Karyawan> timProyek;
  FaseProyek fase = FaseProyek.Perencanaan;
  DateTime tanggalMulai;

  Proyek({required this.namaProyek, required this.tanggalMulai})
      : timProyek = [];

  void tambahKaryawan(Karyawan karyawan) {
    if (timProyek.length >= 20) {
      print("Tidak bisa menambah karyawan. Kapasitas tim proyek sudah penuh.");
      return;
    }
    if (karyawan.aktif) {
      timProyek.add(karyawan);
      print("${karyawan.nama} ditambahkan ke tim proyek.");
    } else {
      print("Karyawan ${karyawan.nama} sudah tidak aktif dan tidak dapat ditambahkan.");
    }
  }

  void lanjutKeFaseBerikutnya() {
    switch (fase) {
      case FaseProyek.Perencanaan:
        if (timProyek.where((k) => k.aktif).length >= 5) {
          fase = FaseProyek.Pengembangan;
          print("Proyek beralih ke fase Pengembangan.");
        } else {
          print("Fase tidak dapat berubah. Dibutuhkan minimal 5 karyawan aktif.");
        }
        break;

      case FaseProyek.Pengembangan:
        if (DateTime.now().difference(tanggalMulai).inDays > 45) {
          fase = FaseProyek.Evaluasi;
          print("Proyek beralih ke fase Evaluasi.");
        } else {
          print("Proyek belum berjalan cukup lama untuk beralih ke fase Evaluasi.");
        }
        break;

      case FaseProyek.Evaluasi:
        print("Proyek sudah berada di fase Evaluasi.");
        break;
    }
  }
}

void main() {
  var produk1 = Produk(
    namaProduk: "Sistem Manajemen Data",
    harga: 150000,
    kategori: KategoriProduk.DataManagement,
  );

  var produk2 = Produk(
    namaProduk: "Sistem Otomasi Jaringan",
    harga: 250000,
    kategori: KategoriProduk.NetworkAutomation,
    jumlahTerjual: 51,
  );

  print("Harga produk2 setelah diskon: ${produk2.getHargaSetelahDiskon()}");

  var karyawan1 = KaryawanTetap(nama: "Andi", umur: 30, peran: "Developer");
  var karyawan2 = KaryawanKontrak(nama: "Budi", umur: 28, peran: "NetworkEngineer");

  karyawan1.updateProduktivitas(10);
  karyawan2.updateProduktivitas(-5);

  var proyek = Proyek(namaProyek: "Proyek Otomasi", tanggalMulai: DateTime.now().subtract(Duration(days: 50)));

  proyek.tambahKaryawan(karyawan1);
  proyek.tambahKaryawan(karyawan2);
  proyek.lanjutKeFaseBerikutnya(); 
  proyek.lanjutKeFaseBerikutnya(); 
}

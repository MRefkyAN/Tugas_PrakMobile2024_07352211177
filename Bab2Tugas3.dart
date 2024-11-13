import 'dart:io';

enum Role { AnggotaBiasa, AnggotaVIP }

abstract class Pengguna {
  String nama;
  int umur;

  Pengguna(this.nama, this.umur);

  void info();
}

class Buku {
  String judul;
  String penulis;
  late int tahunTerbit;
  late double harga;

  Buku(this.judul, this.penulis, this.tahunTerbit, this.harga);

  @override
  String toString() => "$judul oleh $penulis (Tahun: $tahunTerbit, Harga: \$$harga)";
}

class Anggota extends Pengguna {
  Role role; 
  List<Buku> koleksiBuku = [];

  Anggota(String nama, {required this.role, required int umur}) : super(nama, umur);

  void pinjamBuku(Buku buku) {
    koleksiBuku.add(buku);
    print("$nama meminjam buku ${buku.judul}.");
  }

  @override
  void info() {
    print("Nama Anggota: $nama, Umur: $umur, Role: $role");
  }
}

mixin PengalamanMembaca on Anggota {
  void tambahPengalaman() {
    print("$nama mendapatkan pengalaman membaca yang lebih baik sebagai anggota VIP!");
  }
}

class AnggotaVIP extends Anggota with PengalamanMembaca {
  AnggotaVIP(String nama, {required int umur})
      : super(nama, role: Role.AnggotaVIP, umur: umur);
}

void main() {

  var buku1 = Buku('Dart for Beginners', 'John Doe', 2020, 45.0);
  var buku2 = Buku('Advanced Flutter', 'Jane Smith', 2021, 60.0);

  var anggota1 = Anggota('Alice', role: Role.AnggotaBiasa, umur: 25);
  anggota1.pinjamBuku(buku1);
  anggota1.info();
  
  print("\n");

  var anggotaVIP = AnggotaVIP('Bob', umur: 30);
  anggotaVIP.pinjamBuku(buku2);
  anggotaVIP.info();
  anggotaVIP.tambahPengalaman();

  print("\n");
}

class Anggota {
  final String id;
  final String nama;
  final int npm;
  final String semester;
  final String bidang;

  Anggota({
    required this.id,
    required this.nama,
    required this.npm,
    required this.semester,
    required this.bidang,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'] ?? '',
      nama: json['nama'] ?? 'Tidak Diketahui',
      npm: json['npm'] != null ? int.tryParse(json['npm'].toString()) ?? 0 : 0,
      semester: json['semester'] ?? 'Tidak Diketahui',
      bidang: json['bidang'] ?? 'Tidak Diketahui',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'npm': npm.toString(),
      'semester': semester,
      'bidang': bidang,
    };
  }
}

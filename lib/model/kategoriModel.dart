// ignore_for_file: file_names

class KategoriModel {
  final String id;
  final String nama;

  KategoriModel({
    required this.id,
    required this.nama,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      nama: json['nama'],
    );
  }
}

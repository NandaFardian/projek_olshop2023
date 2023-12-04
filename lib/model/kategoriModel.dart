class KategoriModel {
  final String? id;
  final String? nama;

  KategoriModel({
    this.id,
    this.nama,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      nama: json['nama'],
    );
  }
}

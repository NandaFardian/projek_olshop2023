class ProdukModel {
  final String id;
  final String nama;
  final String kategoriid;
  final String harga;
  final String keterangan;
  final String tanggal;
  final String gambar;
  final String namakategori;

  ProdukModel({
    required this.id,
    required this.nama,
    required this.kategoriid,
    required this.harga,
    required this.keterangan,
    required this.tanggal,
    required this.gambar,
    required this.namakategori,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'],
      nama: json['nama'],
      kategoriid: json['kategoriid'],
      harga: json['harga'],
      keterangan: json['keterangan'],
      tanggal: json['tanggal'], 
      gambar: json['gambar'],
      namakategori: json['namakategori'],
    );
  }
}

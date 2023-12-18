// ignore_for_file: file_names

class ProdukModel {
  final String? id;
  final String? nama;
  final String? kategoriid;
  final String? harga;
  final String? keterangan;
  final String? tanggal;
  final String? gambar;
  final String? namakategori;

  ProdukModel({
     this.id,
     this.nama,
     this.kategoriid,
     this.harga,
     this.keterangan,
     this.tanggal,
     this.gambar,
     this.namakategori,
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

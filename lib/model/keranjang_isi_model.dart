class KeranjangIsiModel {
  final String? id;
  final String? produkid;
  final String? userid;
  final String? qty;
  final String? harga;
  final String? namaproduk;

  KeranjangIsiModel({
    this.id,
    this.produkid,
    this.userid,
    this.qty,
    this.harga,
    this.namaproduk,
  });

  factory KeranjangIsiModel.fromJson(Map<String, dynamic> json) {
    return KeranjangIsiModel(
      id: json['id'],
      produkid: json['produkid'],
      userid: json['userid'],
      qty: json['qty'],
      harga: json['harga'],
      namaproduk: json['namaproduk'],
    );
  }
}
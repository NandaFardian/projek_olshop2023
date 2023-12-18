import 'package:olshop2023/model/produkModel.dart';

class KategoriUserModel {
  final String? id;
  final String? namakategori;
  final List<ProdukModel> produk;

  KategoriUserModel({
    this.id,
    this.namakategori,
    required this.produk,
  });

  factory KategoriUserModel.fromJson(Map<String, dynamic> data) {
    var list = data['produk'] as List;

    List<ProdukModel> produkList =
        list.map((i) => ProdukModel.fromJson(i)).toList();

    return KategoriUserModel(
      produk: produkList,
      id: data['id'],
      namakategori: data['namakategori'],
    );
  }
}
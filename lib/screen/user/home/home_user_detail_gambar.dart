import 'package:flutter/material.dart';
import 'package:olshop2023/model/produkModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:photo_view/photo_view.dart';

class HomeUserDetailGambar extends StatefulWidget {
  final ProdukModel model;
  const HomeUserDetailGambar(this.model,{super.key});

  @override
  State<HomeUserDetailGambar> createState() => _HomeUserDetailGambarState();
}

class _HomeUserDetailGambarState extends State<HomeUserDetailGambar> {
  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(
          "${NetworkURL.server}../imageProduk/${widget.model.gambar}"),
    );
  }
}

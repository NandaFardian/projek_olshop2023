import 'package:flutter/material.dart';
import 'package:olshop2023/model/userModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:photo_view/photo_view.dart';

class ProfilDetailAdmin extends StatefulWidget {
  final UserModel model;
  const ProfilDetailAdmin(this.model, Future<void> Function() onRefresh, {super.key});

  @override
  State<ProfilDetailAdmin> createState() => _ProfilDetailAdminState();
}

class _ProfilDetailAdminState extends State<ProfilDetailAdmin> {
  @override
  Widget build(BuildContext context) {
    return PhotoView(
        imageProvider: 
        NetworkImage("${NetworkURL.server}../imageUser/${widget.model.gambar}")
    );
  }
}

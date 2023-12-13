import 'package:flutter/material.dart';
import 'package:olshop2023/model/userModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:photo_view/photo_view.dart';

class ProfilDetailUser extends StatefulWidget {
  final UserModel model;
  const ProfilDetailUser(this.model, Future<void> Function() onRefresh,{super.key});

  @override
  State<ProfilDetailUser> createState() => _ProfilDetailUserState();
}

class _ProfilDetailUserState extends State<ProfilDetailUser> {
  @override
  Widget build(BuildContext context) {
    return PhotoView(
        imageProvider: 
        NetworkImage("${NetworkURL.server}../imageUser/${widget.model.gambar}")
    );
  }
}
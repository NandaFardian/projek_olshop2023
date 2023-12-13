import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olshop2023/model/userModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilUserEditGambar extends StatefulWidget {
  final UserModel model;
  final VoidCallback reload;
  const ProfilUserEditGambar(this.model, this.reload,{super.key});

  @override
  State<ProfilUserEditGambar> createState() => _ProfilUserEditGambarState();
}

class _ProfilUserEditGambarState extends State<ProfilUserEditGambar> {
  late String userid;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("id")!;
    });
  }

  File? imageFile;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      print(pickedImage);
    }
  }

  final key = GlobalKey<FormState>();

  cek() {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      submit();
    }
  }

  submit() async {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Processing.."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 16,
                ),
                Text("Please wait...")
              ],
            ),
          );
        });

    var url = Uri.parse(NetworkURL.profilEditGambar());
    var request = http.MultipartRequest("POST", url);
    request.fields['userid'] = widget.model.id;

    if (imageFile == null) {
      request.fields['gambar'] = widget.model.gambar;
    } else {
      var pic = await http.MultipartFile.fromPath("gambar", imageFile!.path);
      request.files.add(pic);
    }

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((a) {
      final data = jsonDecode(a);
      int value = data['value'];
      String message = data['message'];
      // ignore: avoid_print
      print(value);
      if (value == 1) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Information"),
                content: Text(message),
                actions: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pop(context);
                        widget.reload();
                      });
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            });
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: Text(message),
              actions: <Widget>[
                // ignore: deprecated_member_use
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          },
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          'Edit Gambar Profil',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  _openImagePicker();
                },
                child: imageFile == null
                    ? Image.network(
                        '${NetworkURL.server}../imageUser/${widget.model.gambar}')
                    : Image.file(
                        imageFile!,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: MaterialButton(
                color: const Color.fromARGB(255, 239, 147, 0),
                onPressed: () {
                  cek();
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/custom/customButton.dart';
import 'package:olshop2023/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KategoriAdminTambah extends StatefulWidget {
  final VoidCallback reload;
  const KategoriAdminTambah(this.reload, {super.key});

  @override
  State<KategoriAdminTambah> createState() => _KategoriAdminTambahState();
}

class _KategoriAdminTambahState extends State<KategoriAdminTambah> {
  String? userid;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id");
    });
    print(userid);
  }

  final _key = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();

  cek() {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      submit();
    }
  }

  submit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          child: AlertDialog(
            title: Text('Processing..'),
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
          ),
        );
      },
    );

    var uri = Uri.parse(NetworkURL.kategoriTambah());
    var request = http.MultipartRequest("POST", uri);

    request.fields['nama'] = namaController.text.trim();

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((a) {
      final data = jsonDecode(a);
      int value = data['value'];
      String message = data['message'];
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
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Kategori',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'roboto',
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
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "Isikan Nama Kategori";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              minLines: 1,
              controller: namaController,
              decoration: const InputDecoration(
                hintText: "Isikan Nama Kategori",
                labelText: "Isikan Nama Kategori",
                icon: Icon(Icons.text_increase),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                cek();
              },
              child: const CustomButton(
                "Tambah",
                color: Color.fromARGB(255, 239, 147, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

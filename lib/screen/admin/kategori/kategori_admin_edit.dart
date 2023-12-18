import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/custom/customButton.dart';
import 'package:olshop2023/model/kategoriModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:http/http.dart' as http;

class KategoriAdminEdit extends StatefulWidget {
  final KategoriModel model;
  final VoidCallback reload;
  const KategoriAdminEdit(this.model, this.reload, {super.key});

  @override
  State<KategoriAdminEdit> createState() => _KategoriAdminEditState();
}

class _KategoriAdminEditState extends State<KategoriAdminEdit> {
  final _key = GlobalKey<FormState>();

  late TextEditingController namaController;

  setup() {
    namaController = TextEditingController(text: widget.model.nama);
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          child: AlertDialog(
            title: const Text('Processing..'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 16,
                ),
                Text("Please wait...")
              ],
            ),
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
                  'Go Back',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );

    var uri = Uri.parse(NetworkURL.kategoriEdit());
    var request = http.MultipartRequest("POST", uri);

    request.fields['nama'] = namaController.text.trim();
    request.fields['kategoriid'] = widget.model.id;

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
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Kategori',
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
                hintText: "isikan Nama Kategori",
                labelText: "Isikan Nama Kategori",
                icon: Icon(Icons.text_increase),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: const CustomButton(
                "Edit",
                color: Color.fromARGB(255, 239, 147, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

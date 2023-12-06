import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olshop2023/custom/customButton.dart';
import 'package:olshop2023/model/kategoriModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:olshop2023/screen/admin/kategori/kategori_pilih.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProdukAdminTambah extends StatefulWidget {
  final VoidCallback reload;
  const ProdukAdminTambah(this.reload, {super.key});

  @override
  State<ProdukAdminTambah> createState() => _ProdukAdminTambahState();
}

class _ProdukAdminTambahState extends State<ProdukAdminTambah> {
  TextEditingController kategoriController = TextEditingController();

  late KategoriModel kategoriModel;

  pilihKategori() async {
    kategoriModel = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => KategoriPilih()));
    setState(() {
      kategoriController = TextEditingController(text: kategoriModel.nama);
    });
  }

  String? userid;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id");
    });
    print(userid);
  }

  File? _imageFile;
  final picker = ImagePicker();

  _pilihcamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        print('_image: $_imageFile');
      } else {
        print('No image selected');
      }
    });
  }

  final _key = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController kategoriidController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();

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
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
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

    var uri = Uri.parse(NetworkURL.produkTambah());
    var request = http.MultipartRequest("POST", uri);

    request.fields['nama'] = namaController.text.trim();
    request.fields['kategoriid'] = kategoriModel.id;
    request.fields['harga'] = hargaController.text.trim();
    request.fields['keterangan'] = keteranganController.text.trim();
    request.fields['tanggal'] = keteranganController.text.trim();

    var pic = await http.MultipartFile.fromPath("gambar", _imageFile!.path);
    request.files.add(pic);

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
    var placeholder = SizedBox(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('images/placeholder.png'),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.white,
            fontFamily: 'MaisonNeue',
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
            SizedBox(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  _pilihcamera();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile!,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "Isikan Nama Produk";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              minLines: 1,
              controller: namaController,
              decoration: const InputDecoration(
                hintText: "Isikan Nama Produk",
                labelText: "Isikan Nama Produk",
                icon: Icon(Icons.text_increase),
              ),
            ),
            InkWell(
              onTap: () {
                pilihKategori();
              },
              child: TextFormField(
                enabled: false,
                validator: (e) {
                  if (e == null || e.isEmpty) {
                    return "pilih kategori";
                  }
                  return null;
                },
                controller: kategoriController,
                decoration: InputDecoration(
                    hintText: "pilih kategori",
                    labelText: "pilih kategori",
                    icon: Icon(Icons.text_increase)),
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "Isikan Harga Produk";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              minLines: 1,
              controller: hargaController,
              decoration: const InputDecoration(
                hintText: "Isikan Kategori Produk",
                labelText: "Isikan Kategori Produk",
                icon: Icon(Icons.text_increase),
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "Isikan Keterangan Produk";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              minLines: 1,
              controller: keteranganController,
              decoration: const InputDecoration(
                hintText: "Isikan Keterangan Produk",
                labelText: "Isikan Keterangan Produk",
                icon: Icon(Icons.text_increase),
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e == null || e.isEmpty) {
                  return "Isikan Tanggal Produk";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              minLines: 1,
              controller: tanggalController,
              decoration: const InputDecoration(
                hintText: "Isikan Tanggal Produk",
                labelText: "Isikan Tanggal Produk",
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
              child: CustomButton(
                "Tambah",
                color: const Color.fromARGB(255, 239, 147, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

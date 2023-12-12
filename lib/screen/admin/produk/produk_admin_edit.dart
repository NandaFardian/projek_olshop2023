import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/custom/currency.dart';
import 'package:olshop2023/custom/customButton.dart';
import 'package:olshop2023/custom/datePicker.dart';
import 'package:olshop2023/model/kategoriModel.dart';
import 'package:olshop2023/model/produkModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:http/http.dart' as http;
import 'package:olshop2023/screen/admin/kategori/kategori_pilih.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProdukAdminEdit extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  const ProdukAdminEdit(this.model, this.reload, {super.key});

  @override
  State<ProdukAdminEdit> createState() => _ProdukAdminEditState();
}

class _ProdukAdminEditState extends State<ProdukAdminEdit> {
  TextEditingController kategoriController = TextEditingController();

  late KategoriModel kategoriModel;

  pilihKategori() async {
    kategoriModel = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => KategoriPilih()));
    setState(() {
      kategoripilihController = kategoriController;
      kategoripilihController = TextEditingController(text: kategoriModel.id);
      kategoriController = TextEditingController(text: kategoriModel.nama);
    });
  }

  final _key = GlobalKey<FormState>();

  String? adminid;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      adminid = pref.getString("id");
    });
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

  late TextEditingController namaController;
  late TextEditingController kategoriidController;
  late TextEditingController kategoripilihController;
  late TextEditingController hargaController;
  late TextEditingController keteranganController;
  late TextEditingController tanggalController;

  String? tgldate;

  setup() {
    kategoriController = TextEditingController(text: widget.model.namakategori);
    kategoripilihController = TextEditingController(text: widget.model.kategoriid);
    namaController = TextEditingController(text: widget.model.nama);
    hargaController = TextEditingController(text: widget.model.harga);
    keteranganController = TextEditingController(text: widget.model.keterangan);
    tgldate = widget.model.tanggal;
  }

  String? pilihTanggal, labelText;
  DateTime tgl = DateTime.now();
  var formatTgl = DateFormat('yyy-MM-dd');
  final TextStyle valueStyle = const TextStyle(fontSize: 16.0);
  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        tgldate = formatTgl.format(tgl);
      });
    } else {}
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
        return WillPopScope(
          onWillPop: () async => false,
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

    var uri = Uri.parse(NetworkURL.produkEdit());
    var request = http.MultipartRequest("POST", uri);

    request.fields['nama'] = namaController.text.trim();
    request.fields['kategoriid'] = kategoripilihController.text;
    request.fields['harga'] = hargaController.text.replaceAll(",", "");
    request.fields['keterangan'] = keteranganController.text.trim();
    request.fields['tanggal'] = "$tgldate";
    request.fields['produkid'] = widget.model.id;

    if (_imageFile == null) {
      request.fields['gambar'] = widget.model.gambar;
    } else {
      var pic = await http.MultipartFile.fromPath("gambar", _imageFile!.path);
      request.files.add(pic);
    }

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
          'Edit Produk',
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
                    ? Image.network(
                        '${NetworkURL.server}/imageProduk/${widget.model.gambar}')
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
                hintText: "isikan Nama Produk",
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
              inputFormatters: [
                // ignore: deprecated_member_use
                FilteringTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              keyboardType: TextInputType.number,
              maxLines: 20,
              minLines: 1,
              controller: hargaController,
              decoration: const InputDecoration(
                hintText: "Isikan Harga Produk",
                labelText: "Isikan Harga Produk",
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
            DateDropDown(
              labelText: "Tanggal",
              valueText: tgldate!,
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: CustomButton(
                "Edit",
                color: const Color.fromARGB(255, 239, 147, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/model/produkModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:http/http.dart' as http;
import 'package:olshop2023/screen/admin/produk/produk_admin_edit.dart';
import 'package:olshop2023/screen/admin/produk/produk_admin_tambah.dart';

class ProdukAdmin extends StatefulWidget {
  const ProdukAdmin({super.key});

  @override
  State<ProdukAdmin> createState() => _ProdukAdminState();
}

class _ProdukAdminState extends State<ProdukAdmin> {
  var loading = false;
  var cekData = false;

  List<ProdukModel> list = [];

  _fetchData() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(Uri.parse(NetworkURL.produk()));
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          loading = false;
          cekData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          for (Map i in data) {
            list.add(ProdukModel.fromJson(i as Map<String, dynamic>));
          }
          loading = false;
          cekData = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                const Text(
                  "Apakah Kamu Yakin Menghapus Data Ini?",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                      onTap: () {
                        _delete(id);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response = await http.post(Uri.parse(NetworkURL.produkHapus()),
        body: {"produkid": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _fetchData();
      });
    } else {
      print(pesan);
    }
  }

  Future<void> onRefresh() async {
    _fetchData();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        elevation: 10,
         
        title: const Text(
          'Produk Kita Bersama',
          style: TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'roboto',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
        actions: <Widget>[
          IconButton(
            onPressed: () {
            Navigator.of(context).push(
            MaterialPageRoute(
            builder: (context) =>
            ProdukAdminTambah(onRefresh),
            ),
            );
            },
            icon: const Icon(Icons.add,color: Colors.white,),
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : cekData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = list[i];
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Nama Produk : ${a.nama}",
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Source Sans Pro',
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Image.network(
                                                  '${NetworkURL.server}/imageProduk/${a.gambar}',
                                                  width: 80.0,
                                                  height: 80.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProdukAdminEdit(
                                                                a, onRefresh),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  color: Colors.blue,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    dialogDelete(a.id);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum Ada Produk Yang Di Tambahkan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
      ),
    );
  }
}

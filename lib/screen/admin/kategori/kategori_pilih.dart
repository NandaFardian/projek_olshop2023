import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olshop2023/model/kategoriModel.dart';
import 'package:olshop2023/network/network.dart';

class KategoriPilih extends StatefulWidget {
  const KategoriPilih({super.key});

  @override
  State<KategoriPilih> createState() => _KategoriPilihState();
}

class _KategoriPilihState extends State<KategoriPilih> {
  var loading = false;
  List<KategoriModel> list = [];

  getKategori() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(Uri.parse(NetworkURL.kategori()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          list.add(KategoriModel.fromJson(i as Map<String, dynamic>));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    getKategori();
  }

  @override
  void initState() {
    super.initState();
    getKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 228, 199),
        appBar: AppBar(
        title: const Text(
          'Pilih Kategori Kita Bersama',
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
        body: Container(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final a = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, a);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                elevation: 5,
                                margin:
                                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: const Color.fromARGB(255, 239, 147, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        a.nama,
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle( 
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontFamily: 'roboto'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
        ));
  }
}

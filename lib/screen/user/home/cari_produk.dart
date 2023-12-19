import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/model/produkModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:olshop2023/screen/user/home/home_user_detail.dart';
import 'package:http/http.dart' as http;

class CariProduk extends StatefulWidget {
  const CariProduk({super.key});

  @override
  State<CariProduk> createState() => _CariProdukState();
}

class _CariProdukState extends State<CariProduk> {
  var loading = false;
  List<ProdukModel> list = [];
  List<ProdukModel> listSearch = [];

  getProduct() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(Uri.parse(NetworkURL.produk()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          list.add(ProdukModel.fromJson(i as Map<String, dynamic>));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  final price = NumberFormat("#,##0", 'en_US');

  TextEditingController searchController = TextEditingController();

  onSearch(String text) async {
    listSearch.clear();
    if (text.isEmpty) {
      setState(() {});
    }
    for (var a in list) {
      if (a.nama!.toLowerCase().contains(text)) listSearch.add(a);
    }

    setState(() {});
  }

  Future<void> onRefresh() async {
    getProduct();
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: Container(
          height: 50,
          padding: const EdgeInsets.all(4),
          child: TextField(
            textAlign: TextAlign.left,
            autofocus: true,
            controller: searchController,
            onChanged: onSearch,
            style: const TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              hintText: "Cari Nama Produk",
              hintStyle: const TextStyle(fontSize: 18),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.only(top: 10, left: 10),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(style: BorderStyle.none),
              ),
            ),
          ),
        ),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
      ),
      body: Container(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : searchController.text.isNotEmpty || listSearch.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: listSearch.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, i) {
                      final a = listSearch[i];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeUserDetail(a, getProduct()),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey[300]!),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, color: Colors.grey[300]!)
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Image.network(
                                  "${NetworkURL.server}/imageProduk/${a.gambar}",
                                  fit: BoxFit.cover,
                                  height: 180,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                a.nama!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Rp. ${price.format(int.parse(a.harga!))}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : Container(
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Silahkan Cari Nama Produk",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
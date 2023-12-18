import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/model/kategori_user_model.dart';
import 'package:olshop2023/model/produkModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:http/http.dart' as http;
import 'package:olshop2023/screen/user/home/home_user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

final price = NumberFormat("#,##0", 'en_US');

class _HomeUserState extends State<HomeUser> {
  var loading = false;
  var filter = false;
  int index = 0;

  String? userid;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("id");
    });
  }

  //koneksi filter berdasarkan kategori
  List<KategoriUserModel> listCategory = [];
  getProductwithCategory() async {
    setState(() {
      loading = true;
    });
    listCategory.clear();
    final response = await http.get(Uri.parse(NetworkURL.kategoriFilter()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          listCategory
              .add(KategoriUserModel.fromJson(i as Map<String, dynamic>));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }
  //tutup koneksi filter berdasarkan kategori

  //koneksi produk
  List<ProdukModel> list = [];
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
  //tutup koneksi produk

  Future<void> onRefresh() async {
    getProduct();
    getProductwithCategory();
    setState(() {
      filter = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProduct();
    getProductwithCategory();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: InkWell(
          onTap: () {},
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(4),
            child: TextField(
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: "Cari Nama Produk",
                hintStyle: const TextStyle(fontSize: 18),
                fillColor: Colors.white,
                filled: true,
                enabled: false,
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
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Stack(
              children: <Widget>[
                Icon(Icons.shopping_cart, color: Colors.white,),
              ],
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Kategori Produk
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listCategory.length,
                      itemBuilder: (context, i) {
                        final a = listCategory[i];
                        return InkWell(
                          onTap: () 
                          {
                            setState(() {
                              filter = true;
                              index = i;
                              print(filter);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8, left: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 239, 147, 0)),
                            child: Text(
                              a.namakategori!,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  filter
                      ? listCategory[index].produk.isEmpty
                          ? Container(
                              height: 100,
                              padding: const EdgeInsets.all(16),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Maaf produk dengan kategori ini kosong",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: listCategory[index].produk.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              itemBuilder: (context, i) {
                                final a = listCategory[index].produk[i];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeUserDetail(a),
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
                                              blurRadius: 5,
                                              color: Colors.grey[300]!)
                                        ]),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                '${NetworkURL.server}/imageProduk/${a.gambar}',
                                                fit: BoxFit.cover,
                                                height: 180,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          a.nama!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Rp. ${price.format(int.parse(a.harga!))}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: list.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, i) {
                            final a = list[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeUserDetail(a),
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
                                          blurRadius: 5,
                                          color: Colors.grey[300]!)
                                    ]),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Image.network(
                                            '${NetworkURL.server}/imageProduk/${a.gambar}',
                                            fit: BoxFit.cover,
                                            height: 160,
                                            width: 160,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      a.nama!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Rp. ${price.format(int.parse(a.harga!))}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}

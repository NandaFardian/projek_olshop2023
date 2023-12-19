import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/model/keranjang_isi_model.dart';
import 'package:olshop2023/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Keranjang extends StatefulWidget {
  final VoidCallback method;
  const Keranjang(this.method,{super.key});

  @override
  State<Keranjang> createState() => _KeranjangState();
}

final price = NumberFormat("#,##0", 'en_US');

class _KeranjangState extends State<Keranjang> {
  String? userid;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("id");
    });
    _fetchData();
  }

  var loading = false;
  var cekData = false;
  List<KeranjangIsiModel> list = [];

  _fetchData() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response =
        await http.get(Uri.parse(NetworkURL.isiKeranjang(userid!)));
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
            list.add(KeranjangIsiModel.fromJson(i as Map<String, dynamic>));
          }
          loading = false;
          cekData = true;
        });
        _getSummaryAmount();
      }
    } else {
      setState(() {
        loading = false;
        cekData = false;
      });
    }
  }

  var totalPrice = "0";
  _getSummaryAmount() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse(
        NetworkURL.summaryAmountCart(userid!),
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      String total = data['total'];
      setState(() {
        loading = false;
        totalPrice = total;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  _addQuantity(KeranjangIsiModel model, String tipe) async {
    await http.post(Uri.parse(NetworkURL.updateQuantity()), body: {
      "keranjangid": model.id,
      "userid": userid,
      "tipe": tipe,
    });
    setState(() {
      widget.method();
      _fetchData();
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
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          "Keranjang",
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
      body: Container(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : cekData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            final a = list[i];
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        a.namaproduk!,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'MaisonNeue',
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Harga : Rp. ${price.format(int.parse(a.harga!))}",
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'MaisonNeue',
                                            color: Colors.black),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: const Divider(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                  color: Colors.blue[600],
                                  onPressed: () {
                                    _addQuantity(a, "tambah");
                                  },
                                  icon: const Icon(Icons.add_box,
                                      color: Colors.green),
                                ),
                                Text(a.qty!),
                                IconButton(
                                  color: Colors.red[600],
                                  onPressed: () {
                                    _addQuantity(a, "Kurang");
                                  },
                                  icon: const Icon(
                                      Icons.indeterminate_check_box,
                                      color: Colors.red),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      totalPrice == "0"
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Total Harga : Rp. ${price.format(int.parse(totalPrice))}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.orange),
                                    child: const Text(
                                      "Check Out",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Isi Keranjang Masih Kosong",
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

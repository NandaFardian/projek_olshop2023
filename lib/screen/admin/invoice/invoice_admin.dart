import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olshop2023/model/invoiceModel.dart';
import 'package:olshop2023/network/network.dart';
import 'package:http/http.dart' as http;
import 'package:olshop2023/screen/admin/invoice/invoice_admin_detail.dart';

class InvoiceAdmin extends StatefulWidget {
  const InvoiceAdmin({super.key});

  @override
  State<InvoiceAdmin> createState() => _InvoiceAdminState();
}

class _InvoiceAdminState extends State<InvoiceAdmin> {
  var loading = false;
  var cekData = false;

  List<InvoiceModel> list = [];

  _fetchData() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(Uri.parse(NetworkURL.invoice()));
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
            list.add(InvoiceModel.fromJson(i as Map<String, dynamic>));
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
          'Invoice Kita Bersama',
          style: TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'roboto',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
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
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(
                                  builder: (context) => InvoiceAdminDetail(a,
                                ),
                                ),
                                );
                              },
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
                                              "No Invoice : ${a.invoice}",
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Source Sans Pro',
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              "Status : ${a.status}",
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Source Sans Pro',
                                                  color: Colors.black),
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
                        "Belum Ada Informasi Yang Di Tambahkan",
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

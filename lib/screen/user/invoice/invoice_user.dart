import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/model/invoiceModel.dart';
import 'package:olshop2023/screen/repository/invoice_repository.dart';
import 'package:olshop2023/screen/user/invoice/invoice_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

final price = NumberFormat("#,##0", 'en_US');

class _InvoiceState extends State<Invoice> {
  String? userid;

  InvoiceRepository invoiceRepository = InvoiceRepository();
  List<InvoiceModel> list = [];

  var loading = false;
  var cekData = false;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userid = pref.getString("id")!;
    });
    await invoiceRepository.fetchdata(list, userid!, () {
      setState(() {
        loading = true;
      });
    }, cekData);
    print("List 0 : ${list[0].invoice}");
  }

  Future<void> refresh() async {
    getPref();
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
          "Invoice",
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.white,
            fontFamily: 'MaisonNeue',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                final a = list[i];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InvoiceDetail(a)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "No Invoice               ${a.invoice}",
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MaisonNeue',
                            color: Colors.black),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: const Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
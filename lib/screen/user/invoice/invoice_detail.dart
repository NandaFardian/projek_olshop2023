import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshop2023/model/invoiceModel.dart';

class InvoiceDetail extends StatefulWidget {
  final InvoiceModel model;
  const InvoiceDetail(this.model, {super.key});

  @override
  State<InvoiceDetail> createState() => _InvoiceDetailState();
}

final price = NumberFormat("#,##0", 'en_US');

class _InvoiceDetailState extends State<InvoiceDetail> {
  Future<void> onRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          'Detail Invoice',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'Cairo',
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
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "No. INVOICE ${widget.model.invoice}",
              style: const TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'MaisonNeue',
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            ListView.builder(
              itemCount: widget.model.detail.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                final a = widget.model.detail[i];
                var totalPrice = int.parse(a.qty!) * int.parse(a.harga!);
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Nama Produk ${a.nmProduk}",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'MaisonNeue',
                                color: Colors.black),
                          ),
                          Text(
                            "Jumlah ${a.qty}",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'MaisonNeue',
                                color: Colors.black),
                          ),
                          Text(
                            "Harga ${price.format(int.parse(a.harga!))}",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'MaisonNeue',
                                color: Colors.black),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Total ${price.format(totalPrice)}"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
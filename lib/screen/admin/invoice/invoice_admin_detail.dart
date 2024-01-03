import 'package:flutter/material.dart';
import 'package:olshop2023/model/invoiceModel.dart';

class InvoiceAdminDetail extends StatefulWidget {
  final InvoiceModel model;
  const InvoiceAdminDetail(this.model, {super.key});

  @override
  State<InvoiceAdminDetail> createState() => _InvoiceAdminDetailState();
}

class _InvoiceAdminDetailState extends State<InvoiceAdminDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: Text(
          "No Invoice : ${widget.model.invoice}",
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontFamily: 'MaisonNeue',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [                  
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.model.userid!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Divider(
                    color: Colors.grey,
                  ),
                ),   
                Text(
                  widget.model.invoice!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'MaisonNeue',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Divider(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  widget.model.status!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
                Text(
                  widget.model.mPembayaran!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Source Sans Pro',
                  ),
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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InvoiceUser extends StatefulWidget {
  const InvoiceUser({super.key});

  @override
  State<InvoiceUser> createState() => _InvoiceUserState();
}

class _InvoiceUserState extends State<InvoiceUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 228, 199),
      appBar: AppBar(
        title: const Text(
          "Invoice",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'roboto',
            backgroundColor: Color.fromARGB(255, 239, 147, 0),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 147, 0),
      ),
      body: const Center(
        child: Text("Invoice"),
      ),
    );
  }
}

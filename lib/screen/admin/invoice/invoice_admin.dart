import 'package:flutter/material.dart';

class InvoiceAdmin extends StatefulWidget {
  const InvoiceAdmin({super.key});

  @override
  State<InvoiceAdmin> createState() => _InvoiceAdminState();
}

class _InvoiceAdminState extends State<InvoiceAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 228, 199),
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
        
      )
    );
  }
}

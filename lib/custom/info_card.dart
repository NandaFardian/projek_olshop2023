import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  final String text;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  State<InfoCard> createState() {
    return _InfoCardState();
  }
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: const Color.fromARGB(255, 239, 147, 0),
            size: 18.0,
          ),
          title: Text(
            widget.text,
            style: const TextStyle(
                fontFamily: 'MaisonNeue', fontSize: 12.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

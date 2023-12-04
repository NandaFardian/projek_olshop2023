// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({required Key key, required this.images, required this.title, required this.textcolor})
      : super(key: key);
  final String images;
  final String title;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: <Widget>[
          Image.asset(
            images,
            scale: 2,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(color: textcolor, fontSize: 8.0),
          )
        ],
      ),
    );
  }
}

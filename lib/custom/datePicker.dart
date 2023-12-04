// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DateDropDown extends StatelessWidget {
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  const DateDropDown(
      {required Key key,
      required this.labelText,
      required this.valueText,
      required this.valueStyle,
      required this.onPressed,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          baseStyle: valueStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                valueText,
                style: valueStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70,
              )
            ],
          ),
        ));
  }
}

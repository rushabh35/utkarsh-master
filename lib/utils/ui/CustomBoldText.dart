import 'package:flutter/material.dart';

class CustomBoldText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;

  CustomBoldText({
    required this.text,
    this.textColor = Colors.black, // Default text color is black
    this.fontSize = 16.0, // Default font size is 16.0
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,

        fontWeight: FontWeight.w900,
        decoration: TextDecoration.none,
      ),
    );
  }
}

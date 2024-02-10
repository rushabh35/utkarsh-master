import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;


    const CustomTextWidget({super.key,
    required this.text,
    this.textColor = Colors.black, // Default text color is black
    this.fontSize = 16.0, // Default font size is 16.0
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        decoration: TextDecoration.none,
      ),
    );
  }
}

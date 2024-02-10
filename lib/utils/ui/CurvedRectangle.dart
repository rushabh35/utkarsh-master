import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurvedRectangleTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  final Color backgroundColor;
  final Color textColor;
  final TextInputType keyboardType;
  final double width;
  final double height;
  const CurvedRectangleTextField({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.keyboardType = TextInputType.text,
    required this.width,
    required this.height,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0), // Custom border radius
      ),
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(color: textColor), // Hint text color
          border: InputBorder.none, // Remove input border
        ),
        style: TextStyle(color: textColor), // Text color
      ),
    );
  }
}

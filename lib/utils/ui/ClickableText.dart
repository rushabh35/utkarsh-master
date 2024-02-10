import 'package:flutter/material.dart';
class ClickableText extends StatelessWidget {
  late String text;
  final Color textColor;
  late Function onPressed;
  late double fontSize;
  ClickableText({super.key, required this.text, this.textColor = Colors.blue, required this.onPressed, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GestureDetector(

        onTap : () => onPressed(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            decoration: TextDecoration.none,
          ),
        ),

      );
  }

}
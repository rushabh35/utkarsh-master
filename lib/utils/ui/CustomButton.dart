import 'package:flutter/material.dart';

import '../../constants/app_constants_colors.dart';
class CustomButton extends StatelessWidget {
  late String text;
  late Function onPressed;
  late double width;
  late double height;
  late Color buttonColor;
  CustomButton({super.key, required this.text, required this.onPressed,  this.width = 500,  this.height = 50, this.buttonColor = AppConstantsColors.grey});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(

        onPressed : () => onPressed(),
        style: ElevatedButton.styleFrom(

          foregroundColor: Colors.black, 
          backgroundColor: buttonColor, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
          ),
        ),
        child: Text(text),

      ),
    );
  }
  
}
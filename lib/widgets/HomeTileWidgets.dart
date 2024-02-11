import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/FundRaising/FundRaising_create.dart';
import 'package:utkarsh/screens/LandingScreen.dart';
import 'package:utkarsh/utils/ui/CustomTextWidget.dart';

class HomeTileWidgets extends StatelessWidget {
  final String heading;
  final String tileContent;
  final Color tileColor;
  final double height;
  final double width;
  final double titlefontSize;
  final double headingfontSize;
  final Icon icon;
  final VoidCallback onPressed; // Add this parameter


  const HomeTileWidgets({
    Key? key,
    required this.titlefontSize,
    required this.headingfontSize,
    required this.heading,
    required this.tileContent,
    required this.tileColor,
    required this.height,
    required this.width,
    required this.icon,
    required this.onPressed, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
        color : tileColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 0),
                  child: icon,
                ),
                SizedBox(
                  width: 20,
                ),
                Text( heading,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: headingfontSize,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left : 12),
              child: CustomTextWidget(text: tileContent, textColor: Colors.black, fontSize: titlefontSize),
            ),
            ElevatedButton(
              style : ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                foregroundColor: Colors.black,
                backgroundColor: tileColor,// Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                ),
              ),
              onPressed: onPressed, 
              child: Container(
                width: 150,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
                      child: CustomTextWidget(text: "Create Fund Raising", textColor: Colors.black, fontSize: 13),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, bottom: 10.0, top : 10),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 13,),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

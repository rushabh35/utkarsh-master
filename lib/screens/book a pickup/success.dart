
import 'package:flutter/material.dart';
import 'package:utkarsh/screens/Home/Home.dart';
import 'package:utkarsh/screens/Home/Navbar.dart';



class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key}) : super(key: key);


  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

Color themeColor = const Color(0xFFCB3C61);

class _SuccessPageState extends State<SuccessPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/card.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // const Text(
            //   "Payment done Successfully",
            //   style: TextStyle(
            //     color: Colors.black87,
            //     fontWeight: FontWeight.w400,
            //     fontSize: 17,
            //   ),
            // ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "Click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child:  ElevatedButton(
                  style:ButtonStyle(

                      backgroundColor: MaterialStateProperty.all(themeColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // side: BorderSide(color: Colors.red)
                          )
                      )
                  ),
                   onPressed: () {  Navigator.push(context,MaterialPageRoute(
                       builder: (context) =>  BottomNavBar() )); },
                  child: const Text('Home',style: TextStyle(fontSize: 18)),
              ),


            ),
          ],
        ),
      ),
    );
  }
}
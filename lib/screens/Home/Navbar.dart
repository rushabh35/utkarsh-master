// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:her2/pages/ui/HomePage.dart';
// import 'package:her2/pages/blogs.dart';
import 'package:line_icons/line_icons.dart';
import 'package:utkarsh/screens/Authentications/NGOSignUp.dart';
import 'package:utkarsh/screens/Home/Home.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});



  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int _selectedIndex = 0;

  late List screens = [];

  @override
  void initState() {
    screens = [
        const HomePage(),
      const NGOSignUp(),
      const NGOSignUp(),
      const NGOSignUp(),
      // Blog(),
      // HomePage(title: "Her")
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //     appBar: AppBar(
      //       elevation: 20,
      //       backgroundColor: Colors.black,
      //       title: const Text('HER'),
      //       actions: <Widget>[
      //   IconButton(
      //     icon: Icon(
      //       Icons.settings,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //        Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Settings()),
      // );
      //     },
      //   )
      // ],
      //     ),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              // backgroundColor: AppConstantsColors.primaryColor,
              // rippleColor: Color.fromARGB(255, 0, 183, 255),
              // hoverColor: Color.fromARGB(255, 38, 141, 132),
              gap: 8,
              activeColor: const Color.fromARGB(255, 0, 0, 0),
              iconSize: 24,

              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color.fromARGB(255, 143, 143, 143),
              color: const Color.fromARGB(255, 153, 153, 153),
              tabs: const [
                GButton(
                  backgroundColor: Color.fromARGB(255, 236, 153, 236),
                  iconActiveColor: Color.fromARGB(255, 155, 21, 155),
                  textColor: Color.fromARGB(255, 155, 21, 155),
                  icon: LineIcons.home,
                  // text: 'Home',
                  // onPressed: () {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Overview()));
                  // },
                ),
                GButton(
                  // backgroundColor: Colo,
                  backgroundColor: Color.fromARGB(255, 147, 235, 96),
                  iconActiveColor: Color.fromARGB(255, 21, 156, 3),
                  textColor: Color.fromARGB(255, 21, 156,3),
                  icon: LineIcons.book
                  // onPressed: () {
                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=> AddInfo()));
                  // },
                  // text: 'Education',
                ),
                GButton(
                  backgroundColor: Color.fromARGB(255, 219, 231, 87),
                  iconActiveColor: Color.fromARGB(255, 110, 122, 2),
                  textColor: Color.fromARGB(255, 133, 124, 6),
                  icon: Icons.lunch_dining,

                  // text: 'Food',
                  // onPressed: () {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Overview()));
                  // },
                ),
                GButton(
                  iconActiveColor:Color.fromARGB(255, 2, 76, 173),
                  textColor: Color.fromARGB(255, 2, 76, 173),
                  backgroundColor: Color.fromARGB(255, 3, 233, 250),
                  icon: Icons.health_and_safety,
                  // onPressed: () {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Overview()));
                  // },
                  // text: 'Health',
                ),
                // GButton(
                //   iconActiveColor:Color.fromARGB(255, 243, 179, 2),
                //   textColor: Color.fromARGB(255, 243, 179, 2),
                //   backgroundColor: Color.fromARGB(255, 252, 248, 2),
                //   icon: LineIcons.book,
                //   // onPressed: () {
                //   //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Overview()));
                //   // },
                //   // text: 'Blog',
                // ),
              ],
              // selectedIndex: _selectedIndex,
              // onTabChange: (index) {
              //   setState(() {
              //     _selectedIndex = index;
              //   });
              // },
              onTabChange: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/AdminSide/Event%20Registration/event_add.dart';
import 'package:utkarsh/screens/AdminSide/HomeScreen/AdminBookAPickup.dart';
import 'package:utkarsh/screens/LandingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppConstantsColors.accentColor,
              ),
              child: Text('Admin Side Drawer'),
            ),
            ListTile(
              title: const Text('Event Registration'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EventAdd()));
              },
            ),
            ListTile(
              title: const Text('Book A Pickup'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>  AdminBookAPickup()));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Log Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LandingPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: AppConstantsColors.whiteColor,
        title: const Text(
          "ADMIN HOME",
          style: TextStyle(
            color: AppConstantsColors.blackColor,
          ),
        ),
      ),
      body: const Text(
        "Home Screen"
      ),
    );
  }
}

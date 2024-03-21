import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/LandingScreen.dart';
import 'package:utkarsh/screens/NGOScreens/NGODetailsScreen.dart';
import 'package:utkarsh/screens/NGOScreens/NGOEventCreation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utkarsh/screens/NGOScreens/ProfileNGO.dart';

class NGOHome extends StatefulWidget {
  const NGOHome({super.key});

  @override
  State<NGOHome> createState() => _NGOHomeState();
}

class _NGOHomeState extends State<NGOHome> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Text('NGO Home'),
    // );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: AppConstantsColors.accentColor,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('NGO Details'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NGODetailsPage()));
                },
              ),
              ListTile(
                title: const Text('NGO Event Creation'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NGOEventCreation()));
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileNGO(loggedInEmail: FirebaseAuth
                                          .instance.currentUser!.email,)));
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
          iconTheme: const IconThemeData(color: Colors.black),

          clipBehavior: Clip.none,
          backgroundColor: AppConstantsColors.whiteColor,
          // leading: const Icon(
          //   Icons.arrow_back_sharp,
          //   color: AppConstantsColors.blackColor,
          // ),
          title: const Text(
            'Utkarsh',
            style: TextStyle(
              color: AppConstantsColors.blackColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

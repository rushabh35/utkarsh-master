// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/AdminSide/AssignRoles/AssignRoles.dart';
import 'package:utkarsh/screens/AdminSide/FundRaisings/AdminFundRaising.dart';
import 'package:utkarsh/screens/AdminSide/Event%20Registration/event_add.dart';
import 'package:utkarsh/screens/AdminSide/HomeScreen/AdminBookAPickup.dart';
import 'package:utkarsh/screens/Authentications/UsersSignIn.dart';
import 'package:utkarsh/screens/Donations/donations_home.dart';
import 'package:utkarsh/screens/Forums/Forum_home.dart';
import 'package:utkarsh/screens/FundRaising/FundRaisingHome.dart';
import 'package:utkarsh/screens/FundRaising/FundRaising_create.dart';
import 'package:utkarsh/screens/LandingScreen.dart';
import 'package:utkarsh/screens/NearbyNGO/NearbyNGO.dart';
import 'package:utkarsh/screens/Profile/profile.dart';
import 'package:utkarsh/screens/book%20a%20pickup/BookPickup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utkarsh/screens/volunteeres%20registration/Volunteer_Reegistration_Home.dart';
import '../../widgets/HomeTileWidgets.dart';
import '../../widgets/Menubar/MenuBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
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
                        title: const Text('Book A Pickup'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BookPickup()));
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        title: const Text('Volunteer Registration'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const VolunteerRegistrationHome()));
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        title: const Text('Donations'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DonationsHome()));
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      // ListTile(
                      //   title: const Text('Forums'),
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => ForumScreen()));
                      //     // Update the state of the app.
                      //     // ...
                      //   },
                      // ),
                      ListTile(
                        title: const Text('Fund Raising'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FundRaisingHome()));
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        title: const Text('Nearby NGOs'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NearbyNGO()));
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      if ((snapshot.data!.data()
                              as Map<String, dynamic>)['isAdmin'] ==
                          true) ...[
                        ListTile(
                          title: const Text('Event Registration Admin Side'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EventAdd()));
                          },
                        ),
                        ListTile(
                          title: const Text('Book A Pickup Admin Side'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminBookAPickup()));
                          },
                        ),
                        ListTile(
                          title: const Text('Fund Raising Admin Side'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminFundRaising()));
                          },
                        ),
                        ListTile(
                          title: const Text('Assign Roles'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AssignRoles()));
                          },
                        ),
                      ],
                      ListTile(
                        title: const Text('Profile'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      loggedInEmail: FirebaseAuth
                                          .instance.currentUser!.email,
                                    )),
                          );

                          // Update the state of the app.
                          // ...
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
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

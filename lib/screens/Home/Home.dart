// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/AdminSide/AssignRoles/AssignRoles.dart';
import 'package:utkarsh/screens/AdminSide/Event%20Registration/event_reg_home.dart';
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
import 'package:utkarsh/screens/book%20a%20pickup/BookPickupForm.dart';
import 'package:utkarsh/screens/volunteeres%20registration/Volunteer_Reegistration_Home.dart';
import '../../widgets/HomeTileWidgets.dart';
import '../../widgets/Menubar/MenuBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false; //bool variable created
  bool _foreigner = false;
  String location = 'Null, Press Button';
  String Address = 'Address';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    Address =
        '${place.street},${place.name},${place.thoroughfare} ,${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    // if({place.country}!="India"){
    //   _foreigner = true;
    // }else{
    //   _foreigner = false;
    // }
    // if(placemarks[2]!="IN"){
    //   _foreigner = true;
    // }
    setState(() {});
  }

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
                  backgroundColor: AppConstantsColors.brightWhiteColor,
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 200, // Adjust the height accordingly
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/logo.png',
                              height: 250,
                              width: 250,),  // Use SvgPicture.network if the SVG is hosted online
                            ),
                            // Text('Utkarsh', style: TextStyle(fontSize: 16)), // Customizable text below the image
                          ],
                        ),
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
                                builder: (context) => const EventRegHome()));
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
                  backgroundColor: AppConstantsColors.brightWhiteColor,
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
                body: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              "HELP US WITH YOUR EXACT \n"
                              "LOCATION",
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: AppConstantsColors.blackColor,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              "This allows us to check if your area is \n"
                              "within our coverage",
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                // fontFamily:
                              ),
                            ),
                            const SizedBox(height: 30),
                            // const Padding(
                            //   padding:
                            //       EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            //   child: TextField(
                            //     decoration: InputDecoration(
                            //       enabledBorder: OutlineInputBorder(
                            //         borderSide:
                            //             BorderSide(color: Colors.black, width: 2.0),
                            //       ),
                            //       hintText: 'Building , Block , Area',
                            //       prefixIcon:
                            //           Icon(Icons.location_on, color: Colors.black),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 15),
                            const Text(
                              "----- OR -----",
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                // fontFamily:
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppConstantsColors.accentColor),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () async {
                                Position position =
                                    await _getGeoLocationPosition();
                                location =
                                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                                GetAddressFromLatLong(position);
                              },
                              child: const Text(
                                'Auto Detect Location📍',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[300],
                                ),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(Address,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (Address != 'Address') ...[
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(10)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                  onPressed: () {
                                    if (_foreigner == true) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const BookPickupForm(),
                                      ));
                                    } else {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const BookPickupForm(),
                                      ));
                                    }
                                  },
                                  child: const Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  )),
                            ]
                          ],
                        ),
                      ),
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

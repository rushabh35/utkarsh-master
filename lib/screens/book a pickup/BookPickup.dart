// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';

import 'BookPickupForm.dart';

class BookPickup extends StatefulWidget {
  const BookPickup({Key? key}) : super(key: key);

  @override
  State<BookPickup> createState() => _BookPickupState();
}

class _BookPickupState extends State<BookPickup> {
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
    return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
            color: Colors.grey,
          ),
            backgroundColor: Colors.white,
            title: const Row(
              children: [
                Text('Utkarsh', style: TextStyle(color: Colors.black)),
                // const Text('Need Help?',style:TextStyle(color:Colors.black))
              ],
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
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () async {
                          Position position = await _getGeoLocationPosition();
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    MaterialStateProperty.all(Colors.black),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(10)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),    
                            onPressed: () {
                              if (_foreigner == true) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const BookPickupForm(),
                                ));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const BookPickupForm(),
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
        );
  }
}

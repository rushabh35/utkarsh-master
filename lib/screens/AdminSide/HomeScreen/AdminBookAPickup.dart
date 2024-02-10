import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/AdminSide/Event%20Registration/event_add.dart';
import 'package:utkarsh/screens/LandingScreen.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminBookAPickup extends StatefulWidget {
  const AdminBookAPickup({Key? key}) : super(key: key);

  @override
  State<AdminBookAPickup> createState() => _AdminBookAPickupState();
}

class _AdminBookAPickupState extends State<AdminBookAPickup> {
  List<File> selectedImages = [];
  final picker = ImagePicker();
  Future getImages() async {
    List<XFile>? pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
    }
  }

  Future<void> _uploadImages(String documentId) async {
    try {
      for (File imageFile in selectedImages) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("pickupInfoImages")
            .child("$documentId/$uniqueFileName.jpg");

        UploadTask uploadTask = storageReference.putFile(imageFile);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Update Firestore document with the image URL
          await FirebaseFirestore.instance
              .collection('pickupInfo')
              .doc(documentId)
              .update({
            'images': FieldValue.arrayUnion([imageUrl]),
          });
        });
      }
    } catch (error) {
      print("Error uploading image: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EventAdd()));
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('pickupInfo').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: const EdgeInsets.all(20),
                  color: AppConstantsColors.blackColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${snapshot.data!.docs[i]['name']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Location: ${snapshot.data!.docs[i]['location']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "PhonNumber: ${snapshot.data!.docs[i]['mobile']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Pickup date: ${snapshot.data!.docs[i]['pickupDate']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Time: ${snapshot.data!.docs[i]['pickupTime']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Quantity: ${snapshot.data!.docs[i]['quantity']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              buttonColor: AppConstantsColors.accentColor,
                              width: sizeWidth * 0.3,
                              height: 30,
                              text: snapshot.data!.docs[i]['order_open'] == true
                                  ? "Pickup Open"
                                  : "Pickup Done",
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('pickupInfo')
                                    .doc(snapshot.data!.docs[i].id)
                                    .update({
                                  'order_open': false,
                                });
                              },
                            ),
                            if (snapshot.data!.docs[i]['order_open'] == false)
                              CustomButton(
                                buttonColor: AppConstantsColors.accentColor,
                                width: sizeWidth * 0.4,
                                height: 30,
                                text: "Upload Images of Pickup",
                                onPressed: () async {
                                  await getImages();
                                  _uploadImages(snapshot.data!.docs[i].id);
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

  
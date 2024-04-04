import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/utils/ui/CustomTextWidget.dart';
import 'package:utkarsh/widgets/FullScreenImagePreview.dart';
import '../../constants/app_constants_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PickupInformationUser extends StatefulWidget {
  const PickupInformationUser({super.key});

  @override
  State<PickupInformationUser> createState() => PickupInformationUserState();
}

class PickupInformationUserState extends State<PickupInformationUser> {
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
            Text(
              'Pickup Information',
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: AppConstantsColors.blackColor,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var userData = snapshot.data!.data();
              if (userData != null &&
                  (userData as Map).containsKey('pickupInfo')) {
                List<String> pickupInfoIDs =
                    List<String>.from(userData['pickupInfo']);
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: pickupInfoIDs
                        .map((pickupInfoID) =>
                            buildPickupInfoCard(pickupInfoID, sizeWidth))
                        .toList(),
                  ),
                );
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline, // Use an information icon
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No pickup information available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Widget buildPickupInfoCard(String pickupInfoID, double sizeWidth) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('pickupInfo')
        .doc(pickupInfoID)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData) {
        return const Center(child: Text("No data available"));
      }
      // Extract pickupInfo data
      Map<String, dynamic>? pickupInfoData =
          snapshot.data?.data() as Map<String, dynamic>?;
      if (pickupInfoData == null)
        return const SizedBox(); // Return an empty widget if data is null

      String name = pickupInfoData['name'];
      String location = pickupInfoData['location'];
      String mobile = pickupInfoData['mobile'];
      String pickupTimestamp = pickupInfoData['pickupTimestamp']
          .toDate()
          .toString()
          .substring(0, 16);
      String quantity = pickupInfoData['quantity'];
      List<dynamic>? images = pickupInfoData['images'];

      return Card(
        margin: const EdgeInsets.all(10),
        color: Colors.black,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Icon(Icons.person_outline,
              //         color: AppConstantsColors.accentColor),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Text(
              //         "Name: $name",
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: AppConstantsColors.blackColor,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 10),
              infoRow(Icons.person_outline, "Name: $name", 18, Colors.white),
          SizedBox(height: 10), // Increase spacing between lines

          infoRow(Icons.location_on_outlined, "Location: $location", 16, Colors.white),
          SizedBox(height: 10), // Increase spacing between lines

              infoRow(Icons.phone_android_outlined, "PhoneNumber: $mobile", 16, Colors.white),
          SizedBox(height: 10), // Increase spacing between lines

              infoRow(Icons.access_time_outlined,
                  "Pickup TimeStamp: $pickupTimestamp", 16, Colors.white),
          SizedBox(height: 10), // Increase spacing between lines

              infoRow(Icons.inventory_2_outlined, "Quantity: $quantity", 16, Colors.white),
          SizedBox(height: 10), // Increase spacing between lines

              pickupStatus(pickupInfoData['order_open']),
          SizedBox(height: 10), // Increase spacing between lines

              if (images != null && images.isNotEmpty)
                imageGallery(context, images),
            ],
          ),
        ),
      );
    },
  );
}

Widget infoRow(IconData icon, String text, double fontSize, Color textColor) => Row(
  children: [
    Icon(icon, color: AppConstantsColors.accentColor, size: 20),
    SizedBox(width: 10),
    Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize, // Set the font size as needed
          color: textColor, // Set the text color to white
        ),
      ),
    ),
  ],
);

Widget pickupStatus(bool? orderOpen) => Row(
      children: [
        Icon(
            orderOpen == true
                ? Icons.pending_actions
                : Icons.check_circle_outline,
            color: orderOpen == true ? Colors.orange : Colors.green),
        SizedBox(width: 10),
        Text(
          orderOpen == true ? 'Pickup Pending' : 'Pickup Done',
          style: TextStyle(
              color: orderOpen == true ? Colors.orange : Colors.green),
        ),
      ],
    );

Widget imageGallery(BuildContext context, List<dynamic> images) => SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImageView(imageUrl: images[index]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Hero(
                tag: images[index], // Unique tag for hero animation
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    images[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

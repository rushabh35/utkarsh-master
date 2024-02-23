// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/repository/UserRepository.dart';
import 'package:utkarsh/screens/FundRaising/FundsRaisedByUser.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';
import 'package:utkarsh/utils/ui/CustomTextWidget.dart';
import 'package:utkarsh/widgets/FullScreenImagePreview.dart';
import '../../constants/app_constants_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final String? loggedInEmail;  

  const ProfileScreen({
    Key? key,
    required this.loggedInEmail,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userRepo = Get.put(UserRepository());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch data from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(user.uid)
          .get();
      String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
      if (snapshot.exists) {
        // Extract data from the snapshot
        Map<String, dynamic> userData = snapshot.data()!;
        String name = userData['name'];
        String phoneNumber = userData['number'];

        // Set the fetched data in the text controllers
        nameController.text = name;
        phoneController.text = phoneNumber;
      } 
      else {
        print('User does not exist');
        return null;
      }
    }
  }

  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: widget.loggedInEmail);
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            sizeHeight * 0.05), // Set the desired app bar height
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              color: AppConstantsColors.blackColor,
            ),
          ),
          centerTitle: true,
          elevation: 0, // Remove the app bar shadow
          backgroundColor: Colors.white, // Set the background color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: sizeHeight * 0.01),

                // SizedBox(height: sizeHeight * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: TextField(
                        enabled: false,
                        cursorColor: AppConstantsColors.accentColor,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConstantsColors.accentColor),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: TextField(
                        enabled: false,
                        cursorColor: AppConstantsColors.accentColor,
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConstantsColors.accentColor),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: TextField(
                        enabled: false,
                        cursorColor: AppConstantsColors.accentColor,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Number',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppConstantsColors.accentColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: sizeHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: sizeWidth * 0.24,
                          height: 1, // Adjust the height as needed
                          color: AppConstantsColors.grey, // Set the color here
                        ),
                        const CustomTextWidget(
                          text: 'Pickup inforamtion',
                          textColor: AppConstantsColors.blackColor,
                        ),
                        Container(
                          width: sizeWidth * 0.24,
                          height: 1, // Adjust the height as needed
                          color: AppConstantsColors.grey, // Set the color here
                        ),
                      ],
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          var userData = snapshot.data!.data();
                          if (userData != null && (userData as Map).containsKey('pickupInfo')) {
                            List<String> pickupInfoIDs = List<String>.from(userData['pickupInfo']);
                            return Column(
                              children: pickupInfoIDs
                                  .map((pickupInfoID) => buildPickupInfoCard(
                                      pickupInfoID, sizeWidth))
                                  .toList(),
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
                    SizedBox(height: sizeHeight * 0.05),
                    CustomButton(
                      width: sizeWidth * 0.85,
                      height: 40,
                      buttonColor: AppConstantsColors.yellowColor,
                      text: 'Your FundRaisings', 
                      onPressed: () {
                        try {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FundsRaisedByUser()));
                        } catch (e) {
                          print("Navigation error: $e");
                        }
                      },
                      
                    ),
                  ],

                ),
                SizedBox(height: sizeHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildPickupInfoCard(String pickupInfoID, double sizeWidth) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('pickupInfo')
        .doc(pickupInfoID)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // Extract pickupInfo data
        Map<String, dynamic> pickupInfoData =
            snapshot.data!.data() as Map<String, dynamic>;
        String name = pickupInfoData['name'];
        String location = pickupInfoData['location'];
        String mobile = pickupInfoData['mobile'];
        String pickupTimestamp = pickupInfoData['pickupTimestamp'].toDate().toString().substring(0, 16);
        String quantity = pickupInfoData['quantity'];
        List<dynamic>? images = pickupInfoData['images'];

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
                  "Name: $name",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Location: $location",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "PhoneNumber: $mobile",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Pickup TimeStamp: $pickupTimestamp",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                
                Text(
                  "Quantity: $quantity",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                if (pickupInfoData['order_open'] == true)
                  const CustomTextWidget(
                    textColor: AppConstantsColors.accentColor,
                    text: 'Pickup Pending',
                  ),
                if (pickupInfoData['order_open'] == false)
                  const CustomTextWidget(
                    textColor: AppConstantsColors.accentColor,
                    text: 'Pickup Done',
                  ),
                if (images != null && images.isNotEmpty)
                  SizedBox(
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
                                builder: (context) => FullScreenImageView(
                                  imageUrl: images[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Hero(
                              tag: images[
                                  index], // Unique tag for hero animation
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
                  ),
              ],
            ),
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

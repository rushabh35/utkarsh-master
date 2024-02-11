import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
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

class FundsRaisedByUser extends StatefulWidget {
  const FundsRaisedByUser({super.key});

  @override
  State<FundsRaisedByUser> createState() => _FundsRaisedByUserState();
}

class _FundsRaisedByUserState extends State<FundsRaisedByUser> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Funds Raised '),
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var userData = snapshot.data!.data();
                    if (userData != null &&
                        (userData as Map).containsKey('EducationFR')) {
                      List<String> eduFRIds =
                          List<String>.from(userData['EducationFR']);
                      return Column(
                        children: eduFRIds
                            .map((eduFrId) =>
                                buildPickupInfoCard(eduFrId, sizeWidth))
                            .toList(),
                      );
                    } else {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline, // Use an information icon
                            size: 50,
                            color: Color.fromARGB(255, 24, 23, 23),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No Funds Raised',
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
                }),
          ],
        ),
      ),
    );
  }
}

Widget buildPickupInfoCard(String educationID, double sizeWidth) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('EducationFR')
        .doc(educationID)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // Extract pickupInfo data
        Map<String, dynamic> eduFRInfoData =
            snapshot.data!.data() as Map<String, dynamic>;
        String name = eduFRInfoData['name'];
        String raisedBy = eduFRInfoData['raisedBy'];
        String mobile = eduFRInfoData['mobile'];
        String relation = eduFRInfoData['relation'];
        String age = eduFRInfoData['age'];
        String description = eduFRInfoData['description'];
        String fundsRequired = eduFRInfoData['fundsRequired'];
        List<dynamic>? images = eduFRInfoData['images'];
        String verified = eduFRInfoData['verified'];

        return Stack(
          children: [
            Card(
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
                      "Relation: $relation",
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
                      "Age: $age",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Description: $description",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "fundsRequired: $fundsRequired",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),

                    // if (eduFRInfoData['verified'] == false)
                    //   const CustomTextWidget(
                    //     textColor: AppConstantsColors.accentColor,
                    //     text: 'Distribution of ',
                    //   ),
                    // if (eduFRInfoData['order_open'] == false)
                    //   const CustomTextWidget(
                    //     textColor: AppConstantsColors.accentColor,
                    //     text: 'Distribution of Donations Done',
                    //   ),

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
                // ),
              ),
            ),
            if (eduFRInfoData['verified'] == "Pending")
              Positioned(
                top: 30,
                right: 12,
                child: Transform.rotate(
                  angle: 0.75,
                  child: Container(
                    color: AppConstantsColors.yellowColor,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: const Text(
                      'Not verified',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppConstantsColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            if (eduFRInfoData['verified'] == "Rejected")
              Positioned(
                top: 30,
                right: 12,
                child: Transform.rotate(
                  angle: 0.75,
                  child: Container(
                    color: AppConstantsColors.redColor,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: const Text(
                      'Rejected',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            if (eduFRInfoData['verified'] == "Approved")
              Positioned(
                top: 30,
                right: 12,
                child: Transform.rotate(
                  angle: 0.75,
                  child: Container(
                    color: AppConstantsColors.greenColor,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: const Text(
                      'Approved',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

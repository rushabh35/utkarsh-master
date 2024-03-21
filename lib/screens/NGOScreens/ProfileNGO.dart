import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/repository/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class ProfileNGO extends StatefulWidget {
  final String? loggedInEmail;  

  const ProfileNGO({
    Key? key,
    required this.loggedInEmail,
  }) : super(key: key);

  @override
  State<ProfileNGO> createState() => _ProfileNGOState();
}

class _ProfileNGOState extends State<ProfileNGO> {
  final userRepo = Get.put(UserRepository());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController regNoController = TextEditingController();

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
          .collection('NGO')
          .doc(user.uid)
          .get();
      String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
      if (snapshot.exists) {
        // Extract data from the snapshot
        Map<String, dynamic> userData = snapshot.data()!;
        String name = userData['name'];
        String phoneNumber = userData['number'];
        String regNo = userData['regNo'];

        // Set the fetched data in the text controllers
        nameController.text = name;
        phoneController.text = phoneNumber;
        regNoController.text = regNo;
      } 
      else {
        print('User does not exist');
        return null;
      }
    }
  }

  @override
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
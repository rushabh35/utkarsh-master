import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utkarsh/screens/AdminSide/HomeScreen/AdminBookAPickup.dart';
import 'package:utkarsh/screens/AdminSide/HomeScreen/AdminHomeScreen.dart';
import '../../constants/app_constants_colors.dart';
import '../../utils/ui/ClickableText.dart';
import '../../utils/ui/CustomBoldText.dart';
import '../../utils/ui/CustomButton.dart';
import '../../utils/ui/CustomTextWidget.dart';
import '../../widgets/LoginTextField.dart';
import '../../widgets/PasswordTextField.dart';
import '../Home/Navbar.dart';
import 'UserSignUpPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController adminEmail = TextEditingController();
  TextEditingController adminPassword = TextEditingController();
  bool _isNotValid = false;
  // SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(height: sizeHeight * 0.2),
            CustomBoldText(
              text: 'Admin Login with Password',
              fontSize: sizeHeight * 0.06,
              textColor: AppConstantsColors.accentColor,
            ),

            LoginTextFieldWidget(
              controller: adminEmail,
              hintText: 'Email',
              errorText: _isNotValid ? "Enter Email Field" : null,
              
            ),

            PasswordTextField(
              controller: adminPassword,
              hintText: 'Password',
              errorText: _isNotValid ? "Enter password Field" : null,
            ),

            CustomButton(
              buttonColor: AppConstantsColors.accentColor,
              text: 'SIGN IN',
              onPressed: () => {
                // loginUser();
                if (adminEmail.text.isEmpty ||
                    adminPassword.text.isEmpty)
                  {
                    setState(() {
                      _isNotValid = true;
                    })
                  }
                else
                  {
                    setState(() {
                      _isNotValid = false;
                    }),
                        FirebaseFirestore.instance.collection("admin").doc("adminLogin").snapshots().forEach((element) {
                          if(element.data()?['adminEmail'] == adminEmail.text && element.data()?['adminPassword'] == adminPassword.text){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminHomeScreen()),
                            );
                          }
                        })
                      // FirebaseAuth.instance
                      //     .signInWithEmailAndPassword(
                      //         email: _emailController.text,
                      //         password: _passWordController.text)
                      //     .then((value) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const BottomNavBar()),
                      
                      //   );
                      // }).catchError((error) {
                      //   String errorMessage =
                      //       "An error occurred wrong email or incorrect password";
                      //   if (error.code == 'user-not-found') {
                      //     errorMessage = 'No user found for that email.';
                      //   } else if (error.code == 'wrong-password') {
                      //     errorMessage = 'Wrong password provided.';
                      //   }
                      //   // Display error message in the UI
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: const Text('Login Error'),
                      //         content: Text(errorMessage),
                      //         actions: [
                      //           ElevatedButton(
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: AppConstantsColors.accentColor,
                      //             ),
                      //             onPressed: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: const Text('OK'),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }),
                  },
              },
              width: sizeWidth * 0.92,
              height: sizeHeight * 0.06,
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Container(
            //       width: sizeWidth * 0.25,
            //       height: 1, // Adjust the height as needed
            //       color: AppConstantsColors.grey, // Set the color here
            //     ),
            //     const CustomTextWidget(
            //       text: 'Or continue with',
            //       textColor: AppConstantsColors.grey,
            //     ),
            //     Container(
            //       width: sizeWidth * 0.25,
            //       height: 1, // Adjust the height as needed
            //       color: AppConstantsColors.grey, // Set the color here
            //     ),
            //   ],
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const CustomTextWidget(
            //         text: 'Dont have an account? ',
            //         textColor: AppConstantsColors.blackColor),
            //     ClickableText(
            //       text: 'Sign Up',
            //       textColor: AppConstantsColors.redColor,
            //       fontSize: 14,
            //       onPressed: () {
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => const SignUpPage()));
            //       },
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

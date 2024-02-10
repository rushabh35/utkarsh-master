import 'package:flutter/material.dart';
import 'package:utkarsh/screens/Authentications/NGOSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utkarsh/screens/Home/Navbar.dart';
import 'package:utkarsh/screens/NGOScreens/NgoHome.dart';
import 'package:utkarsh/services/ngo_auth.dart';
import '../../constants/app_constants_colors.dart';
import '../../utils/ui/ClickableText.dart';
import '../../utils/ui/CustomBoldText.dart';
import '../../utils/ui/CustomButton.dart';
import '../../utils/ui/CustomTextWidget.dart';
import '../../widgets/LoginTextField.dart';
import '../../widgets/PasswordTextField.dart';
import 'UserSignUpPage.dart';
import 'package:provider/provider.dart';

class NGOSignIn extends StatefulWidget {
  const NGOSignIn({Key? key}) : super(key: key);

  @override
  State<NGOSignIn> createState() => _NGOSignInState();
}

class _NGOSignInState extends State<NGOSignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();
  bool _isNotValid = false;
  // SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    final NGOAuthServices _ngoAuthService =
        Provider.of<NGOAuthServices>(context);

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
              text: 'NGO Sign In',
              fontSize: sizeHeight * 0.06,
              textColor: AppConstantsColors.accentColor,
            ),

            LoginTextFieldWidget(
              controller: _emailController,
              hintText: 'NGO Email',
              errorText: _isNotValid ? "Enter Email Field" : null,
            ),

            PasswordTextField(
              controller: _passWordController,
              hintText: 'Password',
              errorText: _isNotValid ? "Enter password Field" : null,
            ),

            CustomButton(
              buttonColor: AppConstantsColors.accentColor,
              text: 'NGO SIGN IN',
              onPressed: () {
                if (_emailController.text.isEmpty ||
                    _passWordController.text.isEmpty) {
                  setState(() {
                    _isNotValid = true;
                  });
                } else {
                  setState(() {
                    _isNotValid = false;
                  });
                  _ngoAuthService.signIn(
                    email: _emailController.text,
                    password: _passWordController.text,
                  ).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NGOHome()),
                    );
                  }).catchError((error) {
                    String errorMessage =
                        "An error occurred wrong email or incorrect password";
                    if (error.code == 'user-not-found') {
                      errorMessage = 'No user found for that email.';
                    } else if (error.code == 'wrong-password') {
                      errorMessage = 'Wrong password provided.';
                    }
                    // Display error message in the UI
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Login Error'),
                          content: Text(errorMessage),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstantsColors.accentColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                }
              },
              width: sizeWidth * 0.92,
              height: sizeHeight * 0.06,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: sizeWidth * 0.25,
                  height: 1, // Adjust the height as needed
                  color: AppConstantsColors.grey, // Set the color here
                ),
                const CustomTextWidget(
                  text: 'Or continue with',
                  textColor: AppConstantsColors.grey,
                ),
                Container(
                  width: sizeWidth * 0.25,
                  height: 1, // Adjust the height as needed
                  color: AppConstantsColors.grey, // Set the color here
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomTextWidget(
                    text: 'Dont have an account? ',
                    textColor: AppConstantsColors.blackColor),
                ClickableText(
                  text: 'Sign Up',
                  textColor: AppConstantsColors.redColor,
                  fontSize: 14,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NGOSignUp()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/Authentications/AdminLogin.dart';
import 'package:utkarsh/screens/Authentications/NGOSignIn.dart';
import 'package:utkarsh/screens/Authentications/NGOSignUp.dart';
import '../../../../../utils/ui/CustomButton.dart';
import '../../../../../utils/ui/CustomTextWidget.dart';
import 'Authentications/UsersSignIn.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
    return  Container(
      color: AppConstantsColors.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/landing_image.png',
            height: sizeHeight * 0.4,
            width: sizeWidth * 0.8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                buttonColor: AppConstantsColors.accentColor,
                width: sizeWidth * 0.7,
                height: sizeHeight * 0.06,
                text: 'Users Sign In',
                onPressed: () {
                  try {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserSignIn()));
                  } catch (e) {
                    print("Navigation error: $e");
                  }
                },
              ),
              SizedBox(
                height: sizeHeight * 0.05,
              ),
              CustomButton(
                buttonColor: AppConstantsColors.accentColor,

                width: sizeWidth * 0.7,
                height: sizeHeight * 0.06,
                text: 'NGO Sign In',
                onPressed: () {
                  try {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NGOSignIn()));
                  } catch (e) {
                    print("Navigation error: $e");
                  }
                },
              ),
              SizedBox(
                height: sizeHeight * 0.05,
              ),
              CustomButton(
                buttonColor: AppConstantsColors.accentColor,
                width: sizeWidth * 0.7,
                height: sizeHeight * 0.06,
                text: 'Admin Login',
                onPressed: () {
                  try {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminLogin()));
                  } catch (e) {
                    print("Navigation error: $e");
                  }
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}

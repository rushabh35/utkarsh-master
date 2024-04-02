import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/screens/AdminSide/FundRaisings/EducationFRAdmin.dart';
import 'package:utkarsh/screens/AdminSide/FundRaisings/MedicalFRAdmin.dart';
import 'package:utkarsh/screens/Authentications/UsersSignIn.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';
class AdminFundRaising extends StatefulWidget {
  const AdminFundRaising({super.key});

  @override
  State<AdminFundRaising> createState() => _AdminFundRaisingState();
}

class _AdminFundRaisingState extends State<AdminFundRaising> {
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Raising Admin Side'),
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                height: sizeHeight * 0.06,
                width: sizeWidth * 0.7,
                text: "Education Fund Raisings", 
                buttonColor: AppConstantsColors.brightWhiteColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EducationFRAdmin()));
                }
              ),
              CustomButton(
                height: sizeHeight * 0.06,
                width: sizeWidth * 0.7,
                text: "Medical Fund Raisings", 
                buttonColor: AppConstantsColors.brightWhiteColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MedicalFRAdmin()));
                }
              ),
              
            ],
          ),
        ),
      )
    );
  }
}
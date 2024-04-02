import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/FundRaising/Education/Education_FR_home.dart';
import 'package:utkarsh/screens/FundRaising/Medical/Medical_FR_home.dart';
import 'package:utkarsh/widgets/HomeTileWidgets.dart';


class FundRaisingCreate extends StatefulWidget {
  const FundRaisingCreate({super.key});

  @override
  State<FundRaisingCreate> createState() => _FundRaisingCreateState();
}

class _FundRaisingCreateState extends State<FundRaisingCreate> {
  @override
  Widget build(BuildContext context) {
      var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Fund Raising'),
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeWidth * 0.07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeTileWidgets(
                heading: 'Education',
                height: sizeHeight * 0.3,
                width: sizeWidth * 0.75,
                tileColor: AppConstantsColors.accentColor,
                tileContent:
                    'Over 3 Million childrens in India are not able to receive good education.',
                titlefontSize: 20,
                headingfontSize: 30,
                icon: const Icon(
                  Icons.school,
                  color: AppConstantsColors.blackColor,
                  size: 40,
                ),
                onPressed: () {
                  try {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EducationFRHome()));
                  } catch (e) {
                    print("Navigation error: $e");
                  }
                },
              ),
              
              HomeTileWidgets(
                heading: 'Health',
                height: sizeHeight * 0.3,
                width: sizeWidth * 0.75,
                tileColor: Colors.orangeAccent,
                tileContent:
                    'Health is a state of physical, mental and social well-being in which disease and infirmity are absent.',
                titlefontSize: 20,
                headingfontSize: 30,
                icon: const Icon(
                  Icons.health_and_safety,
                  color: AppConstantsColors.blackColor,
                  size: 40,
                ),
                onPressed: () {
                  try {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MedicalFRHome()));
                  } catch (e) {
                    print("Navigation error: $e");
                  }
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
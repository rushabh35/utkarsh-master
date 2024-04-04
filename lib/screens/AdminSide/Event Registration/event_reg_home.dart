import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/AdminSide/Event%20Registration/VolunteersList.dart';
import 'package:utkarsh/screens/AdminSide/Event%20Registration/event_add.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';

class EventRegHome extends StatefulWidget {
  const EventRegHome({super.key});

  @override
  State<EventRegHome> createState() => _EventRegHomeState();
}

class _EventRegHomeState extends State<EventRegHome> {
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text(
              'Event Management',
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: AppConstantsColors.blackColor,
              ),
            ), 
          ],
        ),
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
                text: "Event Creation", 
                buttonColor: AppConstantsColors.brightWhiteColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EventAdd()));
                }
              ),
              CustomButton(
                height: sizeHeight * 0.06,
                width: sizeWidth * 0.7,
                text: "Volunteers List For Events", 
                buttonColor: AppConstantsColors.brightWhiteColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VolunteersList()));
                }
              ),
              
            ],
          ),
        ),
      )

    );
  }
}

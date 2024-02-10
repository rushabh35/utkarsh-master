import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerRegistrationHome extends StatefulWidget {
  const VolunteerRegistrationHome({super.key});

  @override
  State<VolunteerRegistrationHome> createState() =>
      _VolunteerRegistrationHomeState();
}

class _VolunteerRegistrationHomeState extends State<VolunteerRegistrationHome> {
  @override
    Map<String, bool> registrationStatus = {};
    @override
      void initState() {
        super.initState();
        fetchRegistrationStatus();
      }

      Future<void> fetchRegistrationStatus() async {
        String currentUserUID = FirebaseAuth.instance.currentUser!.uid;

        // Fetch the registration status for each event
        QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
            .collection('UpcomingEvents')
            .get();
 
        eventsSnapshot.docs.forEach((event) {
          String eventID = event.id;
          List<dynamic>? registeredUsers = event['registeredUsers'];

          if (registeredUsers != null && registeredUsers.contains(currentUserUID)) {
            setState(() {
              registrationStatus[eventID] = true;
            });
          } else {
            setState(() {
              registrationStatus[eventID] = false;
            });
          }
        });
      }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizeHeight = size.height;
    var sizeWidth = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text(
              'Volunteer Registration Home',
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: AppConstantsColors.blackColor,
              ),
            ), // const Text('Need Help?',style:TextStyle(color:Colors.black))
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('UpcomingEvents').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var events = snapshot.data?.docs;
          return ListView.builder(
            itemCount: events?.length,
            itemBuilder: (context, i) {
              var event = events?[i];
              String eventID = event?.id ?? ''; // Get the event ID
              bool isUserRegistered = registrationStatus[eventID] ?? false;

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
                        "Title: ${snapshot.data!.docs[i]['title']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Location: ${snapshot.data!.docs[i]['location']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "PhonNumber: ${snapshot.data!.docs[i]['mobile']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Event date: ${snapshot.data!.docs[i]['eventDate']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Time: ${snapshot.data!.docs[i]['eventTime']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Skills: ${snapshot.data!.docs[i]['skills']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Description: ${snapshot.data!.docs[i]['description']}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            width: sizeWidth * 0.5,
                            height: 30,
                            buttonColor: AppConstantsColors.accentColor,
                            
                            text: isUserRegistered ? 'Already Registered' : 'Register for Event',
                            onPressed: () async {
                              String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
                              String eventID = event!.id;  
                              try {
                                // DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
                                //         .collection('UpcomingEvents')
                                //         .doc(eventID)
                                //         .get();

                                // List<dynamic>? registeredUsers =
                                //     eventSnapshot['registeredUsers'];

                                // // Check if the current user is already registered
                                // if (registeredUsers != null &&
                                //     registeredUsers.contains(currentUserUID)) {
                                //   setState(() {
                                //     registrationStatus[eventID] = true;
                                //   });
                                // } else {
                                  // Update the Users collection
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(currentUserUID)
                                      .update({
                                    "registeredEvents":
                                        FieldValue.arrayUnion([eventID]),
                                  });

                                  // Update the UpcomingEvents collection
                                  await FirebaseFirestore.instance
                                      .collection('UpcomingEvents')
                                      .doc(eventID)
                                      .update({
                                    "registeredUsers":
                                        FieldValue.arrayUnion([currentUserUID]),
                                  });

                                  setState(() {
                                    registrationStatus[eventID] = true;
                                  });
                                // }

                                // ignore: use_build_context_synchronously
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Success'),
                                      content:
                                          const Text("Successfully saved data"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppConstantsColors.accentColor,
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
                              } catch (error) {
                                // Handle errors, if any
                                String errorMessage =
                                    "Error updating Users collection: $error";
                                // ignore: use_build_context_synchronously
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: Text(errorMessage),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppConstantsColors.accentColor,
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
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

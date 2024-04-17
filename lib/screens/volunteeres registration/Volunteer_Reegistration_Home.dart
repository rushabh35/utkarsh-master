import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';

class VolunteerRegistrationHome extends StatefulWidget {
  const VolunteerRegistrationHome({super.key});

  @override
  State<VolunteerRegistrationHome> createState() => _VolunteerRegistrationHomeState();
}

class _VolunteerRegistrationHomeState extends State<VolunteerRegistrationHome> {
  Map<String, bool> registrationStatus = {};

  @override
  void initState() {
    super.initState();
    fetchRegistrationStatus();
  }

  Future<void> fetchRegistrationStatus() async {
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the registration status for each event
    QuerySnapshot eventsSnapshot =
        await FirebaseFirestore.instance.collection('UpcomingEvents').get();

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Volunteer Registration', style: TextStyle(color: AppConstantsColors.blackColor)),
        
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('UpcomingEvents')
            .where('eventTimestamp', isGreaterThan: Timestamp.fromDate(DateTime.now()))
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot>? events = snapshot.data?.docs.where((document) {
            Timestamp eventTimestamp = document['eventTimestamp'];
            return eventTimestamp.toDate().isAfter(DateTime.now());
          }).toList();

          if (events == null || events.isEmpty) {
            return const Center(child: Text('No upcoming events', style: TextStyle(color: AppConstantsColors.blackColor)));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) {
              DocumentSnapshot event = events[i];
              String eventID = event.id;
              bool isUserRegistered = registrationStatus[eventID] ?? false;

              return Card(
                margin: const EdgeInsets.all(12),
                color: AppConstantsColors.blackColor,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventDetailRow(icon: Icons.event, detail: event['title'], label: 'Title'),
                      EventDetailRow(icon: Icons.location_on, detail: event['location'], label: 'Location'),
                      EventDetailRow(icon: Icons.phone, detail: event['mobile'], label: 'PhoneNumber'),
                      EventDetailRow(icon: Icons.calendar_today, detail: formatDate(event['eventTimestamp']), label: 'Event Date'),
                      EventDetailRow(icon: Icons.star, detail: event['skills'], label: 'Skills'),
                      EventDetailRow(icon: Icons.description, detail: event['description'], label: 'Description'),
                      EventDetailRow(icon: Icons.person, detail: event['raisedBy'], label: 'Raised By'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          isUserRegistered
                              ? const Text(
                                  'Already Registered',
                                  style: TextStyle(
                                    color: AppConstantsColors.accentColor,
                                    fontSize: 16,
                                  ),
                                )
                              : CustomButton(
                                  width: sizeWidth * 0.5,
                                  height: 30,
                                  buttonColor: AppConstantsColors.accentColor,
                                  text: 'Register for Event',
                                  onPressed: () async {
                                    String currentUserUID =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    String eventID = event!.id;
                                    try {  
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
                                            FieldValue.arrayUnion(
                                                [currentUserUID]),
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
                                            content: const Text(
                                                "Successfully saved data"),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppConstantsColors
                                                          .accentColor,
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
                                                      AppConstantsColors
                                                          .accentColor,
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

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}

class EventDetailRow extends StatelessWidget {
  final IconData icon;
  final String detail;
  final String label;

  const EventDetailRow({
    Key? key,
    required this.icon,
    required this.detail,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $detail',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationButton extends StatelessWidget {
  final bool isUserRegistered;
  final String eventID;
  final String currentUserUID;

  const RegistrationButton({
    Key? key,
    required this.isUserRegistered,
    required this.eventID,
    required this.currentUserUID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isUserRegistered
        ? const Text(
            'Already Registered',
            style: TextStyle(color: Colors.green, fontSize: 16),
          )
        : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: AppConstantsColors.accentColor,
              onPrimary: Colors.white,
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Register for Event'),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('UpcomingEvents').doc(eventID).update({
                'registeredUsers': FieldValue.arrayUnion([currentUserUID]),
              });
              await FirebaseFirestore.instance.collection('Users').doc(currentUserUID).update({
                'registeredEvents': FieldValue.arrayUnion([eventID]),
              });
            },
          );
  }
}

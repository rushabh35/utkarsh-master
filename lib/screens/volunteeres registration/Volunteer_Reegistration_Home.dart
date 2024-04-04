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
    QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance.collection('UpcomingEvents').get();

    for (var event in eventsSnapshot.docs) {
      String eventID = event.id;
      List<dynamic>? registeredUsers = event['registeredUsers'];
      setState(() {
        registrationStatus[eventID] = registeredUsers != null && registeredUsers.contains(currentUserUID);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Volunteer Registration', style: TextStyle(color: AppConstantsColors.blackColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppConstantsColors.accentColor),
            onPressed: () {
              // Action for more information or help
            },
          ),
        ],
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
                      RegistrationButton(isUserRegistered: isUserRegistered, eventID: eventID, currentUserUID: FirebaseAuth.instance.currentUser!.uid),
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
              // Registration logic here
            },
          );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class VolunteersList extends StatefulWidget {
  const VolunteersList({super.key});

  @override
  State<VolunteersList> createState() => _VolunteersListState();
}

class _VolunteersListState extends State<VolunteersList> {
  Future<List<Event>> fetchEvents() async {
    List<Event> eventsList = [];
    QuerySnapshot eventsSnapshot =
        await FirebaseFirestore.instance.collection('UpcomingEvents').get();

    for (var eventDoc in eventsSnapshot.docs) {
      String title = eventDoc['title'];
      List<dynamic> registeredUsersIds = eventDoc['registeredUsers'] ?? [];
      List<Map<String, String>> registeredUserInfo = [];

      if (registeredUsersIds.isNotEmpty) {
        for (String userId in registeredUsersIds) {
          try {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .get();
            String userName =
                userDoc['name']; // Assuming the 'name' field exists.
            String userNumber =
                userDoc['number']; // Assuming the 'number' field exists.
            if (userName != null && userNumber != null) {
              registeredUserInfo.add({'name': userName, 'number': userNumber});
            }
          } catch (e) {
            print("Error fetching user data: $e");
          }
        }
      }

      eventsList
          .add(Event(title: title, registeredUserInfo: registeredUserInfo));
    }

    return eventsList;
  }

  void _makePhoneCall(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: const Text('Volunteers List',
            style: TextStyle(color: AppConstantsColors.blackColor)),
      ),
      body: FutureBuilder<List<Event>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Event event = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event,
                                color: AppConstantsColors.accentColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstantsColors.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Registered Volunteers:',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Column(
                          children: event.registeredUserInfo.map((userInfo) => Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.person, color: AppConstantsColors.accentColor),
                                title: Text(userInfo['name'] ?? '', style: const TextStyle(color: AppConstantsColors.blackColor)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.phone, color: AppConstantsColors.accentColor),
                                  onPressed: () => _makePhoneCall('tel:${userInfo['number']}'),
                                ),
                              ),
                              const Divider(),
                            ],
                          )).toList(),
                        ),                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No Upcoming Events'));
          }
        },
      ),
    );
  }
}

class Event {
  final String title;
  final List<Map<String, String>> registeredUserInfo;

  Event({required this.title, this.registeredUserInfo = const []});
}

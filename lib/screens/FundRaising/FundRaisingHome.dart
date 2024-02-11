import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/screens/AdminSide/FundRaisings/EducationFRAdminDescriptive.dart';
import 'package:utkarsh/screens/FundRaising/Education/Education_FR_description.dart';
import 'package:utkarsh/screens/FundRaising/FundRaising_create.dart';

class FundRaisingHome extends StatefulWidget {
  const FundRaisingHome({super.key});

  @override
  State<FundRaisingHome> createState() => _FundRaisingHomeState();
}

class _FundRaisingHomeState extends State<FundRaisingHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Raising'),
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('EducationFR').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if(snapshot.data!.docs[index]['verified'] == 'Approved') {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EducationFRDescriptive(
                            documentSnapshot: snapshot.data!.docs[index],
                          )));
                    },
                    child: Card(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                snapshot.data!.docs[index]['images']
                                    [0], // Fetch the first image URL
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.2,
                                // width: double.infinity,
                                height: MediaQuery.of(context).size.height *
                                    0.1, // Adjust the height as needed
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data!.docs[index]
                                      ['title'], // Provide the title from Firebase
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FundRaisingCreate()));
        },
        child: const Icon(Icons.add),
        backgroundColor: AppConstantsColors.accentColor,
      ),
    );
  }
}

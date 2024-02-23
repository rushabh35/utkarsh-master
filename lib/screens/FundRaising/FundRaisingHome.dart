import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/AdminSide/FundRaisings/EducationFRAdminDescriptive.dart';
import 'package:utkarsh/screens/FundRaising/Education/Education_FR_description.dart';
import 'package:utkarsh/screens/FundRaising/FundRaising_create.dart';

class FundRaisingHome extends StatefulWidget {
  const FundRaisingHome({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          // Expanded(
          //   child: 
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('EducationFR')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap:  true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      final verifiedStatus = document['verified'] as String?;
                      if (verifiedStatus == 'Approved') {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EducationFRDescriptive(
                                documentSnapshot: snapshot.data!.docs[index],
                              ),
                            ));
                          },
                          child: Card(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      document['images']
                                          [0], // Fetch the first image URL
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        document[
                                            'title'], // Provide the title from Firebase
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
                      } else {
                        // Return an empty container for rejected or unverified documents
                        return Container();
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
          // ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('MedicalFR').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap:  true,
                     physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      final verifiedStatus = document['verified'] as String?;
                      if (verifiedStatus == 'Approved') {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EducationFRDescriptive(
                                documentSnapshot: snapshot.data!.docs[index],
                              ),
                            ));
                          },
                          child: Card(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      document['images']
                                          [0], // Fetch the first image URL
                                      fit: BoxFit.cover,
                                      width:
                                          MediaQuery.of(context).size.width * 0.2,
                                      height: MediaQuery.of(context).size.height *
                                          0.1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        document[
                                            'title'], // Provide the title from Firebase
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
                      } else {
                        // Return an empty container for rejected or unverified documents
                        return Container();
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const FundRaisingCreate(),
          ));
        },
        child: const Icon(Icons.add),
        backgroundColor: AppConstantsColors.accentColor,
      ),
    );
  }
}

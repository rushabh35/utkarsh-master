import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/screens/AdminSide/FundRaisings/EducationFRAdminDescriptive.dart';

class EducationFRAdmin extends StatefulWidget {
  const EducationFRAdmin({super.key});

  @override
  State<EducationFRAdmin> createState() => _EducationFRAdminState();
}

class _EducationFRAdminState extends State<EducationFRAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Education Fund Raisings'),
          backgroundColor: AppConstantsColors.accentColor,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('EducationFR')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(20),
                      color: snapshot.data!.docs[index]['verified'] ==
                              'Approved'
                          ? AppConstantsColors.appGreenColor
                          : snapshot.data!.docs[index]['verified'] == 'Rejected'
                              ? AppConstantsColors.appRedColor
                              : AppConstantsColors.appYellowColor,
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EducationFRAdminDescriptive(
                                    documentSnapshot : snapshot.data!.docs[index],
                                  )));
                        },
                        
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title: ${snapshot.data!.docs[index]['title']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Author: ${snapshot.data!.docs[index]['raisedBy']}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

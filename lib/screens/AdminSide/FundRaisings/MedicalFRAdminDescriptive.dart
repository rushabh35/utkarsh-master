import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';

class MedicalFRAdminDescriptive extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const MedicalFRAdminDescriptive({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  _MedicalFRAdminDescriptiveState createState() =>
      _MedicalFRAdminDescriptiveState();
}

class _MedicalFRAdminDescriptiveState extends State<MedicalFRAdminDescriptive> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> imageUrls = widget.documentSnapshot['images'] +
        widget.documentSnapshot['ITCertificate'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentSnapshot['title']),
        elevation: 0,
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body: Container(
        color: AppConstantsColors.accentColor,
        child: Container(
          decoration: const BoxDecoration(
            color: AppConstantsColors.brightWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageUrls.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < imageUrls.length; i++)
                    _buildDotIndicator(i == _currentPage),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         _pageController.previousPage(
              //           duration: Duration(milliseconds: 300),
              //           curve: Curves.ease,
              //         );
              //       },
              //       icon: Icon(Icons.arrow_back),
              //     ),
              //     IconButton(
              //       onPressed: () {
              //         _pageController.nextPage(
              //           duration: Duration(milliseconds: 300),
              //           curve: Curves.ease,
              //         );
              //       },
              //       icon: Icon(Icons.arrow_forward),
              //     ),
              //   ],
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Name: ${widget.documentSnapshot['name']}',
                  style: TextStyle(
                    color: AppConstantsColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Age: ${widget.documentSnapshot['age']}',
                  style: TextStyle(
                    color: AppConstantsColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Relation: ${widget.documentSnapshot['relation']}',
                  style: TextStyle(
                    color: AppConstantsColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Mobile Number: ${widget.documentSnapshot['mobile']}',
                  style: TextStyle(
                    color: AppConstantsColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Description: ${widget.documentSnapshot['description']}',
                  style: TextStyle(
                    color: AppConstantsColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Funds Required: ${widget.documentSnapshot['fundsRequired']}',
                  style: TextStyle(
                    color: AppConstantsColors.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('MedicalFR')
                          .doc(widget.documentSnapshot.id)
                          .update({'verified': 'Rejected'});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: AppConstantsColors.redColor,
                            content: Text('FundRaising Rejected')),
                      );
                    },
                    child: Icon(Icons.delete_rounded),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('MedicalFR')
                          .doc(widget.documentSnapshot.id)
                          .update({'verified': 'Approved'});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: AppConstantsColors.greenColor,
                            content: Text('FundRaising Accepted')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: AppConstantsColors.greenColor),
                    child: Icon(Icons.check_circle),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

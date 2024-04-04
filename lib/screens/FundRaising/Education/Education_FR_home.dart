import 'dart:io';

import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/FundRaising/FundRaisingHome.dart';
import 'package:utkarsh/screens/FundRaising/FundRaising_create.dart';
import 'package:utkarsh/screens/Home/Home.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EducationFRHome extends StatefulWidget {
  const EducationFRHome({super.key});

  @override
  State<EducationFRHome> createState() => _EducationFRHomeState();
}

class _EducationFRHomeState extends State<EducationFRHome> {
  String? _selectedRelation;

  final TextEditingController _relativeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _mobilenoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fundsRequiredController =
      TextEditingController();

  List<File> selectedImages = [];
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  Future getImages() async {
    List<XFile>? pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      print("Number of picked files: ${pickedFiles.length}");
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing is selected')),
      );
    }
  }

  Future<void> _uploadImages(String documentId) async {
    try {
      for (File imageFile in selectedImages) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("EducationFRImages")
            .child("$documentId/$uniqueFileName.jpg");

        UploadTask uploadTask = storageReference.putFile(imageFile);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Update Firestore document with the image URL
          await FirebaseFirestore.instance
              .collection('EducationFR')
              .doc(documentId)
              .update({
            'images': FieldValue.arrayUnion([imageUrl]),
          });
        });
        // });
      }
    } catch (error) {
      print("Error uploading image: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Call this method here to close keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Set to true
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FundRaisingCreate()),
              );
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Text(
                'Education FundRaising',
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  color: AppConstantsColors.blackColor,
                ),
              ), // const Text('Need Help?',style:TextStyle(color:Colors.black))
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 15, right: 15, bottom: 15),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _titleController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                hintText: "Title of the cause",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Title';
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _name = value!;
                              // },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                hintText: "Full Name of the person in need",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _name = value!;
                              // },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _mobilenoController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                hintText:
                                    'Contact Number of the person in need',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.mobile_friendly,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter  Contact Number";
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _number = value!;
                              // },
                            ),
                          ),
                          const SizedBox(height: 20),
                         Container(
                            height: 60, // Adjusted height for better dropdown visibility
                            width: MediaQuery.of(context).size.width / 1.12,
                            padding: EdgeInsets.symmetric(horizontal: 15), // Padding for aesthetic adjustment
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: const Text('Select Relation'),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              value: _selectedRelation, // This is now nullable
                              icon: const Icon(Icons.arrow_downward, color: Colors.grey),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRelation = newValue;
                                });
                              },
                              items: <String>[
                                'Mother',
                                'Father',
                                'Sibling',
                                'Child',
                                'Spouse',
                                'Yourself',
                                'Friend',
                                'Others'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              validator: (value) => value == null ? 'Please select a relation' : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _ageController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                hintText: 'Age of the person in need',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Age";
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _number = value!;
                              // },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 350,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _descriptionController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                hintText: "Description of the cause",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter description';
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _name = value!;
                              // },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _fundsRequiredController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                hintText: "Funds Required",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.monetization_on_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter funds required';
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _name = value!;
                              // },
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            buttonColor: AppConstantsColors.appYellowColor,
                            width: MediaQuery.of(context).size.width / 1.12,
                            height: 50,
                            text: "Upload Images",
                            onPressed: () async {
                              await getImages();
                            },
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppConstantsColors.accentColor,
                                ),
                                onPressed: () async {
                                  // showModalBottomSheet(
                                  //   isScrollControlled: true,
                                  //     context: context,
                                  //     builder: (_) {
                                  //       return EducationFRHome();
                                  //     });
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                    _formKey.currentState!.save();

                                    Map<String, dynamic> data = {
                                      "title": _titleController.text,
                                      "name": _nameController.text,
                                      "mobile": _mobilenoController.text,
                                      "relation": _selectedRelation,
                                      "age": _ageController.text,
                                      "description":
                                          _descriptionController.text,
                                      "fundsRequired":
                                          int.parse(_fundsRequiredController.text),
                                      "fundsRaised": 0,
                                      "raisedBy": FirebaseAuth
                                          .instance.currentUser!.email,
                                      "verified": 'Pending',
                                    };
                                    String currentUserUID =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    try {
                                      // DocumentReference docRef =
                                      //     await
                                      FirebaseFirestore.instance
                                          .collection('EducationFR')
                                          .add(data)
                                          .then((DocumentReference<
                                                  Map<String, dynamic>>
                                              docRef) async {
                                        String educationFRID = docRef.id;

                                        // Update the Users collection with the pickupInfo data and ID
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(currentUserUID)
                                            .update({
                                          "EducationFR": FieldValue.arrayUnion(
                                              [educationFRID]),
                                        });
                                        _uploadImages(docRef.id);
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppConstantsColors
                                                            .accentColor,
                                                  ),
                                                  onPressed: () {
                                                    // Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const HomePage()),
                                                    );

                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      });
                                      // ignore: use_build_context_synchronously
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const FundRaisingHome()),
                                      // );
                                    } catch (e) {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(e.toString()),
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
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                )),
                          ),
                        ],
                      ),
                    )),
              )),
        ),
      ),
    );
  }
}

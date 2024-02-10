import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/screens/Forums/Forum_home.dart';

class Content_add extends StatefulWidget {
  const Content_add({super.key});

  @override
  State<Content_add> createState() => _Content_addState();
}

class _Content_addState extends State<Content_add> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Call this method here to close keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstantsColors.accentColor,
          title: const Text("Add Content"),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 1.12,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      cursorColor: Colors.black,
                      keyboardType:
                          TextInputType.multiline, // Changed to multiline
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: "Title",
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
                          return 'Please enter your title';
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
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width / 1.12,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _contentController,
                      cursorColor: Colors.black,
                      keyboardType:
                          TextInputType.multiline, // Changed to multiline
                      maxLines: null, // Allow text to wrap to next line
                      // keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: "Content",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your content';
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   _name = value!;
                      // },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstantsColors.accentColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Map<String, dynamic> data = {
                            "title": _titleController.text,
                            "content": _contentController.text,
                            "emailId": FirebaseAuth.instance.currentUser!.email,
                          };
                          // String currentUserUID =
                          //     FirebaseAuth.instance.currentUser!.uid;
                          try {
                            FirebaseFirestore.instance
                                .collection('forums')
                                .add(data)
                                .then((DocumentReference<Map<String, dynamic>>
                                    docRef) async {
                              _titleController.clear();
                              _contentController.clear();
                              // String pickupInfoID = docRef.id;

                              // Update the Users collection with the pickupInfo data and ID
                              // await FirebaseFirestore.instance
                              //     .collection('Users')
                              //     .doc(currentUserUID)
                              //     .update({
                              //   "pickupInfo":
                              //       FieldValue.arrayUnion([pickupInfoID]),
                              // });
                              // Navigate to the SuccessPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  ForumScreen(),
                                ),
                              );

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
                            });
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
                          // ignore: use_build_context_synchronously
                        }
                      },
                      child: const Text(
                        'Submit',
                      ),
                    ),
                  ),
                  //Row
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

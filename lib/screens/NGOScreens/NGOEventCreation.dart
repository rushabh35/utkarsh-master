// ignore_for_file: use_build_context_synchronously, duplicate_ignore, depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
class NGOEventCreation extends StatefulWidget {
  const NGOEventCreation({Key? key}) : super(key: key);

  @override
  State<NGOEventCreation> createState() => _NGOEventCreationState();
}

class _NGOEventCreationState extends State<NGOEventCreation> {
  final TextEditingController _dateinputController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobilenoController = TextEditingController();
  final TextEditingController _timeinputController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateinputController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        _timeinputController.text = selectedTime
            .format(context); // Update the text field with the selected time
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Text(
                'Event Registration',
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  color: AppConstantsColors.blackColor,
                ),
              ), // const Text('Need Help?',style:TextStyle(color:Colors.black))
            ],
          ),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: "Title of the Event",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: 'Contact Number',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.mobile_friendly,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter NGO's Contact Number";
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
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.12,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _locationController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: 'Location',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.add_location,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full Address";
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   _location = value!;
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
                        cursorColor: Colors.black,
                        controller: _dateinputController,
                        keyboardType: TextInputType.none,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Event Date',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () async {
                          _selectDate(context);
                        },
                        // onSaved: (value) {
                        //   _date = value! ;
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
                        readOnly: true,
                        controller: _timeinputController,
                        cursorColor: Colors.black,
                        
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Event Time',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.timer,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () async {
                          _selectTime(context);
                        },
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
                      controller: _skillsController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: 'Skills required for the Event',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.work,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter skills";
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   _quantity = value!;
                      // },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 1.12,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocus,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: 'Description of the event',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Description";
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   _quantity = value!;
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
                          final DateTime combinedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          final Timestamp pickupTimestamp =
                                Timestamp.fromDate(combinedDateTime);
                          Map<String, dynamic> data = {
                            "title": _titleController.text,
                            "mobile": _mobilenoController.text,
                            "location": _locationController.text,
                            "eventTimestamp": pickupTimestamp,
                            "skills": _skillsController.text,
                            "description": _descriptionController.text,
                            "raisedBy" : FirebaseAuth.instance.currentUser!.email,
                          };
                          try {
                            await FirebaseFirestore.instance
                                .collection('UpcomingEvents')
                                .add(data);
                             _titleController.clear();
                            _mobilenoController.clear();
                            _locationController.clear();
                            _dateinputController.clear();
                            _timeinputController.clear();
                            _skillsController.clear();
                            _descriptionController.clear();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('Data saved successfully!'),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppConstantsColors.accentColor,
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

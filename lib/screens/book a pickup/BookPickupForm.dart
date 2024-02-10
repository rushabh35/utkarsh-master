// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/book%20a%20pickup/success.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookPickupForm extends StatefulWidget {
  const BookPickupForm({Key? key}) : super(key: key);

  @override
  State<BookPickupForm> createState() => _BookPickupFormState();
}

class _BookPickupFormState extends State<BookPickupForm> {
  final TextEditingController _dateinputController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _mobilenoController = TextEditingController();
  final TextEditingController _timeinputController = TextEditingController();

  // late String _name;
  // late String _quantity;
  // late String _location;
  // late String _number;

  // late String _date;
  // late String _time;
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    _timeinputController.text = "";
    fetchUserData();
  }

  void fetchUserData() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch data from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        // Extract data from the snapshot
        Map<String, dynamic> userData = snapshot.data()!;
        String name = userData['name'];
        String phoneNumber = userData['number'];

        // Set the fetched data in the text controllers
        _nameController.text = name;
        _mobilenoController.text = phoneNumber;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text(
              'User Information',
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
                    enabled : false,
                    controller: _nameController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: "Full Name",
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
                        return 'Please enter your name';
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
                    enabled : false,

                    controller: _mobilenoController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Contact Number',
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
                      hintText: 'Pickup Date',
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
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime
                              .now(), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(
                            pickedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          _dateinputController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      }
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
                    controller: _timeinputController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Pickup Time',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.timer,
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
                    //   _time = value!;
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
                    controller: _quantityController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      hintText: 'Weights in KG',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter quantity";
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
                          Map<String, dynamic> data = {
                                                "name": _nameController.text,
                                                "mobile": _mobilenoController.text,
                                                "location": _locationController.text,
                                                "pickupDate": _dateinputController.text,
                                                "pickupTime": _timeinputController.text,
                                                "quantity": _quantityController.text,
                                                "order_open" : true,
                                                "userId" : FirebaseAuth.instance.currentUser!.uid,
                          };
                          String currentUserUID = FirebaseAuth.instance.currentUser!.uid;
                          try {
                                FirebaseFirestore.instance
                                .collection('pickupInfo')
                                .add(data)
                                .then((DocumentReference<Map<String, dynamic>> docRef) async {
                              String pickupInfoID = docRef.id;

                              // Update the Users collection with the pickupInfo data and ID
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(currentUserUID)
                                  .update({
                                "pickupInfo": FieldValue.arrayUnion([pickupInfoID]),
                              });
                              // Navigate to the SuccessPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SuccessPage(),
                                ),
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text("Successfully saved data"),
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
 
                          }
                          // ignore: use_build_context_synchronously
                                                 }
                      },
                    child:  const Text('Submit',),
                  ),
                ),
                //Row
              ],
            ),
          ),
        ),
      ),
    );
  }
}

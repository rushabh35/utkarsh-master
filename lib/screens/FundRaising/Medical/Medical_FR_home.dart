import 'dart:io';

import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/FundRaising/FundRaising_create.dart';
import 'package:utkarsh/screens/Home/Home.dart';
import 'package:utkarsh/utils/ui/CustomButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MedicalFRHome extends StatefulWidget {
  const MedicalFRHome({super.key});

  @override
  State<MedicalFRHome> createState() => _MedicalFRHomeState();
}

class _MedicalFRHomeState extends State<MedicalFRHome> {
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
  List<File> selectedIT = [];
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

  Future<void> getITCertificate() async {
    List<XFile>? pickedIT = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedIT != null && pickedIT.isNotEmpty) {
      // New list to keep track of images that are verified as income certificates
      List<File> verifiedImages = [];

      for (var pickedIT in pickedIT) {
        File imageFile = File(pickedIT.path);
        // Call the image analysis function
        try {
          Map<String, dynamic> analysisResult = await analyzeImageWithVisionApi(
              imageFile, dotenv.env['cloud_vision_api']!);
          // Check the analysis result to determine if the image is an income certificate
          bool isIncomeCertificate = checkIfIncomeCertificate(analysisResult);
          if (isIncomeCertificate) {
            verifiedImages.add(imageFile);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Income certificate detected')),
            );
          } else {
            // Handle the case where the image is not an income certificate
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('The selected image is not an income certificate')),
            );
            // You could show a dialog or a snackbar message here
          }
        } catch (e) {
          // Handle the error, maybe by showing a snackbar with the error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error analyzing the selected image')),
          );
          print(e.toString());
        }
      }

      if (verifiedImages.isNotEmpty) {
        setState(() {
          selectedIT = verifiedImages;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('No income certificates detected in selected images')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images were selected')),
      );
    }
  }

  bool checkIfIncomeCertificate(Map<String, dynamic> analysisResult) {
    // Check for text content in the document
    print(analysisResult);
    bool hasRequiredText = false;
    String textResult =
        analysisResult['responses'][0]['fullTextAnnotation']['text'];

    // List of possible keywords in Hindi and English
    List<String> keywords = [
      "Income Certificate", // English
      "आय", // Hindi
      "ಆದಾಯ", // Kannada
      "வருமான", // Tamil
      "ఆదాయ", // Telugu
      "আয়", // Bengali
      "આવક", // Gujarati
      "ਆਮਦਨ", // Punjabi
      "വരുമാന", // Malayalam
      "उत्पन्नाचा दाखला",
      "उ त्प न्न" // Marathi
          "ଆୟ", // Odia
      "आय",
    ];

    // Normalize text to account for minor differences
    textResult = textResult.toLowerCase();

    // Check for each keyword in the extracted text
    for (String keyword in keywords) {
      if (textResult.contains(keyword.toLowerCase())) {
        hasRequiredText = true;
        break; // No need to check further keywords once we find a match
      }
    }

    // The document is an income certificate if it has the required text and a barcode
    return hasRequiredText;
  }

Future<void> _uploadImages(String documentId) async {
    try {
      for (File imageFile in selectedImages) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("MedicalFRImages")
            .child("$documentId/$uniqueFileName.jpg");

        UploadTask uploadTask = storageReference.putFile(imageFile);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Update Firestore document with the image URL
          await FirebaseFirestore.instance
              .collection('MedicalFR')
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

  Future<void> _uploadIT(String documentId) async {
    try {
      for (File imageFile in selectedIT) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("MedicalFRImages")
            .child("$documentId/$uniqueFileName.jpg");

        UploadTask uploadTask = storageReference.putFile(imageFile);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Update Firestore document with the image URL
          await FirebaseFirestore.instance
              .collection('MedicalFR')
              .doc(documentId)
              .update({
            'ITCertificate': FieldValue.arrayUnion([imageUrl]),
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
                'Medical FundRaising',
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
                            text: "Upload IT certificate",
                            onPressed: () async {
                              await getITCertificate();
                            },
                          ),
                          const SizedBox(height: 20),

                          CustomButton(
                            buttonColor: AppConstantsColors.appYellowColor,
                            width: MediaQuery.of(context).size.width / 1.12,
                            height: 50,
                            text: "Upload Images Of Needy",
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
                                      "fundsRequired": int.parse(
                                          _fundsRequiredController.text),
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
                                          .collection('MedicalFR')
                                          .add(data)
                                          .then((DocumentReference<
                                                  Map<String, dynamic>>
                                              docRef) async {
                                        String medicalFRID = docRef.id;

                                        // Update the Users collection with the pickupInfo data and ID
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(currentUserUID)
                                            .update({
                                          "MedicalFR": FieldValue.arrayUnion(
                                              [medicalFRID]),
                                        });
                                        _uploadIT(docRef.id);
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
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomePage()),
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

Future<Map<String, dynamic>> analyzeImageWithVisionApi(
    File imageFile, String apiKey) async {
  // Convert image to base64
  String base64Image = base64Encode(await imageFile.readAsBytes());

  // Create the request payload with added features as needed
  var requestPayload = json.encode({
    "requests": [
      {
        "image": {"content": base64Image},
        "features": [
          {"type": "DOCUMENT_TEXT_DETECTION"},
          // Add this if you're checking for OBJECT_LOCALIZATION in responses
          {"type": "OBJECT_LOCALIZATION"}
        ]
      }
    ]
  });

  // Send the image to the Google Cloud Vision API
  http.Response response = await http.post(
    Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey'),
    headers: {
      "Content-Type": "application/json",
    },
    body: requestPayload,
  );

  // Check for errors
  if (response.statusCode != 200) {
    throw Exception(
        'Google Vision API request failed with status: ${response.statusCode}');
  }

  // Decode the JSON response
  return json.decode(response.body);
}

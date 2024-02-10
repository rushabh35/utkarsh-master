// import 'package:flutter/material.dart';
// import 'package:utkarsh/constants/app_constants_colors.dart';

// class EducationDesc extends StatefulWidget {
//   const EducationDesc({super.key});

//   @override
//   State<EducationDesc> createState() => _EducationDescState();
// }

// class _EducationDescState extends State<EducationDesc> {
//   final TextEditingController _fundsRequiredController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//         var size = MediaQuery.of(context).size;
//     var sizeHeight = size.height;
//     var sizeWidth = size.width;
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//          resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           iconTheme: const IconThemeData(
//             color: Colors.grey,
//           ),
//           backgroundColor: Colors.white,
//           title: const Row(
//             children: [
//               Text(
//                 'Education FundRaising',
//                 style: TextStyle(
//                   overflow: TextOverflow.clip,
//                   color: AppConstantsColors.blackColor,
//                 ),
//               ), // const Text('Need Help?',style:TextStyle(color:Colors.black))
//             ],
//           ),
//         ),
//         body: Form(
//           key: _formKey,
//           child:  SingleChildScrollView(
//             child: Padding( 
//               padding: const EdgeInsets.only(    
//                 top: 30.0, left: 15, right: 15, bottom: 15
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                      Container(
//                           height: 350,
//                           width: MediaQuery.of(context).size.width / 1.12,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: TextFormField(
//                             controller: _descriptionController,
//                             cursorColor: Colors.black,
//                             keyboardType: TextInputType.text,
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 15),
//                               hintText: "Description of the cause",
//                               hintStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                               prefixIcon: Icon(
//                                 Icons.description_outlined,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter description';
//                               }
//                               return null;
//                             },
//                             // onSaved: (value) {
//                             //   _name = value!;
//                             // },
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                     Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width / 1.12,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: TextFormField(
//                             controller: _fundsRequiredController,
//                             cursorColor: Colors.black,
//                             keyboardType: TextInputType.text,
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 15),
//                               hintText: "Funds Required",
//                               hintStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                               ),
//                               prefixIcon: Icon(
//                                 Icons.monetization_on_outlined,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter funds required';
//                               }
//                               return null;
//                             },
//                             // onSaved: (value) {
//                             //   _name = value!;
//                             // },
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppConstantsColors.accentColor,
//                               ),
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text('Processing Data')),
//                                   );
//                                   _formKey.currentState!.save();

//                                   // Map<String, dynamic> data = {
//                                     // "name": _nameController.text,
//                                     // "mobile": _mobilenoController.text,
//                                     // "relation": _relativeController.text,
//                                     // "age": _ageController.text,
//                                     // "raisedBy": FirebaseAuth
//                                     //     .instance.currentUser!.email,
//                                   // };

//                                   try {
//                                     DocumentReference docRef =
//                                         await FirebaseFirestore.instance
//                                             .collection('EducationFR')
//                                             .add(data);
//                                     // _uploadImages(docRef.id);
//                                     // ignore: use_build_context_synchronously
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           title: const Text('Success'),
//                                           content: const Text(
//                                               "Successfully saved data"),
//                                           actions: [
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     AppConstantsColors
//                                                         .accentColor,
//                                               ),
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: const Text('OK'),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );

//                                     // ignore: use_build_context_synchronously
//                       //               Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => const EducationDesc()),
//                       // );
//                                   } catch (e) {
//                                     // ignore: use_build_context_synchronously
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           title: const Text('Error'),
//                                           content: Text(e.toString()),
//                                           actions: [
//                                             ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     AppConstantsColors
//                                                         .accentColor,
//                                               ),
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: const Text('OK'),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   }
//                                 }
//                               },
//                               child: const Text(
//                                 'Submit',
//                               )),
//                         ),
  
//                   ],
//                 ),
//               ),            
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
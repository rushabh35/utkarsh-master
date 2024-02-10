import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/models/userModel.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).
        whenComplete(
          () => Get.snackbar(
          "Success",
          "User added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white),
        )
        // ignore: invalid_return_type_for_catch_error
        .catchError((e, stackTrace) => {
          Get.snackbar(
            "Error",
            "Something went wrong",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          ),
          print(e.toString()),
      });
  }
}

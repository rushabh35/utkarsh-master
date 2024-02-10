import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/services/sharedPrefServices.dart';

class NGOAuthServices {
  final FirebaseAuth _firebaseAuthNGO;

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('NGO');

  NGOAuthServices(this._firebaseAuthNGO);

  Stream<User?> get authStateChanged => _firebaseAuthNGO.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuthNGO.signOut();
    await clearPrefs();
  }

  //sign in with email and password
  Future signIn({required String email, required String password}) async {
    try {
      await _firebaseAuthNGO.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out
  Future<String> signUp({
    required String name,
    required String email,
    required String number,
    required String password,
  }) async {
    try {
      await _firebaseAuthNGO.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _firebaseAuthNGO.currentUser;
      String? uid = user?.uid;

      await _collectionReference.doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'number': number,
      });

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      // Log or handle the error as needed
      print("Error during sign up: ${e.message}");
      return e.message ?? "An error occurred during sign up";
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utkarsh/models/userModel.dart';

Future<void> clearPrefs() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString("user_key", "");
}

Future<void> setUserFromPrefs(UserModel user) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  Map data = user.toJson();
  String str = jsonEncode(data);
  _prefs.setString("user_key", str);
}

Future<UserModel> getUserFromPrefs() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  debugPrint("User from prefs: ${_prefs.getString("user_key")}");
  Map<String, dynamic> data = jsonDecode(_prefs.getString("user_key")!);
  UserModel user = UserModel.fromMap(data);
  return user;
}
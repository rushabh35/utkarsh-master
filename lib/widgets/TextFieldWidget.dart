import 'package:flutter/material.dart';

import '../constants/app_constants_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final InputDecoration decoration;
  final TextInputType keyboardType;

  TextFieldWidget({
    required this.controller,
    required this.hintText,
     this.errorText = "",
    this.obscureText = false,
    this.decoration = const InputDecoration(),
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppConstantsColors.transparent,
      child: TextField(
        cursorColor: Colors.green,
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          color: AppConstantsColors.blackColor
        ),
        decoration: InputDecoration(
          labelText: hintText,
          errorText: errorText,
          labelStyle: const TextStyle(
            color: AppConstantsColors.blackColor
            ,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppConstantsColors.blackColor,
          ),
          filled: true,
          fillColor: AppConstantsColors.transparent,
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppConstantsColors.blackColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppConstantsColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppConstantsColors.grey),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/app_constants_colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
   final InputDecoration decoration;

   const PasswordTextField({super.key,
    required this.controller,
     required this.hintText,
      this.errorText = "",
    this.decoration = const InputDecoration(),
  });


  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  void _changeObscure() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppConstantsColors.transparent,
      child: TextField(
        controller: widget.controller,
        obscureText: obscureText,
        style: const TextStyle(
            color: AppConstantsColors.blackColor
        ),
        decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            color: AppConstantsColors.blackColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off ,
              color: AppConstantsColors.blackColor,
            ), onPressed: _changeObscure,
          ),
          errorText:  widget.errorText,
          hintText: widget.hintText,
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

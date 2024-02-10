
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../constants/app_constants_colors.dart';

class DropDownWidget extends StatelessWidget {
   DropDownWidget({super.key,
  this.selectedValue,
  this.isValueSelected,
  this.dropdownList,
  this.isEditable,
  required this.onValueChanged,
  this.controller,
  this.focusNode,
  this.width,
  this.margin,
  this.boxShadow});

  String? selectedValue;
  bool? isValueSelected;
  final List? dropdownList;
  final bool? isEditable;
  Function(dynamic, dynamic) onValueChanged;
  final dynamic controller;
  final FocusNode? focusNode;
  double? width;
  EdgeInsetsGeometry? margin;
  List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.040,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        // boxShadow: boxShadow,
        color: AppConstantsColors.incomeTextfield,
        borderRadius: BorderRadius.circular(15),

      ),
      child: DropdownSearch<String>(
        autoValidateMode: AutovalidateMode.always,
        validator: (String? item) {
          if (isValueSelected == false) {
            return "Required field";
          } else {
            return null;
          }

        },
          enabled: isEditable ?? true,
          dropdownButtonProps: DropdownButtonProps(
          focusNode: focusNode,
          icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
      ),
        popupProps: PopupProps.menu(
         searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintStyle:  const TextStyle(
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppConstantsColors.blueColor),
                borderRadius: BorderRadius.circular(5),
              ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppConstantsColors.blueColor),
                  borderRadius: BorderRadius.circular(5),
                ),
            ),
        ),
          showSearchBox: true,
          showSelectedItems: true,
        ),
        items: dropdownList?.map<String>((item) => item.name).toList() ?? [],
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: AppConstantsColors.redColorDark),
            ),
            contentPadding: const EdgeInsets.fromLTRB(
              5,
              0,
              5,
              0,
            ),
            hintText: "Select",
            hintStyle:  const TextStyle(
            color: Colors.white, // Set the hint text color to white
          ),
          ),
        ),
        onChanged: (String? _selectedValue) {
          selectedValue = _selectedValue ?? '';
          onValueChanged(dropdownList, selectedValue);
        },
        selectedItem: selectedValue,
      ),
    );
  }
}

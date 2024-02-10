import 'package:flutter/material.dart';

class CurvedRectangleContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double width;
  final double height;

  CurvedRectangleContainer
      ({
    required this.child,
    required this.backgroundColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0), // Custom border radius
      ),
      child: child,
    );
  }
}

class CurvedRectangleDropdown extends StatelessWidget {
  final double width;
  final double height;

  final List<String> dropdownItems;
  final String selectedDropdownItem;
  final ValueChanged<String> onDropdownChanged;

  CurvedRectangleDropdown({
    required this.dropdownItems,
    required this.selectedDropdownItem,
    required this.onDropdownChanged, required this.width, required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedRectangleContainer(
      backgroundColor: Colors.deepPurple.withOpacity(0.7), // Set the background color
      width: width, // Specify the desired width
      height: height, // Specify the desired height
      child: DropdownButton<String>(
        value: selectedDropdownItem,
        onChanged: (newValue) {
          onDropdownChanged(newValue!);
        },
        items: dropdownItems.map<DropdownMenuItem<String>>(
              (String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          },
        ).toList(),
      ),
    );
  }
}

class CurvedRectangle extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const CurvedRectangle({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedRectangleContainer(
      backgroundColor: backgroundColor,
      width: 200.0, // Specify the desired width
      height: 40.0, // Specify the desired height
      child: TextField(
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(color: textColor), // Hint text color
          border: InputBorder.none, // Remove input border
        ),
        style: TextStyle(color: textColor), // Text color
      ),
    );
  }
}

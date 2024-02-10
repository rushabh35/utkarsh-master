import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  // final String iconPass;
  const IconButtonWidget({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      // width: 70, // Adjust the width as needed
      // height: 70,  // Adjust the height as needed
      decoration: BoxDecoration(
        color: Colors.blue, // Container background color
        borderRadius: BorderRadius.circular(8), // Container border radius
      ),
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.facebook, // Facebook icon provided by the flutter_facebook_login package
            color: Colors.white, // Icon color
          ),
           onPressed: () {  },
        ),
      ),
    );
  }
}

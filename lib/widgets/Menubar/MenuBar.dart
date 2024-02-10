// import 'package:flutter/material.dart';
// import 'package:sidebar_bigeagle/sidebar_bigeagle.dart';
//
// class Menubar extends StatefulWidget {
//   @override
//   _MenubarState createState() => _MenubarState();
// }
// class _MenubarState extends State<Menubar> {
//   int _selectedIndex = 0; // 0 is the first tab
//
//   List<Widget> pages =
//   []; // List of pages to be displayed in the body of the app.
//
//   @override
//   void initState() {
//     super.initState();
//     pages = [
//       // List of pages of example, this is the principal app content
//       Text("Book a pickup"),
//       Text("Volunteer Page"),
//       // Text("Search page"),
//       // Text("Online orders page"),
//       // Text("Codes page"),
//       // Text("Settings page"),
//       // Text("About page"),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Utkarsh'),
//         ),
//         body: Row(
//           children: [
//             // SideBar Big Eagle
//             SideBar(
//                 color: Colors.teal,
//                 appColor: Colors.white, // Optional, white is default
//                 accentColor: Colors.white, // Optional, white is default
//                 onHoverScale: 1.2, // Recomended value: 1.2, min: 0.5 max: 2
//                 borderRadius: 35.0, // Optional, 35.0 is default
//                 elevation: 6.0, // Optional, 0.0 is default
//                 // If you don't especify a logo, an empty container is used
//                 children: [
//                   // Button list
//                   SideBarButtonFlat(title: "Book a pickup", icon: Icons.local_shipping_outlined),
//                   SideBarButtonFlat(title: "Volunteer Page", icon: Icons.view_list),
//                   // SideBarButtonFlat(title: "Search", icon: Icons.search),
//                   // SideBarButtonFlat(
//                   //     title: "Online orders", icon: Icons.receipt),
//                   // SideBarButtonFlat(
//                   //     title: "Codes", icon: Icons.qr_code_scanner),
//                   // SideBarButtonFlat(title: "Settings", icon: Icons.settings),
//                   // SideBarButtonFlat(title: "About", icon: Icons.info),
//                 ],
//                 onChange: (value) {
//                   // This is the callback that is called when a button is pressed
//                   setState(() {
//                     _selectedIndex = value;
//                   });
//                 }),
//             // Main content
//             Expanded(
//               child: pages[_selectedIndex],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';

class AssignRoles extends StatefulWidget {
  @override
  _AssignRolesState createState() => _AssignRolesState();
}

class _AssignRolesState extends State<AssignRoles>
    with SingleTickerProviderStateMixin {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  Animation<double> _opacityAnimation = AlwaysStoppedAnimation(0);


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search and Assign/Remove Roles"),
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Search Users",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        searchQuery = _searchController.text;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .where('name', isGreaterThanOrEqualTo: searchQuery)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userDoc = snapshot.data!.docs[index];
                    bool isAdmin = userDoc['isAdmin'] ?? false;
                    return FadeTransition(
                      opacity: _opacityAnimation,
                      child: ListTile(
                        title: Text(userDoc['name']),
                        subtitle: Text(userDoc['email']),
                        trailing: ElevatedButton(
                          child:
                              Text(isAdmin ? "Remove Admin" : "Assign Admin"),
                          onPressed: () =>
                              toggleAdminRole(userDoc.id, !isAdmin),
                          style: ElevatedButton.styleFrom(
                            primary: isAdmin ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void toggleAdminRole(String userId, bool makeAdmin) {
    FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'isAdmin': makeAdmin,
    }).then((_) {
      print("User role updated successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User role updated successfully."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }).catchError((error) {
      print("Error updating user role: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating user role: $error"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}

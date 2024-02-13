import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utkarsh/constants/app_constants_colors.dart';
import 'package:utkarsh/screens/Forums/Content_add.dart';
import 'package:utkarsh/utils/ui/CustomTextWidget.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        backgroundColor: AppConstantsColors.accentColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('forums').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var forumPosts = snapshot.data?.docs;
          return ListView.builder(
            itemCount: forumPosts?.length,
            itemBuilder: (context, index) {
              var post = forumPosts![index];
              var title = post['title'];
              var content = post['content'];
              var emailId = post['emailId']; // Assuming this field contains the user's email directly
              var postId = post.id; // Accessing the document ID

              return buildPostCard(title, content, emailId, postId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Content_add()));
        },
        child: const Icon(Icons.add),
        backgroundColor: AppConstantsColors.accentColor,
      ),
    );
  }

  Widget buildPostCard(String title, String content, String userEmail, String postId) {
    bool isExpanded = false;

    return InkWell(
      onTap: () {
        // Implement post details screen navigation here
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Content_add()));

      },
      child: Card(
        shadowColor: AppConstantsColors.accentColor,
        elevation: 10,
        margin: const EdgeInsets.all(8),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Author: $userEmail',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  isExpanded ? content : content.substring(0, 100) + '...', // Limit content to 100 characters
                  style: const TextStyle(fontSize: 16),
                  maxLines: isExpanded ? null : 3, // Show max 3 lines initially
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded; // Toggle isExpanded state
                    });
                  },
                  child: Text(
                    isExpanded ? 'Read less' : 'Read more',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('forums').doc(postId).update({
                                'likes': FieldValue.arrayUnion([userEmail]),
                              });
                            },
                          ),
                          CustomTextWidget(
                            text: 'Likes',
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        // Implement comment functionality here
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

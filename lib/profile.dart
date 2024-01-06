import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Fetch user profile data
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData =
      FirebaseFirestore.instance.collection('users').doc(userId).get();

  @override
  Widget build(BuildContext context) {
    String name =
        FirebaseAuth.instance.currentUser!.displayName ?? "Default Name";
    String email = FirebaseAuth.instance.currentUser!.email ?? "N/A";
    String profilePictureUrl = "";
    ImageProvider<Object> defaultAvatar =
        AssetImage('assets/images/default-avatar.jpeg');
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([userData]),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            try {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                profilePictureUrl =
                    "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png";
              } else {
                var userSnapshot = snapshot.data?[0];
                print(userSnapshot?['profileImageUrl']);

                // Access user information and profile picture URL
                profilePictureUrl = userSnapshot?['profileImageUrl'];
              }
            } catch (e) {
              print(e);
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 60,
                      backgroundImage: profilePictureUrl.isNotEmpty
                          ? NetworkImage(profilePictureUrl)
                          : defaultAvatar),
                  SizedBox(height: 16),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildProfileInfoRow('Email', email),
                  SizedBox(height: 16),
                  _buildProfileInfoRow('Name', name),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

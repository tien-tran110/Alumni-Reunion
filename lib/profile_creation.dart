import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileCreationPage extends StatelessWidget {
  final String imageUrl;

  ProfileCreationPage({required this.imageUrl});

  // Add the function to upload the image URL to the user's profile in Firestore
  Future<void> _createUserProfile() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    //save image to user's collection
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'profileImageUrl': imageUrl,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(child: Image.network(imageUrl, height: 300)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _createUserProfile();
              Navigator.pop(context);
              print('profile created');
            },
            child: Text('Confirm Image'),
          ),
        ],
      ),
    );
  }
}

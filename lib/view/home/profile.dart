import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String _name = 'Unknown';
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _name = data?['Name'] ?? 'Unknown';
          _profilePictureUrl = data?['profilePicture'] as String?;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    }
  }

  Future<void> _pickImage() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }

    if (await Permission.photos.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _uploadImage();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission denied')));
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final profilePicturesRef = storageRef.child('profile_pictures').child('${user.uid}.jpg');

      // Upload the file
      await profilePicturesRef.putFile(_image!);

      // Get the download URL
      final downloadUrl = await profilePicturesRef.getDownloadURL();

      // Update Firestore with the new profile picture URL
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profilePicture': downloadUrl,
      });

      setState(() {
        _profilePictureUrl = downloadUrl; // Update local state with the new URL
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: _profilePictureUrl == null && _image == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                FloatingActionButton(
                  onPressed: _pickImage,
                  child: Icon(Icons.camera_alt),
                  mini: true,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              _name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Share your personality'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to share personality page
                    },
                  ),
                  ListTile(
                    title: Text('Connect with similar people'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to connect with similar people page
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to settings page
                    },
                  ),
                  ListTile(
                    title: Text('Credits'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Ican Logo and Thanks to Ican functionality
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Logout functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

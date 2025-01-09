import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas/components/styles.dart';
import 'package:uas/models/akun.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final Akun akun;

  ProfilePage({required this.akun});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  String nama = '';
  String role = '';
  String noHP = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      var userData = userDoc.data();
      setState(() {
        email = userData?['email'] ?? '';
        nama = userData?['nama'] ?? '';
        noHP = userData?['noHP'] ?? '';
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void keluar(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: const Color.fromARGB(255, 231, 246, 242),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Placeholder image
            ),
            SizedBox(height: 20),
            Text(
              nama,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama: $nama', style: TextStyle(fontSize: 18)),
                    Text('Email: $email', style: TextStyle(fontSize: 18)),
                    Text('No HP: $noHP', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 35),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  keluar(context);
                },
                child: Text('Logout',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

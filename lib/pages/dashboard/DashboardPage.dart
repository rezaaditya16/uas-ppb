import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas/models/akun.dart';
import 'package:uas/pages/all_laporan.dart' as all_laporan;
import 'package:uas/pages/my_laporan.dart' as my_laporan;
import 'package:uas/pages/dashboard/ProfilePage.dart' as profile;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Akun akun;
  int _selectedIndex = 0;
  late List<Widget> pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getAkun();
  }

  void getAkun() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        akun = Akun(
          uid: user.uid,
          email: user.email!,
          nama: userDoc['nama'] ?? '',
          docId: userDoc.id,
          noHP: userDoc['noHP'] ?? '',
          role: userDoc['role'] ?? '',
        );
      });
    }
  }

  TextStyle headerStyle({required int level}) {
    switch (level) {
      case 1:
        return TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      case 2:
        return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
      default:
        return TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      all_laporan.AllLaporan(akun: akun),
      my_laporan.MyLaporan(akun: akun),
      profile.ProfilePage(akun: akun),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('TokoKu', style: headerStyle(level: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.teal,
            child: Icon(Icons.add, size: 35),
            onPressed: () {
              Navigator.pushNamed(context, '/add', arguments: {
                'akun': akun,
              });
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.teal,
            child: Icon(Icons.category, size: 35),
            onPressed: () {
              Navigator.pushNamed(context, '/add_kategori');
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedItemColor: Colors.grey[400],
        unselectedFontSize: 14,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[_selectedIndex],
    );
  }
}

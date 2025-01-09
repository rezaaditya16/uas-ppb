import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas/models/akun.dart';
import 'package:uas/pages/all_laporan.dart' as all_laporan;
import 'package:uas/pages/my_laporan.dart' as my_laporan;
import 'package:uas/pages/dashboard/ProfilePage.dart' as profile;
import 'package:uas/components/styles.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Akun> akunFuture;
  int _selectedIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    akunFuture = getAkun();
  }

  Future<Akun> getAkun() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return Akun(
        uid: user.uid,
        email: user.email!,
        nama: userDoc['nama'] ?? '',
        docId: userDoc.id,
        noHP: userDoc['noHP'] ?? '',
        role: userDoc['role'] ?? '',
      );
    } else {
      throw Exception('User not logged in');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Akun>(
      future: akunFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final akun = snapshot.data!;
          pages = <Widget>[
            all_laporan.AllLaporan(akun: akun),
            my_laporan.MyLaporan(akun: akun),
            profile.ProfilePage(akun: akun),
          ];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 165, 201, 202),
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
              ],
            ),
            body: pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
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
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: Text('No data available')),
          );
        }
      },
    );
  }
}

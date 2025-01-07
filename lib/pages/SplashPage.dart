import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashFull();
  }
}

class SplashFull extends StatefulWidget {
  const SplashFull({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPage();
}

class _SplashPage extends State<SplashFull> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // nanti bagian ini diganti cek koneksi ke firebase dan cek login
    User? user = _auth.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () {
        // buat dashboard terlebih dahulu, lalu hapus komen line code dibawah ini
        //  Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      body: Center(
        child: Text('Welcome to cafe`in'),
      ),
    ));
  }
}

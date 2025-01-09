import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uas/firebase_options.dart';
import 'package:uas/pages/SplashPage.dart';
import 'package:uas/pages/AddFormPage.dart';
import 'package:uas/pages/dashboard/DashboardPage.dart';
import 'package:uas/pages/DetailPage.dart';
import 'package:uas/pages/LoginPage.dart';
import 'package:uas/pages/RegisterPage.dart';
import 'package:uas/pages/add_kategori_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Tokoku',
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => DashboardPage(),
      '/add': (context) => AddFormPage(),
      '/detail': (context) => DetailPage(
            laporan:
                (ModalRoute.of(context)!.settings.arguments as Map)['laporan'],
          ),
      '/add_kategori': (context) => AddKategoriPage(),
    },
  ));
}

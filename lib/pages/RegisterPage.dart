import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas/components/styles.dart';
import 'package:uas/components/validators.dart';
import 'package:uas/components/input_widget.dart';
import 'package:uas/models/akun.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  String nama = '';
  String email = '';
  String noHP = '';
  String password = '';
  String role = 'admin';

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save additional user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'nama': nama,
          'email': email,
          'noHP': noHP,
          'role': role,
        });

        // Navigate to login page or dashboard
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        print('Error: $e');
        // Handle error (e.g., show error message)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Text('Register', style: headerStyle(level: 1)),
                Container(
                  child: const Text(
                    'Create your profile to start your journey',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    onChanged: (String value) => setState(() {
                      nama = value;
                    }),
                    validator: notEmptyValidator,
                    decoration: customInputDecoration("Nama Lengkap"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    onChanged: (String value) => setState(() {
                      email = value;
                    }),
                    validator: notEmptyValidator,
                    decoration: customInputDecoration("@email.com"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    onChanged: (String value) => setState(() {
                      noHP = value;
                    }),
                    validator: notEmptyValidator,
                    decoration: customInputDecoration("+62....."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _password,
                    onChanged: (String value) => setState(() {
                      password = value;
                    }),
                    validator: notEmptyValidator,
                    obscureText: true,
                    decoration: customInputDecoration("Password"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    validator: (value) =>
                        passConfirmationValidator(value, _password),
                    obscureText: true,
                    decoration: customInputDecoration("Konfirmasi Password"),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: register,
                  child: Text('Register'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Sudah memiliki akun? Login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

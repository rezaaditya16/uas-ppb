import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uas/components/styles.dart';
import 'package:uas/components/vars.dart';
import 'package:uas/models/akun.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../components/input_widget.dart';
import '../components/validators.dart';

class AddFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddFormState();
}

class AddFormState extends State<AddFormPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  bool _isLoading = false;

  String? barang;
  String? stok;
  String? deskripsi;

  ImagePicker picker = ImagePicker();
  XFile? file;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Akun akun = arguments['akun'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Tambah Barang', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputLayout(
                            'Nama Barang',
                            TextFormField(
                                onChanged: (String value) => setState(() {
                                      barang = value;
                                    }),
                                validator: notEmptyValidator,
                                decoration: customInputDecoration("Nama"))),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                              onPressed: () {
                                uploadDialog(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_camera),
                                  Text(' Foto Barang',
                                      style: headerStyle(level: 3)),
                                ],
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: imagePreview(),
                        ),
                        InputLayout(
                            'Status Penjualan',
                            DropdownButtonFormField<String>(
                                decoration: customInputDecoration('Status'),
                                items: infoStatus.map((e) {
                                  return DropdownMenuItem<String>(
                                      child: Text(e), value: e);
                                }).toList(),
                                onChanged: (selected) {
                                  setState(() {
                                    stok = selected;
                                  });
                                })),
                        InputLayout(
                            "Deskripsi Barang",
                            TextFormField(
                              onChanged: (String value) => setState(() {
                                deskripsi = value;
                              }),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan semua di sini'),
                            )),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {
                                addTransaksi(akun);
                              },
                              child: Text(
                                'Kirim',
                                style: headerStyle(level: 3, dark: false),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Image imagePreview() {
    if (file == null) {
      return Image.asset('assets/istock-default.jpg', width: 180, height: 180);
    } else {
      return Image.file(File(file!.path), width: 180, height: 180);
    }
  }

  Future<dynamic> uploadDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Pilih sumber '),
            actions: [
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.camera);

                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.camera_alt),
              ),
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.photo_library),
              ),
            ],
          );
        });
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference dirUpload =
          _storage.ref().child('upload/${_auth.currentUser!.uid}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  Future<Position> getCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void addTransaksi(Akun akun) async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference laporanCollection = _firestore.collection('laporan');

      // Convert DateTime to Firestore Timestamp
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      String url = await uploadImage();

      String currentLocation = await getCurrentLocation().then((value) {
        return '${value.latitude},${value.longitude}';
      });

      String maps = 'https://www.google.com/maps/place/$currentLocation';
      final id = laporanCollection.doc().id;

      await laporanCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'docId': id,
        'barang': barang,
        'stok': stok,
        'deskripsi': deskripsi,
        'gambar': url,
        'nama': akun.nama,
        'status': 'Baru',
        'tanggal': timestamp,
        'maps': maps,
      }).catchError((e) {
        throw e;
      });
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

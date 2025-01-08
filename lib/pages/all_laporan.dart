import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uas/components/list_item.dart';
import 'package:uas/models/akun.dart';
import 'package:uas/models/laporan.dart';

class AllLaporan extends StatefulWidget {
  final Akun akun;
  AllLaporan({super.key, required this.akun});

  @override
  State<AllLaporan> createState() => _AllLaporanState();
}

class _AllLaporanState extends State<AllLaporan> {
  final _firestore = FirebaseFirestore.instance;

  List<Laporan> listLaporan = [];

  @override
  void initState() {
    super.initState();
    getTransaksi();
  }

  void getTransaksi() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('laporan').get();

      setState(() {
        listLaporan.clear();
        for (var documents in querySnapshot.docs) {
          List<dynamic>? komentarData = documents.data()['komentar'];

          List<Komentar>? listKomentar = komentarData?.map((map) {
            return Komentar(
              nama: map['nama'] ?? '',
              isi: map['isi'] ?? '',
            );
          }).toList();

          listLaporan.add(
            Laporan(
              uid: documents.data()['uid'] ?? '',
              docId: documents.data()['docId'] ?? '',
              judul: documents.data()['judul'] ?? '',
              stok: documents.data()['stok'] ?? '',
              deskripsi: documents.data()['deskripsi'],
              gambar: documents.data()['gambar'],
              nama: documents.data()['nama'] ?? '',
              status: documents.data()['status'] ?? '',
              tanggal: (documents.data()['tanggal'] as Timestamp).toDate(),
              maps: documents.data()['maps'] ?? '',
              komentar: listKomentar,
            ),
          );
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Laporan'),
      ),
      body: ListView.builder(
        itemCount: listLaporan.length,
        itemBuilder: (context, index) {
          return ListItem(
            laporan: listLaporan[index],
            akun: widget.akun,
            isLaporanku: false,
          );
        },
      ),
    );
  }
}

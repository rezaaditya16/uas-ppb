import 'package:flutter/material.dart';
import 'package:uas/components/status_dialog.dart';
import 'package:uas/components/styles.dart';
import 'package:uas/models/akun.dart';
import 'package:uas/models/laporan.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;

  DetailPage({required this.laporan, required this.akun, super.key});

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLoading = false;

  Future<void> launch(String uri) async {
    if (uri == '') return;
    if (!await launchUrl(Uri.parse(uri))) {
      throw Exception('Tidak dapat memanggil : $uri');
    }
  }

  void deleteLaporan(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('laporan')
          .doc(docId)
          .delete();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus laporan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Detail Barang', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.laporan.barang,
                        style: headerStyle(level: 3),
                      ),
                      SizedBox(height: 15),
                      widget.laporan.gambar != ''
                          ? Image.network(widget.laporan.gambar!)
                          : Image.asset('assets/istock-default.jpg'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(widget.laporan.tanggal),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.laporan.deskripsi ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Status: ${widget.laporan.status}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            statusDialog(context, widget.laporan);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Ubah Status'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            deleteLaporan(context, widget.laporan.docId);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Hapus Barang'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void statusDialog(BuildContext context, Laporan laporan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatusDialog(laporan: laporan);
      },
    );
  }
}

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
        SnackBar(content: Text('Laporan berhasil dihapus')),
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.laporan.barang,
                        style: headerStyle(level: 2),
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
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.laporan.deskripsi ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Stok: ${widget.laporan.stok}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Status Barang: ${widget.laporan.status}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              statusDialog(context, widget.laporan);
                            },
                            icon: Icon(Icons.edit),
                            label: Text('Ubah Status'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteLaporan(context, widget.laporan.docId);
                            },
                            icon: Icon(Icons.delete),
                            label: Text('Hapus Laporan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
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

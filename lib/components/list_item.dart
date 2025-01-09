import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uas/models/akun.dart';
import 'package:intl/intl.dart';
import 'package:uas/components/styles.dart';
import 'package:uas/models/laporan.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;
  final bool isLaporanku;
  ListItem(
      {super.key,
      required this.laporan,
      required this.akun,
      required this.isLaporanku});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;

  void deleteLaporan() async {
    try {
      await _firestore.collection('laporan').doc(widget.laporan.docId).delete();

      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: {
              'laporan': widget.laporan,
              'akun': widget.akun,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.laporan.barang,
                style: headerStyle(level: 3),
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('dd MMM yyyy').format(widget.laporan.tanggal),
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 5),
              Text(
                widget.laporan.deskripsi ?? '',
                style: TextStyle(fontSize: 16),
              ),
              if (widget.isLaporanku)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: deleteLaporan,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

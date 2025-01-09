import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uas/models/akun.dart';
import 'package:uas/models/laporan.dart';
import 'package:intl/intl.dart';

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
              barang: documents.data()['barang'] ?? '',
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
        title: Text('All Barang'),
        backgroundColor: Colors.teal,
      ),
      body: listLaporan.isEmpty
          ? Center(child: Text('Tidak ada laporan'))
          : ListView.builder(
              itemCount: listLaporan.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listLaporan[index].barang,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Stok: ${listLaporan[index].stok}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          listLaporan[index].deskripsi ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Status: ${listLaporan[index].status}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tanggal: ${DateFormat('dd MMM yyyy').format(listLaporan[index].tanggal)}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        listLaporan[index].gambar != null
                            ? Image.network(listLaporan[index].gambar!)
                            : Image.asset('assets/istock-default.jpg'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: {
                                'laporan': listLaporan[index],
                                'akun': widget.akun,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Lihat Detail'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

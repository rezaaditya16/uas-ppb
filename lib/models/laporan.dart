class Laporan {
  final String uid;
  final String docId;
  final String barang;
  final String statuss;
  String? deskripsi;
  String? gambar;
  final String nama;
  final String stok;
  final DateTime tanggal;
  final String maps;
  List<Kategori>? kategori;

  Laporan({
    required this.uid,
    required this.docId,
    required this.barang,
    required this.statuss,
    this.deskripsi,
    this.gambar,
    required this.nama,
    required this.stok,
    required this.tanggal,
    required this.maps,
    this.kategori,
  });
}

class Kategori {
  final String id;
  final String nama;

  Kategori({
    required this.id,
    required this.nama,
  });
}

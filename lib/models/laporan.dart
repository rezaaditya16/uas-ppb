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
  String? kategoriNama;

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
    this.kategoriNama,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'docId': docId,
      'barang': barang,
      'statuss': statuss,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'nama': nama,
      'stok': stok,
      'tanggal': tanggal.toIso8601String(),
      'maps': maps,
      'kategoriNama': kategoriNama,
    };
  }

  factory Laporan.fromMap(Map<String, dynamic> map) {
    return Laporan(
      uid: map['uid'],
      docId: map['docId'],
      barang: map['barang'],
      statuss: map['statuss'],
      deskripsi: map['deskripsi'],
      gambar: map['gambar'],
      nama: map['nama'],
      stok: map['stok'],
      tanggal: DateTime.parse(map['tanggal']),
      maps: map['maps'],
      kategoriNama: map['kategoriNama'],
    );
  }
}

class Kategori {
  final String nama;

  Kategori({
    required this.nama,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
    };
  }

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      nama: map['nama'],
    );
  }
}

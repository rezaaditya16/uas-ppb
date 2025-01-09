class Akun {
  final String uid;
  final String docId;
  final String nama;
  final String noHP;
  final String email;
  final String role;

  Akun({
    required this.uid,
    required this.docId,
    required this.nama,
    required this.noHP,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'docId': docId,
      'nama': nama,
      'noHP': noHP,
      'email': email,
      'role': role,
    };
  }

  factory Akun.fromMap(Map<String, dynamic> map) {
    return Akun(
      uid: map['uid'],
      docId: map['docId'],
      nama: map['nama'],
      noHP: map['noHP'],
      email: map['email'],
      role: map['role'],
    );
  }
}

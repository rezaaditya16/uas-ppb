import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uas/models/laporan.dart';
import 'package:uas/models/akun.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE laporan(
        uid TEXT PRIMARY KEY,
        docId TEXT,
        barang TEXT,
        statuss TEXT,
        deskripsi TEXT,
        gambar TEXT,
        nama TEXT,
        stok TEXT,
        tanggal TEXT,
        maps TEXT,
        kategoriNama TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE akun(
        uid TEXT PRIMARY KEY,
        docId TEXT,
        nama TEXT,
        noHP TEXT,
        email TEXT,
        role TEXT
      )
    ''');
  }

  Future<void> insertLaporan(Laporan laporan) async {
    final db = await database;
    await db.insert('laporan', laporan.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAkun(Akun akun) async {
    final db = await database;
    await db.insert('akun', akun.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Laporan>> getLaporanList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('laporan');

    return List.generate(maps.length, (i) {
      return Laporan.fromMap(maps[i]);
    });
  }

  Future<List<Akun>> getAkunList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('akun');

    return List.generate(maps.length, (i) {
      return Akun.fromMap(maps[i]);
    });
  }
}

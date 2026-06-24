import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'scan.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'plant_app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        label TEXT NOT NULL,
        confidence TEXT NOT NULL,
        timestamp DATETIME NOT NULL
      )
    ''');
  }

  Future<int> insertScan(Scan scan) async {
    Database db = await instance.db;
    return await db.insert('scans', scan.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllScans() async {
    Database db = await instance.db;
    return await db.query('scans');
  }

  Future<int> deleteScan(int id) async {
    Database db = await instance.db;
    return await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }
}

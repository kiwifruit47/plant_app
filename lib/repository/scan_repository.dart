import 'package:sqflite/sqflite.dart';
import '../model/scan.dart';
import '../db/database_helper.dart';

class ScanRepository {
  Future<int> saveScan(Scan scan) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('scans', scan.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllScans() async {
    Database db = await DatabaseHelper.instance.db;
    return await db.query('scans');
  }

  Future<int> deleteScan(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }

  Future<Scan?> getScan(int id) async {
    Database db = await DatabaseHelper.instance.db;
    var result = await db.rawQuery('SELECT * FROM scans WHERE id = ?', [id]);
    if (result.isNotEmpty) {
      return Scan.fromMap(result.first);
    }
    return null;
  }
}

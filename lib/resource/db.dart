import 'package:arc_inventory/modals/item.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as paths;

Future<Database> createDb() async {
  final dbPath = await sql.getDatabasesPath();
  print(dbPath);
  final path = paths.join(dbPath, "DataBase.db");

  final db = await sql.openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE data_storage(ValueKey TEXT PRIMARY KEY, Data TEXT )');
    },
    version: 1,
  );
  final data = await db.query('data_storage');
  print(data);
  return db;
}

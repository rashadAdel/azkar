import 'dart:async';
import 'package:azkar/model/zekr.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  //Todo: test update delete insert query
  static Db _instance;
  static Db get instance => _instance ?? Db._();
  Db._();
  Database _db;
  final int _version = 1;
  final String _dbName = 'azkar';
  Future<Database> get db async =>
      _db ??
      await openDatabase(
          join(
            (await getApplicationDocumentsDirectory()).path,
            '$_dbName.db',
          ),
          version: _version,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade);
  Future<FutureOr<void>> _onCreate(Database db, int version) async {
    await db.execute(_ZekrInitial._create);
    print('Zekr created');
    if (_ZekrInitial._firstData.isNotEmpty) {
      for (ZekrModel zekr in _ZekrInitial._firstData) {
        await db.insert('Zekr', zekr.toMap);
      }
      print("Zekr Data Inserted");
    }
    print('DataBase Created');
  }

  Future<List<Map<String, dynamic>>> queryTable(String tableName,
      {String where, List<String> columns, bool distinct}) async {
    Database dbQuery = await db;
    return await dbQuery.query('`$tableName`',
        where: '${(where == null) ? '' : ('and ' + where)}',
        columns: columns,
        distinct: distinct);
  }

  insert(String table, Map<String, dynamic> values) async {
    Database dbExec = await db;
    return dbExec.insert(table, values);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    print('DataBase Upgraded');
  }

  update(String table, Map<String, dynamic> values, String where) async {
    Database dbEx = await db;

    return dbEx.update(table, values, where: where);
  }

  delete(String table, String where) async {
    Database dbEx = await db;
    return dbEx.delete(table, where: where);
  }
}

class _ZekrInitial {
  static const String _create = """
  CREATE TABLE `Zekr` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT NOT NULL,
	`about`	TEXT DEFAULT 'لا يوحد',
	`category`	TEXT DEFAULT 'مخصصه',
	`target`	INTEGER DEFAULT 0,
	`actually`	INTEGER DEFAULT 0
);""";
  static const List<ZekrModel> _firstData = [];//Todo: initial first Data
}

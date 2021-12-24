library cached_storage;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cached_query/cached_query.dart';

class CachedStorage extends StorageInterface {
  static const String _queryTable = "Query";
  late final Database _db;
  bool isOpen = false;

  CachedStorage._();
  static final CachedStorage _instance = CachedStorage._();

  static Future<CachedStorage> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!_instance.isOpen) {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'query_storage.db');

      _instance._db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS $_queryTable(
           queryKey TEXT PRIMARY KEY,
           queryData TEXT
          )
          ''');
        },
      );
    }
    return _instance;
  }

  @override
  void close() {
    // TODO: implement close
  }

  @override
  void delete(String key) {
    // TODO: implement delete
  }

  @override
  void deleteAll() {
    // TODO: implement deleteAll
  }

  @override
  Future<String> get(String key) async {
    final query = await _db.query(
      _queryTable,
      where: 'queryKey = ?',
      whereArgs: [key],
      columns: ["queryData"],
      limit: 1,
    );
    return query.first["queryData"] as String;
  }

  @override
  void put(String key, {required String item}) async {
    try {
      await _db.insert(
        _queryTable,
        {"queryKey": key, "queryData": item},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // log(e.toString());
    }
  }
}

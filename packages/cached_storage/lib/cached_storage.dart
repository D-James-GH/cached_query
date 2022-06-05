library cached_storage;

import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// A storage delegate utilizing [sqflite](https://pub.dev/packages/sqflite) as the database plugin.
/// [CachedStorage] stores the fetched data as a jsonEncoded string.
/// If better performance or to have more control over how the data is stored
/// create a custom storage class by extending [StorageInterface] from the
/// [CachedQuery] package.
class CachedStorage extends StorageInterface {
  /// True if the SqfLite  instance is open
  bool isOpen = false;

  static const String _queryTable = "Query";
  static final CachedStorage _instance = CachedStorage._();
  late final Database _db;
  CachedStorage._();

  /// Initialise [CachedStorage]. Must be initialised before any [Query]'s are
  /// called.
  static Future<CachedStorage> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!_instance.isOpen) {
      final databasesPath = await getDatabasesPath();
      final String path = join(databasesPath, 'query_storage.db');

      _instance._db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            '''
          CREATE TABLE IF NOT EXISTS $_queryTable(
           queryKey TEXT PRIMARY KEY,
           queryData TEXT
          )
          ''',
          );
        },
      );
      _instance.isOpen = true;
    }
    return _instance;
  }

  @override
  void close() {
    _db.close();
  }

  @override
  void delete(String key) {
    _db.delete(
      _queryTable,
      where: "queryKey = ?",
      whereArgs: [key],
    );
  }

  @override
  void deleteAll() {
    _db.rawDelete("DELETE FROM $_queryTable");
  }

  @override
  Future<dynamic> get(String key) async {
    final dbQuery = await _db.query(
      _queryTable,
      where: 'queryKey = ?',
      whereArgs: [key],
      columns: ["queryData"],
      limit: 1,
    );
    if (dbQuery.isNotEmpty) {
      final item = dbQuery.first["queryData"];
      if (item is String) {
        return jsonDecode(item);
      }
    }
    return null;
  }

  @override
  void put<T>(String key, {required T item}) async {
    try {
      await _db.insert(
        _queryTable,
        {"queryKey": key, "queryData": jsonEncode(item)},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception(
        "Error inserting into the Database. It is likely that the data in this query is not directly serializable and it does not have a `.toJson()` method",
      );
    }
  }
}

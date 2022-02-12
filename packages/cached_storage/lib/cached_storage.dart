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
  static const String _queryTable = "Query";
  late final Database _db;
  bool isOpen = false;

  CachedStorage._();
  static final CachedStorage _instance = CachedStorage._();

  static Future<CachedStorage> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!_instance.isOpen) {
      final databasesPath = await getDatabasesPath();
      final String path = join(databasesPath, 'query_storage.db');

      _instance._db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // TODO(dan): add expiry to stored data --> 24hrs?
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
    // TODO(Dan): implement close
  }

  @override
  void delete(String key) {
    // TODO(Dan): implement delete
  }

  @override
  void deleteAll() {
    // TODO(Dan): implement deleteAll
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
          "Error inserting into the Database. It is likely that the data in this query is not directly serializable and it does not have a `.toJson()` method");
    }
  }
}

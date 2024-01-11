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

  static const String _queryTable = "CachedQueryStorage";
  static const String _oldQueryTable = "Query";
  final Database _db;

  CachedStorage._(this._db);

  /// Manual constructor for testing
  @visibleForTesting
  CachedStorage(this._db);

  /// Initialise [CachedStorage]. Must be initialised before any [Query]'s are
  /// called.
  static Future<CachedStorage> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'query_storage.db');

    final db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        final batch = db.batch();
        _createQueryTable(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch()
          ..execute("DROP TABLE IF EXISTS $_oldQueryTable");
        _createQueryTable(batch);
        await batch.commit();
      },
    );

    return CachedStorage._(db);
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
  Future<StoredQuery?> get(String key) async {
    final dbQuery = await _db.query(
      _queryTable,
      where: 'queryKey = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (dbQuery.isEmpty) {
      return null;
    }

    final data = dbQuery.first["queryData"];
    final createdAt = dbQuery.first["createdAtMs"] ?? 0;
    final duration = dbQuery.first["durationMs"];

    if (data is String) {
      final json = jsonDecode(data);
      return StoredQuery(
        key: key,
        data: json,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt as int),
        storageDuration:
            duration == null ? null : Duration(milliseconds: duration as int),
      );
    }

    return null;
  }

  @override
  void put(StoredQuery query) async {
    try {
      final payload = jsonEncode(query.data);
      await _db.insert(
        _queryTable,
        {
          "queryKey": query.key,
          "queryData": payload,
          "createdAtMs": query.createdAt.millisecondsSinceEpoch,
          "durationMs": query.storageDuration?.inMilliseconds,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception(
        """Error inserting into the Database.
It is likely that the data in this query is not directly serializable and it does not have a `.toJson()` method

${e.toString()}
""",
      );
    }
  }
}

void _createQueryTable(Batch batch) {
  batch.execute(
    '''CREATE TABLE IF NOT EXISTS ${CachedStorage._queryTable}(
       queryKey TEXT PRIMARY KEY,
       queryData TEXT,
       createdAtMs INTEGER,
       durationMs INTEGER
      )''',
  );
}

import 'dart:convert';

import 'package:cached_storage/cached_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

import 'cached_storage_test.mocks.dart';

@GenerateMocks([Database])
void main() async {
  group("Cached storage", () {
    test("Inserting should json encode the payload", () async {
      final db = MockDatabase();
      when(
        db.insert(any, any, conflictAlgorithm: anyNamed("conflictAlgorithm")),
      ).thenAnswer((realInvocation) async => 1);

      CachedStorage(db).put("key", item: {"something": "something else"});
      final dynamic captured = verify(
        db.insert(
          any,
          captureAny,
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).captured.first;
      expect(captured["queryData"], isA<String>());
    });
    test("Can get item and decode it", () async {
      final data = {"something": "some value"};

      final db = MockDatabase();
      when(
        db.query(
          any,
          whereArgs: argThat(equals(["dbKey"]), named: "whereArgs"),
          columns: anyNamed("columns"),
          limit: anyNamed("limit"),
          where: anyNamed("where"),
        ),
      ).thenAnswer(
        (_) async => [
          {"queryData": jsonEncode(data)},
        ],
      );

      final storage = CachedStorage(db);
      final dynamic fromStorage = await storage.get("dbKey");

      expect(fromStorage, data);
    });
  });
}

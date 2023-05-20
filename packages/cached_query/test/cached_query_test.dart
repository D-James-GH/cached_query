import 'package:cached_query/cached_query.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'cached_query_test.mocks.dart';

@GenerateMocks([StorageInterface, Query, InfiniteQuery])
void main() {
  setUp(() {});
  test("Add and get a Query", () {
    final query = MockQuery<String>();
    when(query.key).thenReturn("query");
    final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

    expect(cachedQuery.getQuery("query"), isNotNull);
  });
  group("Config", () {
    test("Should be able to set config", () {
      final cachedQuery = CachedQuery.asNewInstance()
        ..config(config: GlobalQueryConfig());
      expect(cachedQuery.isConfigSet, true);
    });
    test("Defaults should be set", () {
      final config = GlobalQueryConfig();
      expect(config, GlobalQueryConfig.defaults());
    });
    test("Should be able to override default values", () async {
      final config = GlobalQueryConfig(
        storeQuery: false,
        shouldRethrow: true,
        refetchDuration: Duration.zero,
        cacheDuration: Duration.zero,
        ignoreCacheDuration: true,
      );
      final cachedQuery = CachedQuery.asNewInstance()..config(config: config);
      expect(cachedQuery.defaultConfig, config);
    });
  });
  group("Invalidate cache", () {
    test("Invalidate the whole cache", () async {
      final query = MockQuery<String>();
      when(query.key).thenReturn("query");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..invalidateCache();
      verify(query.invalidateQuery());
    });

    test("Invalidate using filter", () async {
      final query = MockQuery<String>();
      final query2 = MockQuery<String>();
      final query3 = MockQuery<String>();
      when(query.key).thenReturn("query");
      when(query.unencodedKey).thenReturn("query");
      when(query2.key).thenReturn("query2");
      when(query2.unencodedKey).thenReturn("query2");
      when(query3.key).thenReturn("other_key");
      when(query3.unencodedKey).thenReturn("other_key");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..addQuery(query3)
        ..invalidateCache(
          filterFn: (unencodedKey, key) {
            if (key.contains("query")) {
              return true;
            }
            return false;
          },
        );
      verify(query.invalidateQuery());
      verify(query2.invalidateQuery());
      verifyNever(query3.invalidateQuery());
    });
    test("Invalidate the query", () async {
      final query = MockQuery<String>();
      when(query.key).thenReturn("query");

      final query2 = MockQuery<String>();
      when(query2.key).thenReturn("query2");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query)
        ..invalidateCache(key: "query");
      verify(query.invalidateQuery());
      verifyNever(query2.invalidateQuery());
    });
  });
  group("Delete cache", () {
    test("Delete the whole cache", () async {
      final query = MockQuery<String>();
      when(query.key).thenReturn("delete");
      final cachedQuery = CachedQuery.asNewInstance()
        ..addQuery(query)
        ..deleteCache();
      expect(cachedQuery.getQuery("delete"), isNull);
    });

    test("Delete using filter", () async {
      final query = MockQuery<String>();
      final query2 = MockQuery<String>();
      final query3 = MockQuery<String>();
      when(query.key).thenReturn("query");
      when(query.unencodedKey).thenReturn("query");
      when(query2.key).thenReturn("query2");
      when(query2.unencodedKey).thenReturn("query2");
      when(query3.key).thenReturn("other_key");
      when(query3.unencodedKey).thenReturn("other_key");
      final cache = CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..addQuery(query3)
        ..deleteCache(
          filterFn: (unencodedKey, key) {
            if (key.contains("query")) {
              return true;
            }
            return false;
          },
        );
      expect(cache.getQuery("query"), isNull);
      expect(cache.getQuery("query2"), isNull);
      expect(cache.getQuery("other_key"), isNotNull);
    });

    test("Delete using filter with storage", () async {
      final query = MockQuery<String>();
      final storage = MockStorageInterface();
      when(query.key).thenReturn("query");
      when(query.unencodedKey).thenReturn("query");
      CachedQuery.asNewInstance()
        ..config(storage: storage)
        ..addQuery(query)
        ..deleteCache(
          deleteStorage: true,
          filterFn: (unencodedKey, key) {
            if (key.contains("query")) {
              return true;
            }
            return false;
          },
        );
      verify(storage.delete("query"));
    });
    test("Delete whole cache and storage", () async {
      final query = MockQuery<String>();
      when(query.key).thenReturn("delete");
      final storage = MockStorageInterface();
      CachedQuery.asNewInstance()
        ..config(storage: storage)
        ..addQuery(query)
        ..deleteCache(deleteStorage: true);
      verify(storage.deleteAll());
    });

    test("Delete the query", () async {
      final query = MockQuery<String>();
      when(query.key).thenReturn("delete");
      final query2 = MockQuery<String>();
      when(query2.key).thenReturn("delete2");
      final cachedQuery = CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..deleteCache(key: "delete2");

      expect(cachedQuery.getQuery("delete"), isNotNull);
      expect(cachedQuery.getQuery("delete2"), isNull);
    });
  });
  group("group", () {
    test("update query", () {
      final query = MockQuery<String>();
      when(query.key).thenReturn("update");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..updateQuery(
          key: "update",
          updateFn: (dynamic value) => "",
        );
      verify(query.update(any));
    });

    test("update query multiple queries with filter", () {
      final query = MockQuery<String>();
      final query2 = MockQuery<String>();
      final query3 = MockQuery<String>();
      when(query.key).thenReturn("query");
      when(query.unencodedKey).thenReturn("query");
      when(query2.key).thenReturn("query2");
      when(query2.unencodedKey).thenReturn("query2");
      when(query3.key).thenReturn("other_key");
      when(query3.unencodedKey).thenReturn("other_key");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..addQuery(query3)
        ..updateQuery(
          filterFn: (unencodedKey, key) => key.startsWith("query"),
          updateFn: (dynamic value) => "",
        );
      verify(query.update(any));
      verify(query2.update(any));
      verifyNever(query3.update(any));
    });

    test("<Deprecated> update infinite query ", () {
      final query = MockInfiniteQuery<String, int>();
      when(query.key).thenReturn("update");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        // ignore: deprecated_member_use_from_same_package
        ..updateInfiniteQuery<String>(
          key: "update",
          updateFn: (value) => [],
        );
      verify(query.update(any));
    });

    test("update infinite query", () {
      final query = MockInfiniteQuery<String, int>();
      when(query.key).thenReturn("update");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..updateQuery(
          key: "update",
          updateFn: (dynamic value) {
            if (value is List<String>) {
              return <String>[];
            }
          },
        );
      verify(query.update(any));
    });
  });

  group("Refetch Queries", () {
    test("Refetch using filter", () async {
      final query = MockQuery<String>();
      final query2 = MockInfiniteQuery<int, String>();
      final query3 = MockQuery<String>();
      when(query.key).thenReturn("query");
      when(query.unencodedKey).thenReturn("query");
      when(query2.key).thenReturn("query2");
      when(query2.unencodedKey).thenReturn("query2");
      when(query3.key).thenReturn("other_key");
      when(query3.unencodedKey).thenReturn("other_key");

      when(query.refetch()).thenAnswer(
        (_) async => QueryState(timeCreated: DateTime.now()),
      );

      when(query2.refetch()).thenAnswer(
        (_) async => InfiniteQueryState(timeCreated: DateTime.now()),
      );

      when(query3.refetch()).thenAnswer(
        (_) async => QueryState(timeCreated: DateTime.now()),
      );
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..addQuery(query3)
        ..refetchQueries(
          filterFn: (unencodedKey, key) {
            if (key.contains("query")) {
              return true;
            }
            return false;
          },
        );

      verify(query.refetch());
      verify(query2.refetch());
      verifyNever(query3.refetch());
    });
    test("Refetch queries", () {
      final query = MockQuery<String>();
      when(query.key).thenReturn("query");
      when(query.refetch()).thenAnswer(
        (_) async => QueryState(timeCreated: DateTime.now()),
      );
      final query2 = MockQuery<String>();
      when(query2.key).thenReturn("query2");

      when(query2.refetch()).thenAnswer(
        (_) async => QueryState(timeCreated: DateTime.now()),
      );
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..refetchQueries(keys: ["query", "query2"]);
      verify(query.refetch());
      verify(query2.refetch());
    });
  });
  test("Where query", () {
    final query = MockQuery<String>();
    when(query.key).thenReturn("1");
    final query2 = MockQuery<String>();
    when(query2.key).thenReturn("2");
    final cachedQuery = CachedQuery.asNewInstance()
      ..addQuery(query)
      ..addQuery(query2);
    final queries = cachedQuery.whereQuery((p) => p.key == "2");
    expect(queries!.length, 1);
    expect(queries.first.key, "2");
  });
}

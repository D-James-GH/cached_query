import 'package:cached_query/cached_query.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'cached_query_test.mocks.dart';

@GenerateMocks([StorageInterface, Query, InfiniteQuery])
void main() {
  setUp(() {
    CachedQuery.instance.deleteCache();
    provideDummy(QueryStatus<String>.initial(timeCreated: DateTime.now()));
  });
  test("Add and get a Query", () {
    final query = Query(key: "query", queryFn: () => Future.value("query"));
    final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

    expect(cachedQuery.getQuery("query"), isNotNull);
  });
  group("Config", () {
    test("Should be able to set config", () {
      final cachedQuery = CachedQuery.asNewInstance()
        ..config(config: QueryConfig());
      expect(cachedQuery.isConfigSet, true);
    });
    test("Defaults should be set", () {
      final config = QueryConfig();
      expect(config, QueryConfig.defaults());
    });
    test("Different caches have different config", () {
      final cache1 = CachedQuery.asNewInstance()..config(config: QueryConfig());
      final cache2 = CachedQuery.asNewInstance()..config(config: QueryConfig());
      expect(cache1.defaultConfig, isNot(same(cache2.defaultConfig)));
    });
    test("Should be able to override default values", () async {
      final config = QueryConfig(
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

    test("Invalidate fetches active query", () async {
      final cache = CachedQuery.asNewInstance();
      int query1Count = 0;
      int query2Count = 0;
      final query1 = Query(
        key: "query1",
        queryFn: () {
          query1Count++;
          return Future.value("res");
        },
        cache: cache,
      );
      final query2 = Query(
        key: "query2",
        queryFn: () {
          query2Count++;
          return Future.value("res2");
        },
        cache: cache,
      );
      final sub = query1.stream.listen((state) {});
      await query2.result;
      cache.invalidateCache(key: "query1");
      expect(query1Count, 2);
      expect(query2Count, 1);
      await sub.cancel();
    });

    test("Invalidate can fetch inactive query", () async {
      final cache = CachedQuery.asNewInstance();
      int query1Count = 0;
      final query = Query(
        key: "query1",
        queryFn: () {
          query1Count++;
          return Future.value("res");
        },
        cache: cache,
      );
      await query.result;
      cache.invalidateCache(key: "query1", refetchInactive: true);
      expect(query1Count, 2);
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

    test("update infinite query", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: "update",
        getNextArg: (_) => 1,
        queryFn: (page) => Future.value(""),
      );
      await query.result;
      cache.updateQuery(
        key: "update",
        updateFn: (dynamic v) {
          final value = v as List<String>;
          return [...value, "new"];
        },
      );
      expect(query.state.data!.length, 2);
      expect(query.state.data![1], "new");
    });
  });

  group("Refetch Queries", () {
    test("Refetch using filter", () async {
      int query1Count = 0;
      final query = Query<String>(
        key: "query1",
        queryFn: () {
          query1Count++;
          return Future.value("nothing");
        },
      );
      var query2Count = 0;
      final query2 = InfiniteQuery<String, int>(
        key: "infinite_query_1",
        getNextArg: (_) => 1,
        queryFn: (page) {
          query2Count++;
          return Future.value("nothing");
        },
      );
      int query3Count = 0;
      final query3 = Query<String>(
        key: "other_key3",
        queryFn: () {
          query3Count++;
          return Future.value("nothing");
        },
      );
      final cache = CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..addQuery(query3);
      await cache.refetchQueries(
        filterFn: (unencodedKey, key) {
          if (key.contains("query")) {
            return true;
          }
          return false;
        },
      );

      expect(query1Count, 1);
      expect(query2Count, 1);
      expect(query3Count, 0);
    });
    test("Refetch queries", () async {
      int query1Count = 0;
      final query = Query<String>(
        key: "query1",
        queryFn: () {
          query1Count++;
          return Future.value("nothing");
        },
      );
      var query2Count = 0;
      final query2 = InfiniteQuery<String, int>(
        key: "infinite_query_1",
        getNextArg: (_) => 1,
        queryFn: (page) {
          query2Count++;
          return Future.value("nothing");
        },
      );
      int query3Count = 0;
      final query3 = Query<String>(
        key: "other_key3",
        queryFn: () {
          query3Count++;
          return Future.value("nothing");
        },
      );
      final cache = CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query2)
        ..addQuery(query3);
      await cache.refetchQueries(
        keys: ["query1", "infinite_query_1"],
      );

      expect(query1Count, 1);
      expect(query2Count, 1);
      expect(query3Count, 0);
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

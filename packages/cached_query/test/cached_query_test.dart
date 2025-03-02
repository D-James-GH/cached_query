import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'test_implementations.dart';

void main() {
  setUp(CachedQuery.instance.deleteCache);
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
      final query = createQuery();
      // await query.result;
      expect(query.stale, false);
      await query.result;
      expect(query.stale, false);
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..invalidateCache();
      expect(query.stale, true);
    });

    test("Invalidate using filter", () async {
      final query = createQuery();
      final query2 = createQuery();
      final query3 = createQuery(key: "other_invalid_key");
      CachedQuery.asNewInstance()
        ..config(
          config: QueryConfig(
            refetchDuration: const Duration(minutes: 5),
          ),
        )
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
      // verify(query.invalidateQuery());
      // verify(query2.invalidateQuery());
      // verifyNever(query3.invalidateQuery());
      expect(query.stale, true);
      expect(query2.stale, true);
      expect(query3.stale, false);
    });

    test("Invalidate the query", () async {
      final query = createQuery(key: "query");
      final query2 = createQuery();
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query)
        ..invalidateCache(key: "query");
      expect(query.stale, true);
      expect(query2.stale, false);
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
      final query = createQuery();
      final cachedQuery = CachedQuery.asNewInstance()
        ..addQuery(query)
        ..deleteCache();
      expect(cachedQuery.getQuery("delete"), isNull);
    });

    test("Delete using filter", () async {
      final query = createQuery();
      final query2 = createQuery();
      final query3 = createQuery(key: "other_key");
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
      var deletedKey = "";
      final storage = TestStorage(
        onDelete: (key) {
          deletedKey = key;
        },
      );

      final cache = CachedQuery.asNewInstance()..config(storage: storage);

      final query = createQuery(
        cache: cache,
        key: "query",
      );
      await query.result;
      cache.deleteCache(
        deleteStorage: true,
        filterFn: (unencodedKey, key) {
          if (key.contains("query")) {
            return true;
          }
          return false;
        },
      );

      expect(deletedKey, "query");
      expect(cache.getQuery("query"), isNull);
    });

    test("Delete whole cache and storage", () async {
      var deletedAll = false;
      final storage = TestStorage(
        onDeleteAll: () {
          deletedAll = true;
        },
      );

      final cache = CachedQuery.asNewInstance()..config(storage: storage);

      final query = createQuery(
        cache: cache,
        key: "query",
      );
      await query.result;
      cache.deleteCache(deleteStorage: true);

      expect(deletedAll, true);
    });

    test("Delete the query", () async {
      createQuery(key: "delete");
      createQuery(key: "delete2");

      CachedQuery.instance.deleteCache(key: "delete2");

      expect(CachedQuery.instance.getQuery("delete"), isNotNull);
      expect(CachedQuery.instance.getQuery("delete2"), isNull);
    });
  });
  group("group", () {
    test("update query", () async {
      const res = "updated value";
      final query = createQuery(key: "update");
      await query.result;
      expect(query.state.data, "result");
      CachedQuery.instance.updateQuery(
        key: "update",
        updateFn: (dynamic value) => res,
      );
      expect(query.state.data, res);
    });

    test("update query multiple queries with filter", () async {
      final query = createQuery();
      await query.result;
      final query2 = createQuery();
      await query2.result;
      final query3 = createQuery(key: "other_key");
      await query3.result;

      CachedQuery.instance.updateQuery(
        filterFn: (unencodedKey, key) => key.startsWith("query"),
        updateFn: (dynamic value) => "updated",
      );

      expect(query.state.data, "updated");
      expect(query2.state.data, "updated");
      expect(query3.state.data, testQueryRes);
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
    createQuery(key: "1");
    createQuery(key: "2");
    final queries = CachedQuery.instance.whereQuery((p) => p.key == "2");
    expect(queries!.length, 1);
    expect(queries.first.key, "2");
  });
}

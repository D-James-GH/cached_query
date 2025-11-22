// ignore_for_file: avoid_redundant_argument_values
import 'package:cached_query/cached_query.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

import 'test_implementations.dart';

void main() {
  setUp(CachedQuery.instance.deleteCache);
  test("Add and get a Query", () {
    final query = Query(key: "query", queryFn: () => Future.value("query"));
    final cachedQuery = CachedQuery.asNewInstance()..addQuery(query);

    expect(cachedQuery.getQuery<Query<String>>("query"), isNotNull);
  });
  group("Config", () {
    test("Should be able to set config", () {
      final cachedQuery = CachedQuery.asNewInstance()
        ..config(config: GlobalQueryConfig());
      expect(cachedQuery.isConfigSet, true);
    });
    test("Different caches have different config", () {
      final cache1 = CachedQuery.asNewInstance()
        ..config(config: GlobalQueryConfig());
      final cache2 = CachedQuery.asNewInstance()
        ..config(config: GlobalQueryConfig());
      expect(cache1.defaultConfig, isNot(same(cache2.defaultConfig)));
    });
    test("Should be able to override default values", () async {
      final config = GlobalQueryConfig(
        storeQuery: false,
        shouldRethrow: true,
        staleDuration: Duration.zero,
        cacheDuration: Duration.zero,
        ignoreCacheDuration: true,
      );
      final cachedQuery = CachedQuery.asNewInstance()..config(config: config);
      expect(cachedQuery.defaultConfig, config);
      expect(cachedQuery.defaultConfig, isNot(GlobalQueryConfig()));
    });
  });
  group("Invalidate cache", () {
    test("Invalidate the whole cache", () async {
      final cache = CachedQuery.asNewInstance();
      final query = createQuery(cache: cache);
      await query.fetch();
      expect(query.stale, false);

      cache.invalidateCache();

      expect(query.stale, true);
    });

    test("Invalidate using filter", () async {
      final cache = CachedQuery.asNewInstance()
        ..config(
          config: GlobalQueryConfig(
            staleDuration: const Duration(minutes: 5),
          ),
        );
      final query = createQuery(cache: cache);
      await query.fetch();
      final query2 = createQuery(cache: cache);
      await query2.fetch();
      final query3 = createQuery(key: "other_invalid_key", cache: cache);
      await query3.fetch();
      cache.invalidateCache(
        filterFn: (unencodedKey, key) {
          if (key.contains("query")) {
            return true;
          }
          return false;
        },
      );
      expect(query.stale, true);
      expect(query2.stale, true);
      expect(query3.stale, false);
    });

    test("Invalidate the query", () async {
      final cache = CachedQuery.asNewInstance();
      final query = createQuery(key: "query", cache: cache);
      final query2 = createQuery(cache: cache);
      await query.fetch();
      await query2.fetch();
      expect(query.stale, false);
      expect(query2.stale, false);
      cache.invalidateCache(key: "query");
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
      await query2.fetch();
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
      await query.fetch();
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
      final cache = CachedQuery.asNewInstance();
      createQuery(cache: cache);
      createQuery(cache: cache);
      createQuery(key: "other_key", cache: cache);
      cache.deleteCache(
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
      await query.fetch();
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
      await query.fetch();
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
      await query.fetch();
      expect(query.state.data, "result");
      CachedQuery.instance.updateQuery(
        key: "update",
        updateFn: (dynamic value) => res,
      );
      expect(query.state.data, res);
    });

    test("update query multiple queries with filter", () async {
      final cache = CachedQuery.asNewInstance();
      final query = createQuery(cache: cache);
      await query.fetch();
      final infiniteQuery = InfiniteQuery(
        key: "query_infinite",
        queryFn: (arg) => Future.value(arg.toString()),
        getNextArg: (data) => (data?.pages.length ?? 0) > 4 ? null : 1,
        cache: cache,
      );
      await infiniteQuery.fetch();
      final query3 = createQuery(key: "other_key");
      await query3.fetch();

      cache.updateQuery(
        filterFn: (unencodedKey, key) => key.startsWith("query"),
        updateFn: (dynamic value) {
          if (value is InfiniteQueryData<String, int>) {
            return InfiniteQueryData(pages: ["updated"], args: [1]);
          }
          if (value is String) {
            return "updated";
          }
          return value;
        },
      );

      expect(query.state.data, "updated");
      expect(infiniteQuery.state.data!.pages.first, "updated");
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
      await query.fetch();
      cache.updateQuery(
        key: "update",
        updateFn: (v) {
          final value = v as InfiniteQueryData<String, int>;
          return InfiniteQueryData(
            pages: [...value.pages, "new"],
            args: value.args,
          );
        },
      );
      expect(query.state.data!.pages.length, 2);
      expect(query.state.data!.pages[1], "new");
    });
  });

  group("Refetch Queries", () {
    test("Refetch using filter", () async {
      final cache = CachedQuery.asNewInstance();
      int query1Count = 0;
      final query = Query<String>(
        key: "query1",
        cache: cache,
        queryFn: () {
          query1Count++;
          return Future.value("nothing");
        },
      );
      var query2Count = 0;
      final query2 = InfiniteQuery<String, int>(
        key: "infinite_query_1",
        cache: cache,
        getNextArg: (_) => 1,
        queryFn: (page) {
          query2Count++;
          return Future.value("nothing");
        },
      );
      int query3Count = 0;
      final query3 = Query<String>(
        key: "other_key3",
        cache: cache,
        queryFn: () {
          query3Count++;
          return Future.value("nothing");
        },
      );
      await query.fetch();
      await query2.fetch();
      await query3.fetch();
      await cache.refetchQueries(
        filterFn: (unencodedKey, key) {
          if (key.contains("query")) {
            return true;
          }
          return false;
        },
      );

      expect(query1Count, 2);
      expect(query2Count, 2);
      expect(query3Count, 1);
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
    expect(queries.length, 1);
    expect(queries.first.key, "2");
  });
  group("Set Query", () {
    test("Set query creates new query if not existing", () {
      final cache = CachedQuery.asNewInstance()
        ..setQueryData<String>(
          key: "set_query",
          data: "new_value",
        );
      final query = cache.getQuery<Query<String>>("set_query");
      expect(query?.state.data, "new_value");
    });
    test("Calling fetch on a empty query fails", () async {
      final cache = CachedQuery.asNewInstance()
        ..setQueryData<String>(
          key: "set_query",
          data: "new_value",
        );
      final query = cache.getQuery<Query<String>>("set_query");
      final status = await query!.refetch();
      expect(status, isA<QueryError<dynamic>>());
      expect((status as QueryError).error, isA<UnimplementedError>());
    });
    test("Creating a query after updates queryFn", () {
      fakeAsync((async) async {
        final cache = CachedQuery.asNewInstance()
          ..setQueryData<String>(
            key: "set_query",
            data: "new_value",
          );
        final emptyQuery = cache.getQuery<Query<String>>("set_query");
        expect(emptyQuery, isNotNull);
        final query = Query<String>(
          key: "set_query",
          queryFn: () async => Future.delayed(
            Duration(milliseconds: 300),
            () => "fetched_value",
          ),
          cache: cache,
        );
        expect(query.state.data, "new_value");

        final f = query.refetch();
        async.elapse(const Duration(milliseconds: 300));
        final status = await f;
        expect(status.data, "fetched_value");
        expect(status, isA<QueryError<String>>());
      });
    });
  });

  group("Set Infinite Query", () {
    test("Set query creates new infinite query if not existing", () async {
      final key = "set_i_query";
      final cache = CachedQuery.asNewInstance()
        ..setQueryData<InfiniteQueryData<String, int>>(
          key: key,
          data: InfiniteQueryData<String, int>(
            pages: ["new_value"],
            args: [1],
          ),
        );

      final query =
          cache.getQuery<Query<InfiniteQueryData<String, int>>>("set_i_query");

      expect(query?.state.data?.pages.first, "new_value");

      final infiniteQuery = InfiniteQuery<String, int>(
        key: key,
        getNextArg: (data) => 1,
        queryFn: (page) async => "",
        cache: cache,
      );
      expect(infiniteQuery.state.data?.pages.first, "new_value");
      final res = await infiniteQuery.getNextPage();
      expect(res, isA<InfiniteQuerySuccess<String, int>>());
      final data = (res as InfiniteQuerySuccess).data;
      expect(data.pages.length, 2);
      expect(data, query?.state.data);
    });

    test("Getting infinite query fails", () async {
      final cache = CachedQuery.asNewInstance()
        ..setQueryData<String>(
          key: "set_query",
          data: "new_value",
        );
      try {
        final _ = cache.getQuery<InfiniteQuery<String, int>>("set_query");
        fail("Cannot get infinite query because it hasn't been created");
      } catch (e) {
        expect(e, isA<TypeError>());
      }
    });

    test("Can convert an empty Query to an infinite query.", () {
      fakeAsync((async) async {
        final cache = CachedQuery.asNewInstance()
          ..setQueryData<String>(
            key: "set_i_query",
            data: "new_value",
          );
        final emptyQuery = cache.getQuery<Query<String>>("set_i_query");
        expect(emptyQuery, isNotNull);
        final query = InfiniteQuery<String, int>(
          key: "set_i_query",
          getNextArg: (state) => (state?.length ?? 0) + 1,
          queryFn: (_) async => Future.delayed(
            Duration(milliseconds: 300),
            () => "fetched_value",
          ),
          cache: cache,
        );
        expect(query.state.data, "new_value");

        final f = query.refetch();
        async.elapse(const Duration(milliseconds: 300));
        final status = await f;
        expect(status.data, "fetched_value");
        expect(status, isA<InfiniteQueryError<String, int>>());
      });
    });
    test("Can not convert existing query into infinite query", () {
      final cache = CachedQuery.asNewInstance();
      final key = "query_key";
      final query = Query(key: key, queryFn: () async => "", cache: cache);

      expect(
        () => InfiniteQuery<String, int>(
          key: key,
          getNextArg: (state) => (state?.length ?? 0) + 1,
          queryFn: (_) async => "",
          cache: cache,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}

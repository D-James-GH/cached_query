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
        ..config(config: QueryConfig());
      expect(cachedQuery.isConfigSet, true);
    });
    test("Defaults should be set", () {
      final config = QueryConfig();
      expect(config, QueryConfig.defaults());
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

    test("Invalidate the query", () async {
      final query = MockQuery<String>();
      when(query.key).thenReturn("query");

      final query2 = MockQuery<String>();
      when(query2.key).thenReturn("query2");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..addQuery(query)
        ..invalidateCache("query");
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
        ..updateQuery<String>(
          key: "update",
          updateFn: (value) => "",
        );
      verify(query.update(any));
    });
    test("update infinite query", () {
      final query = MockInfiniteQuery<String, int>();
      when(query.key).thenReturn("update");
      CachedQuery.asNewInstance()
        ..addQuery(query)
        ..updateInfiniteQuery<String>(
          key: "update",
          updateFn: (value) => [],
        );
      verify(query.update(any));
    });
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
      ..refetchQueries(["query", "query2"]);
    verify(query.refetch());
    verify(query2.refetch());
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

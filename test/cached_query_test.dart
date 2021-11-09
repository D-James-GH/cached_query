import 'package:cached_query/src/global_cache.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cached_query/cached_query.dart';

import 'repos/cached_query_test_repo.dart';

void main() {
  final repo = CachedQueryTestRepo();
  tearDownAll(() => GlobalCache.instance.invalidateCache());
  test("test invalidation from client side", () async {
    final query = await repo.getTimeQuery();
    GlobalCache.instance.invalidateCache(key: 'timeQuery');
    final query2 = await repo.getTimeQuery();
    expect(query2, isNot(same(query)));
  });

  group("Standard Query Future", () {
    tearDown(() => GlobalCache.instance.invalidateCache());
    test("getting a query twice returns the same instance", () async {
      final query = await repo.getTimeQuery();
      final query2 = await repo.getTimeQuery();
      expect(query2, same(query));
    });
    test("when data is stale a re-fetch happens", () async {
      final query = await repo.getTimeQuery();
      await Future.delayed(const Duration(seconds: 2));
      final query2 = await repo.getTimeQuery();
      expect(query2, isNot(same(query)));
    });
  });
  group("streamed query with background fetching", () {
    test("getting a query has a loading state", () async {
      List<Query<String>> result = [];
      Stream<Query<String>> queryStream = repo.streamTimeQuery();
      await for (Query<String> s in queryStream) {
        result.add(s);
      }

      expect(result[0].isFetching, equals(true));
      expect(result[0].data, isNull);
      expect(result[1].isFetching, equals(false));
      expect(result[1].data, isNotNull);
    });
    test("after data is stale do a background fetch", () async {
      // populate the data with get function
      await repo.getTimeQuery();
      await Future.delayed(const Duration(seconds: 2));
      List<Query<String>> result = [];
      Stream<Query<String>> queryStream = repo.streamTimeQuery();
      await for (Query<String> s in queryStream) {
        result.add(s);
      }
      expect(result[0].isFetching, equals(true));
      expect(result[0].data, isNotNull);
    });
  });
}

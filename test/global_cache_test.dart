import 'dart:convert';

import 'package:cached_query/src/global_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GlobalCache globalCache;
  setUp(() {
    globalCache = GlobalCache.asNewInstance();
  });
  group("Creating and invalidating cache.", () {
    test("create new instance of a query then retrieve it", () {
      String key = "testKey";
      // create a new instance
      final firstQuery = globalCache.getQuery<String>(
          key: key,
          queryFn: () async => Future.value(''),
          staleTime: Duration.zero,
          cacheTime: Duration.zero);

      final secondQuery = globalCache.getQuery<String>(
          key: key,
          queryFn: () async => Future.value(''),
          staleTime: Duration.zero,
          cacheTime: Duration.zero);

      expect(firstQuery, same(secondQuery));
    });
    test("invalidate cache at a key", () {
      String key = "testKey";
      // create a new instance
      final firstQuery = globalCache.getQuery<String>(
          key: key,
          queryFn: () async => Future.value(''),
          staleTime: Duration.zero,
          cacheTime: Duration.zero);

      // invalidate the first query
      globalCache.invalidateCache(queryHash: jsonEncode(firstQuery.key));

      // create a new query with the same key
      final secondQuery = globalCache.getQuery<String>(
          key: key,
          queryFn: () async => Future.value(''),
          staleTime: Duration.zero,
          cacheTime: Duration.zero);

      expect(firstQuery, isNot(secondQuery));
    });
  });

  // first time create a new query

  // retrieve the previous query
}

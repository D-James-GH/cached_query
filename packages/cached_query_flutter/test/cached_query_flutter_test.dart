import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_query.dart';

void main() {
  setUpAll(WidgetsFlutterBinding.ensureInitialized);
  tearDown(CachedQuery.instance.reset);
  group("Refetch current queries", () {
    test("Can set refetch config per query", () async {
      final cache = CachedQuery.asNewInstance();
      final tester1 = QueryTester(
        cache: cache,
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnConnection: false,
          refetchOnResume: true,
        ),
      )..query.stream.listen((_) {});
      final tester2 = QueryTester(
        cache: cache,
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnConnection: true,
          refetchOnResume: false,
        ),
      )..query.stream.listen((_) {});
      final tester3 = QueryTester(
        cache: cache,
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnConnection: true,
          refetchOnResume: true,
        ),
      )..query.stream.listen((_) {});
      final tester4 = QueryTester(
        cache: cache,
        config: const QueryConfigFlutter(
          refetchOnConnection: true,
          refetchOnResume: true,
        ),
      )..query.stream.listen((_) {});
      await Future.wait([
        tester1.query.fetch(),
        tester2.query.fetch(),
        tester3.query.fetch(),
        tester4.query.fetch(),
      ]);
      await cache.onResume();
      await cache.onConnection();
      expect(tester1.numFetches, 2);
      expect(tester2.numFetches, 2);
      expect(tester3.numFetches, 3);
      // not stale, so no refetch
      expect(tester4.numFetches, 1);
    });

    test("Can override global config", () {
      final cache = CachedQuery.asNewInstance()
        ..configFlutter(
          config: const GlobalQueryConfigFlutter(refetchOnResume: false),
        );
      final q = Query<String>(
        cache: cache,
        key: "global",
        queryFn: () async => "",
        config: const QueryConfigFlutter(refetchOnResume: true),
      );
      expect((q.config as QueryConfigFlutter).refetchOnResume, true);
    });
  });
  group("Refetch onConnection and resumed", () {
    test('On connection will only fetch queries with listeners', () async {
      final cache = CachedQuery.asNewInstance()..configFlutter();
      int listenerFetches = 0;
      final queryWithListener = Query<String>(
        cache: cache,
        key: "withListener",
        queryFn: () async {
          listenerFetches++;
          return "data";
        },
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnConnection: true,
        ),
      );
      final subListener = queryWithListener.stream.listen((_) {});

      int noListenerFetches = 0;
      final queryWithoutListener = Query<String>(
        cache: cache,
        key: "withoutListener",
        queryFn: () async {
          noListenerFetches++;
          return "data";
        },
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnConnection: true,
        ),
      );
      final subNoListener = queryWithoutListener.stream.listen((_) {});
      await Future.wait([
        queryWithListener.fetch(),
        queryWithoutListener.fetch(),
      ]);
      await subNoListener.cancel();

      await cache.onConnection();
      expect(listenerFetches, 2);
      expect(noListenerFetches, 1);
      await subListener.cancel();
    });

    test("On resume will only fetch queries with listeners", () async {
      final cache = CachedQuery.asNewInstance()..configFlutter();
      int listenerFetches = 0;
      final queryWithListener = Query<String>(
        cache: cache,
        key: "withListener",
        queryFn: () async {
          listenerFetches++;
          return "data";
        },
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnResume: true,
        ),
      );
      final subListener = queryWithListener.stream.listen((_) {});

      int noListenerFetches = 0;
      final queryWithoutListener = Query<String>(
        cache: cache,
        key: "withoutListener",
        queryFn: () async {
          noListenerFetches++;
          return "data";
        },
        config: const QueryConfigFlutter(
          staleDuration: Duration.zero,
          refetchOnResume: true,
        ),
      );
      final subNoListener = queryWithoutListener.stream.listen((_) {});
      await Future.wait([
        queryWithListener.fetch(),
        queryWithoutListener.fetch(),
      ]);
      await subNoListener.cancel();

      await cache.onResume();
      expect(listenerFetches, 2);
      expect(noListenerFetches, 1);
      await subListener.cancel();
    });
  });
}

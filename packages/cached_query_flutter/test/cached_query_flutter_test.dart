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
}

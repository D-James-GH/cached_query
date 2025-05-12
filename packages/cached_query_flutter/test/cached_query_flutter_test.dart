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
          refetchDuration: Duration.zero,
          refetchOnConnection: false,
          refetchOnResume: true,
        ),
      )..query.stream.listen((_) {});
      final tester2 = QueryTester(
        cache: cache,
        config: const QueryConfigFlutter(
          refetchDuration: Duration.zero,
          refetchOnConnection: true,
          refetchOnResume: false,
        ),
      )..query.stream.listen((_) {});
      final tester3 = QueryTester(
        cache: cache,
        config: const QueryConfigFlutter(
          refetchDuration: Duration.zero,
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
      await cache.refetchCurrentQueries(RefetchReason.resume);
      await cache.refetchCurrentQueries(RefetchReason.connectivity);
      expect(tester1.numFetches, 2);
      expect(tester2.numFetches, 2);
      expect(tester3.numFetches, 3);
      // not stale, so no refetch
      expect(tester4.numFetches, 1);
    });

    test(
        "Can prevent refetchOnResume and refetchOnConnection using shouldRefetch",
        () async {
      final cache = CachedQuery.asNewInstance();
      bool shouldFetch = true;
      final tester = QueryTester(
        cache: cache,
        config: QueryConfigFlutter(
          shouldFetch: (_, __, ___) => shouldFetch,
          refetchOnConnection: true,
          refetchOnResume: true,
          refetchDuration: const Duration(milliseconds: 300),
        ),
      );
      await tester.query.fetch();
      final stream = tester.query.stream.listen((_) {});

      shouldFetch = false;

      await Future<void>.delayed(const Duration(milliseconds: 350));

      await cache.refetchCurrentQueries(RefetchReason.resume);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await cache.refetchCurrentQueries(RefetchReason.connectivity);

      expect(tester.numFetches, 1);
      await stream.cancel();
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

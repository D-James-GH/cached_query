import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_query.dart';

void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });
  tearDown(CachedQuery.instance.reset);
  group("Refetch current queries", () {
    test("Should refetch query if hasListeners", () async {
      final cache = CachedQuery.asNewInstance();
      final tester = QueryTester(cache: cache);
      final stream = tester.query.stream.listen((_) {});
      await tester.query.result;

      await cache.refetchCurrentQueries();

      expect(tester.numFetches, 2);
      await stream.cancel();
    });
    test("Should refetch infinite query if hasListeners", () async {
      final cache = CachedQuery.asNewInstance();
      final tester = QueryTester.infinite(cache: cache);
      final stream = tester.query.stream.listen((_) {});
      await tester.query.result;

      await cache.refetchCurrentQueries();

      expect(tester.numFetches, 2);
      await stream.cancel();
    });
    test("Should ignore infinite query if not hasListeners", () async {
      final cache = CachedQuery.asNewInstance();
      final tester = QueryTester.infinite(cache: cache);
      await tester.query.result;

      await cache.refetchCurrentQueries();

      expect(tester.numFetches, 1);
    });

    test("Can set refetch config per query", () async {
      final cache = CachedQuery.asNewInstance();
      final tester1 = QueryTester(
        cache: cache,
        config: QueryConfigFlutter(
          refetchOnConnection: false,
          //ignore: avoid_redundant_argument_values
          refetchOnResume: true,
        ),
      )..query.stream.listen((_) {});
      final tester2 = QueryTester(
        cache: cache,
        config: QueryConfigFlutter(
          //ignore: avoid_redundant_argument_values
          refetchOnConnection: true,
          refetchOnResume: false,
        ),
      )..query.stream.listen((_) {});
      final tester3 = QueryTester(
        cache: cache,
        config: QueryConfigFlutter(
          //ignore: avoid_redundant_argument_values
          refetchOnConnection: true,
          //ignore: avoid_redundant_argument_values
          refetchOnResume: true,
        ),
      )..query.stream.listen((_) {});
      await Future.wait([
        tester1.query.result,
        tester2.query.result,
        tester3.query.result,
      ]);
      await cache.refetchCurrentQueries(RefetchReason.resume);
      await cache.refetchCurrentQueries(RefetchReason.connectivity);
      expect(tester1.numFetches, 2);
      expect(tester2.numFetches, 2);
      expect(tester3.numFetches, 3);
    });

    test(
        "Can prevent refetchOnResume and refetchOnConnection using shouldRefetch",
        () async {
      final cache = CachedQuery.asNewInstance();
      final tester = QueryTester(
        cache: cache,
        config: QueryConfigFlutter(shouldRefetch: (_, __) => false),
      );
      await tester.query.result;
      final stream = tester.query.stream.listen((_) {});

      await cache.refetchCurrentQueries(RefetchReason.resume);
      await cache.refetchCurrentQueries(RefetchReason.connectivity);

      expect(tester.numFetches, 1);
      await stream.cancel();
    });
    test("Can override global config", () {
      final cache = CachedQuery.asNewInstance()
        ..configFlutter(
          config: QueryConfigFlutter(refetchOnResume: false),
        );
      final q = Query<String>(
        cache: cache,
        key: "global",
        queryFn: () async => "",
        config: QueryConfigFlutter(),
      );
      expect((q.config as QueryConfigFlutter).refetchOnResume, true);
    });
  });
}

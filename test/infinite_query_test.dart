import 'package:cached_query/src/global_cache.dart';
import 'package:flutter_test/flutter_test.dart';

import 'repos/infinite_query_test_repo.dart';

void main() async {
  final repo = InfiniteQueryTestRepository();

  setUpAll(() => GlobalCache.instance.invalidateCache());
  group("infinite query", () {
    test("first fetch", () async {
      final result = await repo.getPage();
      expect(result.data, equals(["page: 1"]));
    });
    // test("second fetch is cached", () async {
    //   final result = await repo.getPage();
    //   final stopwatch = Stopwatch()..start();
    //   final result2 = await repo.getPage();
    //   stopwatch.stop();
    //   // second request is cached so it should take less time that future.delayed
    //   // specified in the repo
    //   expect(const Duration(milliseconds: 500).compareTo(stopwatch.elapsed),
    //       greaterThan(0));
    // });
    test("next page should return one query", () async {
      GlobalCache.instance.invalidateCache();
      final res = await repo.getPage();
      final nextPage = await res.getNextPage();
      expect(nextPage.data, equals(["page: 1", "page: 2"]));
    });
    test("data list should be updated after getNextPage", () async {});
  });
}

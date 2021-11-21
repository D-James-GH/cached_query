import 'package:flutter_test/flutter_test.dart';

import 'package:cached_query/cached_query.dart';

import 'repos/cached_query_test_repo.dart';

void main() {
  final repo = CachedQueryTestRepo();
  tearDownAll(() => GlobalCache.instance.invalidateCache());
  test("test invalidation from client side", () async {});

  group("Standard Query Future", () {});
  group("streamed query with background fetching", () {});
}

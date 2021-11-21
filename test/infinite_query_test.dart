import 'package:cached_query/cached_query.dart';
import 'package:flutter_test/flutter_test.dart';

import 'repos/infinite_query_test_repo.dart';

void main() async {
  final repo = InfiniteQueryTestRepository();

  setUpAll(() => GlobalCache.instance.invalidateCache());
  group("infinite query", () {});
}

import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {});
  group("Config", () {
    test("Should be able to set config", () {
      final cachedQuery = CachedQuery.asNewInstance()
        ..config(config: QueryConfig());
      expect(cachedQuery.isConfigSet, true);
    });
    // test("Should be able to set the refetch")
  });
  group("Invalidate cache.", () {});

  // first time create a new query

  // retrieve the previous query
}

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/default_query_config.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {});
  group("Config", () {
    test("Should be able to set config", () {
      final cachedQuery = CachedQuery.asNewInstance()
        ..config(config: const QueryConfig());
      expect(cachedQuery.isConfigSet, true);
    });
    test("Should be able to merge query config with default config", () {
      const config = QueryConfig(
        cacheDuration: Duration.zero,
        ignoreCacheDuration: true,
      );
      final merged = DefaultQueryConfig().merge(config);
      expect(merged.cacheDuration, Duration.zero);
      expect(merged.storeQuery, DefaultQueryConfig().storeQuery);
    });
    test("Should be able to override default values", () async {
      final defaultConfig = DefaultQueryConfig();
      const config = QueryConfig(
        storeQuery: false,
        shouldRethrow: true,
        refetchDuration: Duration.zero,
        cacheDuration: Duration.zero,
        ignoreCacheDuration: true,
      );
      final cachedQuery = CachedQuery.asNewInstance()..config(config: config);
      expect(cachedQuery.defaultConfig, defaultConfig.merge(config));
    });
  });

  group("Invalidate cache.", () {});

  // first time create a new query

  // retrieve the previous query
}

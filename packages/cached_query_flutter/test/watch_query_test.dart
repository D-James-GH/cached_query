import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap({required CachedQuery cache, required Widget child}) {
  return CachedQueryProvider(
    cache: cache,
    child: MaterialApp(home: child),
  );
}

class _WatchWidget extends StatelessWidget {
  final Query<String> query;
  final bool enabled;
  final QueryBuilderCondition<QueryStatus<String>>? buildWhen;
  final void Function()? onBuild;

  const _WatchWidget({
    required this.query,
    this.enabled = true,
    this.buildWhen,
    this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    onBuild?.call();
    final state = context.watchQuery<String>(
      query: query,
      enabled: enabled,
      buildWhen: buildWhen,
    );
    if (state.data == null) return const SizedBox(key: Key('empty'));
    return Text(state.data!, key: const Key('data'));
  }
}

class _WatchByKeyWidget extends StatelessWidget {
  final Object queryKey;
  final CachedQuery cache;

  const _WatchByKeyWidget({required this.queryKey, required this.cache});

  @override
  Widget build(BuildContext context) {
    final state = context.watchQuery<String>(key: queryKey);
    if (state.data == null) return const SizedBox(key: Key('empty'));
    return Text(state.data!, key: const Key('data'));
  }
}

void main() {
  group('watchQuery', () {
    late CachedQuery cache;

    setUp(() {
      cache = CachedQuery.asNewInstance()
        ..config(
          config: const GlobalQueryConfig(ignoreCacheDuration: true),
        );
    });

    tearDown(() async {
      await cache.dispose();
    });

    testWidgets('renders initial loading state then data', (tester) async {
      final query = Query<String>(
        cache: cache,
        key: 'test',
        queryFn: () async => 'hello',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(_wrap(cache: cache, child: _WatchWidget(query: query)));
      expect(find.byKey(const Key('empty')), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('rebuilds twice: loading then success', (tester) async {
      int buildCount = 0;
      final query = Query<String>(
        cache: cache,
        key: 'test',
        queryFn: () async => 'hello',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: _WatchWidget(
            query: query,
            onBuild: () => buildCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(buildCount, 2);
    });

    testWidgets('buildWhen prevents extra rebuild', (tester) async {
      int buildCount = 0;
      final query = Query<String>(
        cache: cache,
        key: 'test',
        queryFn: () async => 'hello',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: _WatchWidget(
            query: query,
            buildWhen: (_, __) => false,
            onBuild: () => buildCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(buildCount, 1);
    });

    testWidgets('enabled false — returns snapshot, no fetch triggered',
        (tester) async {
      int buildCount = 0;
      final query = Query<String>(
        cache: cache,
        key: 'test',
        queryFn: () async => 'hello',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: _WatchWidget(
            query: query,
            enabled: false,
            onBuild: () => buildCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(buildCount, 1);
      expect(find.byKey(const Key('empty')), findsOneWidget);
    });

    testWidgets('key-only lookup uses cache; creates empty query if missing',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: _WatchByKeyWidget(queryKey: 'missing', cache: cache),
        ),
      );
      await tester.pumpAndSettle();
      // Empty query created — stays in initial/loading state (no queryFn)
      expect(find.byKey(const Key('empty')), findsOneWidget);
      expect(cache.getQuery('missing'), isNotNull);
    });

    testWidgets('key-only lookup finds existing query', (tester) async {
      Query<String>(
        cache: cache,
        key: 'existing',
        queryFn: () async => 'found',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: _WatchByKeyWidget(queryKey: 'existing', cache: cache),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('found'), findsOneWidget);
    });

    testWidgets(
        'subscription cancelled when widget removed; query loses listener',
        (tester) async {
      final query = Query<String>(
        cache: cache,
        key: 'test',
        queryFn: () async => 'hello',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(cache: cache, child: _WatchWidget(query: query)),
      );
      await tester.pumpAndSettle();
      expect(query.hasListener, isTrue);

      // Replace widget tree to unmount _WatchWidget
      await tester.pumpWidget(
        _wrap(cache: cache, child: const SizedBox()),
      );
      await tester.pumpAndSettle();
      expect(query.hasListener, isFalse);
    });

    testWidgets('two widgets watching same query — one stream subscription',
        (tester) async {
      int buildCountA = 0;
      int buildCountB = 0;
      final query = Query<String>(
        cache: cache,
        key: 'shared',
        queryFn: () async => 'shared-data',
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: Column(
            children: [
              _WatchWidget(query: query, onBuild: () => buildCountA++),
              _WatchWidget(query: query, onBuild: () => buildCountB++),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Both built twice (loading + success)
      expect(buildCountA, 2);
      expect(buildCountB, 2);
    });
  });

  group('watchInfiniteQuery', () {
    late CachedQuery cache;

    setUp(() {
      cache = CachedQuery.asNewInstance()
        ..config(
          config: const GlobalQueryConfig(ignoreCacheDuration: true),
        );
    });

    tearDown(() async {
      await cache.dispose();
    });

    testWidgets('renders initial loading state then data', (tester) async {
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: 'infinite',
        queryFn: (page) async => 'page-$page',
        getNextArg: (data) => data?.args.lastOrNull ?? 0,
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: Builder(
            builder: (context) {
              final state =
                  context.watchInfiniteQuery<String, int>(query: query);
              if (state.data == null) return const SizedBox(key: Key('empty'));
              return Text(
                state.data?.pages.first ?? '',
                key: const Key('data'),
              );
            },
          ),
        ),
      );
      expect(find.byKey(const Key('empty')), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('page-0'), findsOneWidget);
    });

    testWidgets(
        'subscription cancelled when widget removed; query loses listener',
        (tester) async {
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: 'infinite',
        queryFn: (page) async => 'page-$page',
        getNextArg: (data) => data?.args.lastOrNull ?? 0,
        config: const QueryConfig(
          staleDuration: Duration.zero,
          ignoreCacheDuration: true,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          cache: cache,
          child: Builder(
            builder: (context) {
              context.watchInfiniteQuery<String, int>(query: query);
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(query.hasListener, isTrue);

      await tester.pumpWidget(
        _wrap(cache: cache, child: const SizedBox()),
      );
      await tester.pumpAndSettle();
      expect(query.hasListener, isFalse);
    });
  });
}

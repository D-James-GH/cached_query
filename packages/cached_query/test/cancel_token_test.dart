import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

void main() {
  group('CancelToken', () {
    test('cancel completes whenCancelled and sets reason', () {
      final token = CancelToken();
      expect(token.isCancelled, isFalse);

      token.cancel('user navigated away');

      expect(token.isCancelled, isTrue);
      expect(token.reason, 'user navigated away');
      expect(token.whenCancelled, completes);
    });

    test('throwIfCancelled throws QueryCancelledException', () {
      final token = CancelToken()..cancel('reason');

      expect(
        token.throwIfCancelled,
        throwsA(isA<QueryCancelledException>()),
      );
    });

    test('cancel is de-duped', () {
      final token = CancelToken()
        ..cancel('first')
        ..cancel('second');

      expect(token.reason, 'first');
    });
  });

  group('Query cancellation', () {
    test('currentCancelToken is non-null inside queryFn and null outside',
        () async {
      final cache = CachedQuery.asNewInstance();
      CancelToken? tokenInFn;

      expect(cache.currentCancelToken, isNull);

      final query = Query<String>(
        key: 'token-ambient',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          tokenInFn = cache.currentCancelToken;
          return 'data';
        },
      );

      await query.fetch();

      expect(tokenInFn, isNotNull);
      expect(cache.currentCancelToken, isNull);
    });

    test('manual cancel reverts to previous QuerySuccess state', () async {
      final cache = CachedQuery.asNewInstance();
      final fetchBlocked = Completer<void>();
      var fetchCount = 0;

      final query = Query<String>(
        key: 'cancel-success',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          fetchCount++;
          if (fetchCount == 1) {
            return 'original';
          }
          await fetchBlocked.future;
          return 'new data';
        },
      );

      await query.fetch();
      expect(query.state, isA<QuerySuccess<String>>());
      expect(query.state.data, 'original');

      final refetchFuture = query.refetch();
      await Future<void>.delayed(Duration.zero);
      expect(query.state.isLoading, isTrue);

      query.cancel('manual');
      fetchBlocked.complete();
      await refetchFuture;

      expect(query.state, isA<QuerySuccess<String>>());
      expect(query.state.data, 'original');
      expect(query.state.isError, isFalse);
    });

    test('manual cancel reverts to previous QueryError state', () async {
      final cache = CachedQuery.asNewInstance();
      final fetchBlocked = Completer<void>();
      var fetchCount = 0;
      final firstError = Exception('first error');

      final query = Query<String>(
        key: 'cancel-error',
        cache: cache,
        config: QueryConfig(
          staleDuration: Duration.zero,
          retryConfig: RetryConfig(maxRetries: 0),
        ),
        queryFn: () async {
          fetchCount++;
          if (fetchCount == 1) {
            throw firstError;
          }
          await fetchBlocked.future;
          return 'should not apply';
        },
      );

      await query.fetch();
      expect(query.state, isA<QueryError<String>>());
      final errorState = query.state as QueryError<String>;
      expect(errorState.error, firstError);

      final refetchFuture = query.refetch();
      await Future<void>.delayed(Duration.zero);
      expect(query.state.isLoading, isTrue);

      query.cancel('manual');
      fetchBlocked.complete();
      await refetchFuture;

      expect(query.state, isA<QueryError<String>>());
      final reverted = query.state as QueryError<String>;
      expect(reverted.error, firstError);
      expect(reverted.stackTrace, errorState.stackTrace);
    });

    test('cancel does not trigger retries', () async {
      final cache = CachedQuery.asNewInstance();
      var fetchCount = 0;
      final blockRelease = Completer<void>();

      final query = Query<String>(
        key: 'cancel-no-retry',
        cache: cache,
        config: QueryConfig(
          staleDuration: Duration.zero,
          retryConfig: RetryConfig(
            maxRetries: 3,
            delay: (_) => const Duration(seconds: 1),
          ),
        ),
        queryFn: () async {
          fetchCount++;
          await blockRelease.future;
          throw Exception('fail');
        },
      );

      final fetchFuture = query.fetch();
      await Future<void>.delayed(Duration.zero);
      expect(fetchCount, 1);

      query.cancel('stop retries');
      blockRelease.complete();
      await fetchFuture;

      expect(fetchCount, 1);
      expect(query.state.isError, isFalse);
    });

    test('deduped queries share one cancel', () async {
      final cache = CachedQuery.asNewInstance();
      final fetchBlocked = Completer<void>();
      var fetchCount = 0;

      final query1 = Query<String>(
        key: 'dedupe-cancel',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          fetchCount++;
          await fetchBlocked.future;
          return 'data';
        },
      );
      final query2 = Query<String>(
        key: 'dedupe-cancel',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          fetchCount++;
          await fetchBlocked.future;
          return 'data';
        },
      );

      final f1 = query1.fetch();
      final f2 = query2.fetch();
      await Future<void>.delayed(Duration.zero);
      expect(fetchCount, 1);

      query1.cancel('shared cancel');
      fetchBlocked.complete();
      await Future.wait([f1, f2]);

      expect(fetchCount, 1);
      expect(query1.state.isLoading, isFalse);
      expect(query2.state.isLoading, isFalse);
    });

    test('non-cooperative queryFn discards result when cancelled', () async {
      final cache = CachedQuery.asNewInstance();
      final fetchBlocked = Completer<void>();
      var fetchCount = 0;

      final query = Query<String>(
        key: 'non-cooperative',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          fetchCount++;
          if (fetchCount == 1) {
            return 'original';
          }
          await fetchBlocked.future;
          return 'ignored result';
        },
      );

      await query.fetch();
      expect(query.state.data, 'original');

      final refetchFuture = query.refetch();
      await Future<void>.delayed(Duration.zero);

      query.cancel('too late for cooperative abort');
      fetchBlocked.complete();
      await refetchFuture;

      expect(fetchCount, 2);
      expect(query.state.data, 'original');
      expect(query.state, isA<QuerySuccess<String>>());
    });

    test('CachedQuery.cancelQueries cancels by key', () async {
      final cache = CachedQuery.asNewInstance();
      final fetchBlocked = Completer<void>();

      final query = Query<String>(
        key: 'cancel-by-key',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          await fetchBlocked.future;
          return 'data';
        },
      );

      final fetchFuture = query.fetch();
      await Future<void>.delayed(Duration.zero);

      cache.cancelQueries(key: 'cancel-by-key', reason: 'batch cancel');
      fetchBlocked.complete();
      await fetchFuture;

      expect(query.state.isLoading, isFalse);
    });

    test('cancelQueries only cancels matching key during concurrent fetches',
        () async {
      final cache = CachedQuery.asNewInstance();
      final cancelledStarted = Completer<void>();
      final notCancelledStarted = Completer<void>();
      final cancelledBlocked = Completer<void>();
      final notCancelledBlocked = Completer<void>();
      CancelToken? cancelledToken;
      CancelToken? notCancelledToken;

      final cancelledQuery = Query<String>(
        key: 'cancelled',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          cancelledToken = cache.currentCancelToken;
          cancelledStarted.complete();
          await cancelledBlocked.future;
          return 'cancelled data';
        },
      );
      final notCancelledQuery = Query<String>(
        key: 'not-cancelled',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          notCancelledToken = cache.currentCancelToken;
          notCancelledStarted.complete();
          await notCancelledBlocked.future;
          return 'not cancelled data';
        },
      );

      final cancelledFuture = cancelledQuery.fetch();
      final notCancelledFuture = notCancelledQuery.fetch();
      await Future.wait([
        cancelledStarted.future,
        notCancelledStarted.future,
      ]);

      cache.cancelQueries(key: 'cancelled', reason: 'only cancelled');

      expect(cancelledToken?.isCancelled, isTrue);
      expect(notCancelledToken?.isCancelled, isFalse);

      cancelledBlocked.complete();
      notCancelledBlocked.complete();
      await Future.wait([
        cancelledFuture,
        notCancelledFuture,
      ]);

      expect(cancelledQuery.state.isSuccess, isFalse);
      expect(notCancelledQuery.state, isA<QuerySuccess<String>>());
      expect(notCancelledQuery.state.data, 'not cancelled data');
    });

    test('cooperative throwIfCancelled aborts queryFn', () async {
      final cache = CachedQuery.asNewInstance();
      final fetchStarted = Completer<void>();

      final query = Query<String>(
        key: 'cooperative',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: () async {
          fetchStarted.complete();
          for (var i = 0; i < 100; i++) {
            cache.currentCancelToken?.throwIfCancelled();
            await Future<void>.delayed(const Duration(milliseconds: 10));
          }
          return 'never';
        },
      );

      final fetchFuture = query.fetch();
      await fetchStarted.future;
      query.cancel('cooperative');
      await fetchFuture;

      expect(query.state.isError, isFalse);
      expect(query.state.isLoading, isFalse);
    });
  });

  group('InfiniteQuery cancellation', () {
    test('currentCancelToken is available inside infinite queryFn', () async {
      final cache = CachedQuery.asNewInstance();
      CancelToken? tokenInFn;

      final query = InfiniteQuery<String, int>(
        key: 'infinite-token',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: (arg) async {
          tokenInFn ??= cache.currentCancelToken;
          return 'page-$arg';
        },
        getNextArg: (_) => 1,
      );

      await query.fetch();

      expect(tokenInFn, isNotNull);
    });

    test('cancel during getNextPage reverts to previous success state',
        () async {
      final cache = CachedQuery.asNewInstance();
      final blocked = Completer<void>();

      final query = InfiniteQuery<String, int>(
        key: 'cancel-next-page',
        cache: cache,
        queryFn: (arg) async {
          if (arg == 2) {
            await blocked.future;
          }
          return 'page-$arg';
        },
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );

      await query.fetch();
      expect(query.state.data!.pages, ['page-1']);

      final nextFuture = query.getNextPage();
      await Future<void>.delayed(Duration.zero);
      expect(query.state.isLoading, isTrue);

      query.cancel('manual');
      blocked.complete();
      await nextFuture;

      expect(query.state.data!.pages, ['page-1']);
      expect(query.state.isSuccess, isTrue);
    });

    test('cancel during multi-page refetch reverts without partial pages',
        () async {
      final cache = CachedQuery.asNewInstance();
      final blocked = Completer<void>();
      final refetchOnSecondPage = Completer<void>();
      var fetchCount = 0;

      final query = InfiniteQuery<String, int>(
        key: 'cancel-refetch',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: (arg) async {
          fetchCount++;
          if (fetchCount <= 2) {
            return 'page-$arg';
          }
          if (fetchCount == 3) {
            return 'refetched-$arg';
          }
          refetchOnSecondPage.complete();
          await blocked.future;
          return 'refetched-$arg';
        },
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );

      await query.fetch();
      await query.getNextPage();
      expect(query.state.data!.pages, ['page-1', 'page-2']);
      expect(query.state.isSuccess, isTrue);

      final refetchFuture = query.refetch();
      await refetchOnSecondPage.future;

      query.cancel('stop refetch');
      blocked.complete();
      await refetchFuture;

      expect(query.state.data!.pages, ['page-1', 'page-2']);
      expect(query.state.isSuccess, isTrue);
    });

    test('cancel reverts to previous InfiniteQueryError state', () async {
      final cache = CachedQuery.asNewInstance();
      final blocked = Completer<void>();
      var fetchCount = 0;
      final firstError = Exception('first error');

      final query = InfiniteQuery<String, int>(
        key: 'cancel-infinite-error',
        cache: cache,
        config: QueryConfig(
          staleDuration: Duration.zero,
          retryConfig: RetryConfig(maxRetries: 0),
        ),
        queryFn: (arg) async {
          fetchCount++;
          if (fetchCount == 1) {
            throw firstError;
          }
          await blocked.future;
          return 'ignored';
        },
        getNextArg: (_) => 1,
      );

      await query.fetch();
      expect(query.state, isA<InfiniteQueryError<String, int>>());
      final errorState = query.state as InfiniteQueryError<String, int>;

      final refetchFuture = query.refetch();
      await Future<void>.delayed(Duration.zero);

      query.cancel('manual');
      blocked.complete();
      await refetchFuture;

      expect(query.state, isA<InfiniteQueryError<String, int>>());
      final reverted = query.state as InfiniteQueryError<String, int>;
      expect(reverted.error, firstError);
      expect(reverted.stackTrace, errorState.stackTrace);
    });

    test('CachedQuery.cancelQueries cancels infinite query by key', () async {
      final cache = CachedQuery.asNewInstance();
      final blocked = Completer<void>();

      final query = InfiniteQuery<String, int>(
        key: 'cancel-infinite-by-key',
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        queryFn: (_) async {
          await blocked.future;
          return 'page';
        },
        getNextArg: (_) => 1,
      );

      final fetchFuture = query.fetch();
      await Future<void>.delayed(Duration.zero);

      cache.cancelQueries(key: 'cancel-infinite-by-key', reason: 'batch');
      blocked.complete();
      await fetchFuture;

      expect(query.state.isLoading, isFalse);
    });
  });
}

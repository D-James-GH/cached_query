import 'package:cached_query/cached_query.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

const _staleDuration = Duration(minutes: 5);

void main() {
  group("invalidation", () {
    test("a failed refetch keeps the query invalidated", () {
      fakeAsync((async) {
        final cache = CachedQuery.asNewInstance();
        var fail = false;
        final query = Query<int>(
          key: "failed refetch",
          cache: cache,
          config: QueryConfig(staleDuration: _staleDuration),
          queryFn: () async {
            if (fail) throw Exception("network");
            return 1;
          },
        );
        final sub = query.stream.listen((_) {});
        async.flushMicrotasks();
        expect(query.stale, isFalse);

        fail = true;
        cache.invalidateCache(key: "failed refetch");
        async.flushMicrotasks();

        expect(query.state, isA<QueryError<int>>());
        expect(query.state.data, 1);
        expect(query.stale, isTrue);
        sub.cancel();
      });
    });

    test("a refetch that fails after all retries keeps the query invalidated",
        () {
      fakeAsync((async) {
        final cache = CachedQuery.asNewInstance();
        var fail = false;
        var fetches = 0;
        final query = Query<int>(
          key: "failed retries",
          cache: cache,
          config: QueryConfig(
            staleDuration: _staleDuration,
            retryConfig: RetryConfig(maxRetries: 2),
          ),
          queryFn: () async {
            fetches++;
            if (fail) throw Exception("network");
            return 1;
          },
        );
        final sub = query.stream.listen((_) {});
        async.flushMicrotasks();

        fail = true;
        query.invalidate();
        async.elapse(const Duration(seconds: 5));

        expect(fetches, 4);
        expect(query.state, isA<QueryError<int>>());
        expect(query.stale, isTrue);
        sub.cancel();
      });
    });

    test("a successful refetch clears the invalidation", () {
      fakeAsync((async) {
        final cache = CachedQuery.asNewInstance();
        final query = Query<int>(
          key: "successful refetch",
          cache: cache,
          config: QueryConfig(staleDuration: _staleDuration),
          queryFn: () async => 1,
        );
        final sub = query.stream.listen((_) {});
        async.flushMicrotasks();

        query.invalidate();
        async.flushMicrotasks();

        expect(query.stale, isFalse);
        sub.cancel();
      });
    });

    test("a failed infinite query refetch keeps the query invalidated", () {
      fakeAsync((async) {
        final cache = CachedQuery.asNewInstance();
        var fail = false;
        final query = InfiniteQuery<String, int>(
          key: "infinite failed refetch",
          cache: cache,
          config: QueryConfig(staleDuration: _staleDuration),
          getNextArg: (data) => (data?.pages.length ?? 0) + 1,
          queryFn: (arg) async {
            if (fail) throw Exception("network");
            return "page $arg";
          },
        );
        final sub = query.stream.listen((_) {});
        async.flushMicrotasks();

        fail = true;
        query.invalidate();
        async.flushMicrotasks();

        expect(query.state, isA<InfiniteQueryError<String, int>>());
        expect(query.stale, isTrue);
        sub.cancel();
      });
    });
  });
}

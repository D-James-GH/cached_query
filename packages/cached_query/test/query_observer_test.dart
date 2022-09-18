import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'observers/observers.dart';

void main() {
  group("Query observer", () {
    tearDown(CachedQuery.instance.reset);
    test("Can set query observer with config", () async {
      CachedQuery.instance.config(observer: SimpleObserver());
      expect(CachedQuery.instance.observer, isA<SimpleObserver>());
    });
    test("Creating a query is observed", () {
      QueryBase<dynamic, dynamic>? query;
      CachedQuery.instance.config(observer: CreationObserver((q) => query = q));
      Query(
        key: "query creation",
        queryFn: () => Future.value("res"),
      );
      expect(query, isA<Query<String>>());
    });
    test("Creating an infinite query is observed", () {
      QueryBase<dynamic, dynamic>? query;
      CachedQuery.instance.config(observer: CreationObserver((q) => query = q));
      InfiniteQuery<String, int>(
        key: "query creation",
        queryFn: (_) => Future.value("res"),
        getNextArg: (a) => 1,
      );
      expect(query, isA<InfiniteQuery<String, int>>());
    });
    test("Deleting an infinite query is observed", () {
      Object? key;
      CachedQuery.instance.config(observer: DeletionObserver((k) => key = k));
      InfiniteQuery<String, int>(
        key: "infiniteQueryKey",
        queryFn: (_) => Future.value("res"),
        getNextArg: (a) => 1,
      ).deleteQuery();
      expect(key, "infiniteQueryKey");
    });
    test("Deleting a query is observed", () {
      Object? key;
      CachedQuery.instance.config(observer: DeletionObserver((k) => key = k));
      Query<String>(
        key: "queryKey",
        queryFn: () => Future.value("res"),
      ).deleteQuery();
      expect(key, "queryKey");
    });
    test("Creating a mutation is observed", () {
      Mutation<dynamic, dynamic>? m;
      CachedQuery.instance.config(
        observer: MutationCreationObserver((mutation) => m = mutation),
      );
      final mutation = Mutation<String, void>(
        queryFn: (_) => Future.value("res"),
      );
      expect(m, same(mutation));
    });

    test("Creating a mutation with key is observed", () {
      Mutation<dynamic, dynamic>? m;
      CachedQuery.instance.config(
        observer: MutationCreationObserver((mutation) => m = mutation),
      );
      final mutation = Mutation<String, void>(
        key: "mutation",
        queryFn: (_) => Future.value("res"),
      );
      expect(m, same(mutation));
    });
    test("Should be called when a query is loading", () async {
      int count = 0;
      QueryBase<dynamic, dynamic>? queryChange;
      CachedQuery.instance.observer = QueryChangeObserver((query, nextState) {
        if (nextState.status == QueryStatus.loading) {
          queryChange = query;
          count++;
        }
      });
      final query = Query(
        key: "queryLoading",
        queryFn: () => Future.value("response"),
      );
      await query.result;
      expect(count, 1);
      expect(queryChange, isA<Query<String>>());
    });

    test("Should be called when a query succeeds", () async {
      int count = 0;
      QueryBase<dynamic, dynamic>? queryChange;
      CachedQuery.instance.observer = QueryChangeObserver((query, nextState) {
        if (nextState.status == QueryStatus.success) {
          queryChange = query;
          count++;
        }
      });
      final query = Query(
        key: "querySuccess",
        queryFn: () => Future.value("response"),
      );
      await query.result;
      expect(count, 1);
      expect(queryChange, isA<Query<String>>());
    });
    test("Should be called when a query fails", () async {
      int count = 0;
      StackTrace? trace;
      QueryBase<dynamic, dynamic>? queryError;
      CachedQuery.instance.observer = QueryFailObserver((query, stacktrace) {
        count++;
        queryError = query;
        trace = stacktrace;
      });
      final query = Query<String>(
        key: "queryFail",
        queryFn: () => throw "error",
      );
      await query.result;
      expect(count, 1);
      expect(trace, isA<StackTrace>());
      expect(queryError, isA<Query<String>>());
    });

    test("Should be called when a infinite query is fetching", () async {
      int count = 0;
      QueryBase<dynamic, dynamic>? queryChange;
      CachedQuery.instance.observer = QueryChangeObserver((query, next) {
        if (next.status == QueryStatus.loading) {
          queryChange = query;
          count++;
        }
      });
      final query = InfiniteQuery(
        key: "queryLoading",
        getNextArg: (p) => p.length + 1,
        queryFn: (a) => Future.value("response"),
      );
      await query.result;
      expect(count, 1);
      expect(queryChange, isA<InfiniteQuery<String, int>>());
    });
    test("Should be called when a infinite query has succeeded", () async {
      int count = 0;
      QueryBase<dynamic, dynamic>? queryChange;
      CachedQuery.instance.observer = QueryChangeObserver((query, next) {
        if (next.status == QueryStatus.success) {
          queryChange = query;
          count++;
        }
      });
      final query = InfiniteQuery(
        key: "querySuccess",
        getNextArg: (p) => p.length + 1,
        queryFn: (a) => Future.value("response"),
      );
      await query.result;
      expect(count, 1);
      expect(queryChange, isA<InfiniteQuery<String, int>>());
    });

    test("Should be called when a infinite query has failed", () async {
      int count = 0;
      QueryBase<dynamic, dynamic>? queryChange;
      StackTrace? trace;
      CachedQuery.instance.observer = QueryFailObserver((query, stackTrace) {
        trace = stackTrace;
        queryChange = query;
        count++;
      });
      final query = InfiniteQuery<String, int>(
        key: "queryFail",
        getNextArg: (p) => p.length + 1,
        queryFn: (a) => throw "error",
      );
      await query.result;
      expect(count, 1);
      expect(trace, isA<StackTrace>());
      expect(queryChange, isA<InfiniteQuery<String, int>>());
    });

    test('Should be called when a mutation is fetching', () async {
      int count = 0;
      CachedQuery.instance.observer = MutationObserver((mutation, next) {
        if (next.status == QueryStatus.loading) {
          count++;
        }
      });
      final mutation = Mutation<String, int>(
        queryFn: (a) => Future.value("response"),
      );
      await mutation.mutate(1);
      expect(count, 1);
    });
    test('Should be called when a mutation has failed', () async {
      int count = 0;
      StackTrace? stackTrace;
      CachedQuery.instance.observer = MutationErrorObserver((mutation, trace) {
        count++;
        stackTrace = trace;
      });
      final mutation = Mutation<String, int>(
        queryFn: (a) => throw "error",
      );
      await mutation.mutate(1);
      expect(count, 1);
      expect(stackTrace, isA<StackTrace>());
    });

    test('Should be called when a mutation has succeeded', () async {
      int count = 0;
      CachedQuery.instance.observer = MutationObserver((mutation, next) {
        if (next.status == QueryStatus.success) {
          count++;
        }
      });
      final mutation = Mutation<String, int>(
        queryFn: (a) => Future.value("response"),
      );
      await mutation.mutate(1);
      expect(count, 1);
    });
  });
}

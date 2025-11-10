import 'package:cached_query/cached_query.dart';

int _serial = 0;
const testQueryRes = 'result';

class QueryTester {
  late final Cacheable<dynamic> query;
  int _numFetches = 0;
  int get numFetches => _numFetches;

  QueryTester({
    QueryConfig<String>? config,
    String? key,
    String res = testQueryRes,
    void Function()? onFetch,
    CachedQuery? cache,
  }) {
    query = createQuery(
      key: key,
      config: config,
      cache: cache,
      res: res,
      onFetch: () {
        _numFetches++;
        onFetch?.call();
      },
    );
  }

  QueryTester.infinite({
    QueryConfig<InfiniteQueryData<String, int>>? config,
    String? key,
    String res = testQueryRes,
    void Function()? onFetch,
    CachedQuery? cache,
  }) {
    query = createInfiniteQuery(
      key: key,
      res: res,
      config: config,
      cache: cache,
      onFetch: () {
        _numFetches++;
        onFetch?.call();
      },
    );
  }
}

Query<String> createQuery({
  QueryConfig<String>? config,
  String? key,
  String res = testQueryRes,
  void Function()? onFetch,
  CachedQuery? cache,
}) {
  key ??= 'query_${_serial++}';
  return Query<String>(
    config: config,
    key: key,
    cache: cache,
    queryFn: () async {
      onFetch?.call();
      return res;
    },
  );
}

InfiniteQuery<String, int> createInfiniteQuery({
  QueryConfig<InfiniteQueryData<String, int>>? config,
  String? key,
  String res = testQueryRes,
  void Function()? onFetch,
  CachedQuery? cache,
}) {
  key ??= 'query_${_serial++}';
  return InfiniteQuery(
    cache: cache,
    config: config,
    key: key,
    getNextArg: (data) {
      return (data?.pages.length ?? 0) + 1;
    },
    queryFn: (arg) async {
      onFetch?.call();
      return "$res $arg";
    },
  );
}

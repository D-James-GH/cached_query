import 'package:cached_query/cached_query.dart';

int _serial = 0;
const _testQueryRes = 'result';

class QueryTester<T extends Cacheable<dynamic>> {
  late final T query;
  int _numFetches = 0;
  int get numFetches => _numFetches;

  QueryTester({
    QueryConfig<String>? config,
    String? key,
    String res = _testQueryRes,
    void Function()? onFetch,
    bool Function(int numFetches)? shouldThrow,
    CachedQuery? cache,
  }) {
    query = createQuery(
      key: key,
      config: config,
      cache: cache,
      res: res,
      onFetch: () {
        _numFetches++;
        if (shouldThrow != null && shouldThrow(_numFetches)) {
          throw Exception('Fetch error on fetch #$_numFetches');
        }
        onFetch?.call();
      },
    ) as T;
  }

  QueryTester.infinite({
    QueryConfig<InfiniteQueryData<String, int>>? config,
    String? key,
    String res = _testQueryRes,
    void Function()? onFetch,
    bool Function(int numFetches)? shouldThrow,
    CachedQuery? cache,
  }) {
    query = createInfiniteQuery(
      key: key,
      res: res,
      config: config,
      cache: cache,
      onFetch: () {
        _numFetches++;
        if (shouldThrow != null && shouldThrow(_numFetches)) {
          throw Exception('Fetch error on fetch #$_numFetches');
        }
        onFetch?.call();
      },
    ) as T;
  }
}

Query<String> createQuery({
  QueryConfig<String>? config,
  String? key,
  String res = _testQueryRes,
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
  String res = _testQueryRes,
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

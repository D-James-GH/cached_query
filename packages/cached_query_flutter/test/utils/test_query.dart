import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';

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

class TestStorage extends StorageInterface {
  final void Function(String key)? onGet;
  final void Function(StoredQuery query)? onPut;
  final void Function(String key)? onDelete;
  final void Function()? onDeleteAll;
  final void Function()? onClose;
  final Map<String, StoredQuery> queries = {};

  TestStorage({
    this.onClose,
    this.onGet,
    this.onPut,
    this.onDelete,
    this.onDeleteAll,
  });

  @override
  void close() {
    onClose?.call();
  }

  @override
  void delete(String key) {
    onDelete?.call(key);
    queries.remove(key);
  }

  @override
  void deleteAll() {
    onDeleteAll?.call();
    queries.clear();
  }

  @override
  FutureOr<StoredQuery?> get(String key) {
    onGet?.call(key);
    if (queries.containsKey(key)) {
      return queries[key];
    }
    return null;
  }

  @override
  void put(StoredQuery query) {
    onPut?.call(query);
    queries[query.key] = query;
  }
}

class Serializable {
  final String name;
  Serializable(this.name);

  factory Serializable.fromJson(Map<String, dynamic> json) =>
      Serializable(json['name'] as String);

  static List<Serializable> listFromJson(List<dynamic> json) => json
      .map((dynamic e) => Serializable.fromJson(e as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => <String, dynamic>{"name": name};
}

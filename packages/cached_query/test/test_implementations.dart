import 'dart:async';

import 'package:cached_query/cached_query.dart';

int _serial = 0;
const testQueryRes = 'result';
Query<String> createQuery({
  String? key,
  String res = testQueryRes,
  void Function()? onFetch,
  CachedQuery? cache,
}) {
  key ??= 'query_${_serial++}';
  return Query<String>(
    key: key,
    cache: cache,
    queryFn: () async {
      onFetch?.call();
      return res;
    },
  );
}

InfiniteQuery<String, int> createInfiniteQuery({
  String? key,
  String res = testQueryRes,
  CachedQuery? cache,
}) {
  key ??= 'query_${_serial++}';
  return InfiniteQuery(
    key: key,
    getNextArg: (state) {
      return (state.data?.length ?? 0) + 1;
    },
    queryFn: (arg) async {
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

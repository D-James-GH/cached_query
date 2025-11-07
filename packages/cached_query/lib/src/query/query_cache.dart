// ignore_for_file: public_member_api_docs

part of "_query.dart";

class QueryCache {
  final Map<String, Cacheable<dynamic>> _queryCache = {};

  bool containsKey(String key) {
    return _queryCache.containsKey(key);
  }

  T? get<T extends Cacheable<Object?>>(String key) {
    return _queryCache[key] as T?;
  }

  Iterable<Cacheable<dynamic>> getAll() {
    return _queryCache.values;
  }

  void add(Cacheable<dynamic> query) {
    _queryCache[query.key] = query;
  }

  void remove(Cacheable<dynamic> query) {
    _queryCache.remove(query.key);
  }

  void removeByKey(String key) {
    _queryCache.remove(key);
  }

  Iterable<Cacheable<Object?>> where(
    bool Function(Cacheable<Object?>) test,
  ) =>
      _queryCache.values.where(test);

  Iterable<T> map<T>(T Function(Cacheable<Object?>) transform) =>
      _queryCache.values.map(transform);

  void removeAll() {
    _queryCache.clear();
  }
}

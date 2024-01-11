import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:collection/collection.dart';

class MockStorage extends StorageInterface {
  static const data = "storage";
  List<StoredQuery> store = [];
  @override
  void close() {}

  @override
  void delete(String key) {}

  @override
  void deleteAll() {
    store = [];
  }

  @override
  FutureOr<StoredQuery?> get(String key) {
    final item = store.firstWhereOrNull((e) => e.key == key);
    if (item == null) return null;
    return item;
  }

  @override
  void put(StoredQuery query) {
    final storedIndex = store.indexWhere((e) => e.key == query.key);
    if (storedIndex == -1) {
      store.add(query);
    } else {
      store[storedIndex] = query;
    }
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

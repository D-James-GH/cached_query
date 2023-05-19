import 'dart:async';

import 'package:cached_query/cached_query.dart';

class MockStorage extends StorageInterface {
  static const data = "storage";
  var store = <String, String>{};
  @override
  void close() {}

  @override
  void delete(String key) {}

  @override
  void deleteAll() {
    store = <String, String>{};
  }

  @override
  FutureOr<String?> get(String key) {
    if (!store.containsKey(key)) return null;
    return store[key]!;
  }

  @override
  void put(String key, {required String item}) {
    store[key] = item;
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

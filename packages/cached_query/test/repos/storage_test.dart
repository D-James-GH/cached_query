import 'dart:async';
import 'dart:convert';

import 'package:cached_query/cached_query.dart';

class StorageTest extends StorageInterface {
  static const data = "storage";
  var store = <String, String>{};
  @override
  void close() {
    // TODO: implement close
  }

  @override
  void delete(String key) {
    // TODO: implement delete
  }

  @override
  void deleteAll() {
    store = <String, String>{};
  }

  @override
  FutureOr<dynamic> get(String key) {
    if (!store.containsKey(key)) return null;
    return jsonDecode(store[key]!);
  }

  @override
  void put<T>(String key, {required T item}) {
    if (item is String) {
      store[key] = item;
    } else {
      store[key] = jsonEncode(item);
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

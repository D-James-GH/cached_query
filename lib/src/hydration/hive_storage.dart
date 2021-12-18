import 'dart:convert';

import 'package:hive/hive.dart';

import 'query_storage.dart';

class HiveStorage implements QueryStorage {
  Box<dynamic>? box;

  Future<void> _openBox() async {
    if (box?.isOpen != true) {
      box = await Hive.openBox<dynamic>("query_storage");
    }
  }

  @override
  Future<String> get(String key) async {
    await _openBox();
    final item = box!.get(key);
    return item;
  }

  @override
  void put(String key, {required String item}) async {
    await _openBox();
    await box!.put(key, item);
  }

  @override
  Future<void> delete(String key) async {
    await _openBox();
    await box!.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    await _openBox();
    await box!.deleteAll(box!.keys);
  }

  @override
  void close() {
    box?.compact();
    box?.close();
  }
}

abstract class StorageInterface {
  Future<String> get(String key);
  void delete(String key);
  void put(String key, {required String item});
  void deleteAll();
  void close();
}

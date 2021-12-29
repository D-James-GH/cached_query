abstract class StorageInterface {
  Future<dynamic> get(String key);
  void delete(String key);
  void put<T>(String key, {required T item});
  void deleteAll();
  void close();
}

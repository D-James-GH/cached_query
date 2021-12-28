abstract class StorageInterface {
  Future<T> get<T>(String key);
  void delete(String key);
  void put<T>(String key, {required T item});
  void deleteAll();
  void close();
}

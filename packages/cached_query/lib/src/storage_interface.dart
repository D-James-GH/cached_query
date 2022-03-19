/// An interface for any storage adapter.
///
/// Used by the [CachedStorage] plugin to save the current cache.
abstract class StorageInterface {
  /// Get stored data from the storage instance.
  Future<dynamic> get(String key);

  /// Delete the cache at a given key.
  void delete(String key);

  /// Update or add data with a given key.
  void put<T>(String key, {required T item});

  /// Delete all stored data.
  void deleteAll();

  /// Close and clean up the storage instance.
  void close();
}

# Storage
The quickest way to persist queries is to use [Cached Storage](https://pub.dev/packages/cached_storage). But you can 
also easily implement your own.  
## CachedStorage
Cached Storage is built upon [Sqflite](https://pub.dev/packages/sqflite) as this allows simple asyncronus access to a 
database. 

### Getting Started
Initialized cached query with the storage interface. This must be initialized before any query is called.

```dart

void main() async {
  CachedQuery.instance.configFlutter(
    storage: await CachedStorage.ensureInitialized(),
  );
}

```

Queries will then automatically be persisted.

### Serialization

Cached Storage uses `jsonEncode` to convert the data of a query to json, which is then stored. If you are returning
dart objects from the `queryFn` you will need to serialized the json back into the dart object. To do this, pass a
`serilizer` to the QueryConfig which will be used to turn the stored data back into a dart object.

```dart
 Query<JokeModel>(
  key: 'joke',
  config: QueryConfig(
    // Use a serializer to transform the store json to an object.
    serializer: (dynamic json) =>
        JokeModel.fromJson(json as Map<String, dynamic>),
  ),
  queryFn: () async {
    final req = client.get(
      Uri.parse("https://icanhazdadjoke.com/"),
      headers: {"Accept": "application/json"},
    );
    final res = await req;
    return JokeModel.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
    );
  },
);
```

## Custom Storage
There is no need to depend on Cached Storage if you are implementing a custom solution. To get started using a custom 
storage solution extend `StorageInterface` from Cached Query, shown below. 
```dart
/// An interface for any storage adapter.
///
/// Used by the [CachedStorage] plugin to save the current cache.
abstract class StorageInterface {
  /// Get stored data from the storage instance.
  FutureOr<dynamic> get(String key);

  /// Delete the cache at a given key.
  void delete(String key);

  /// Update or add data with a given key.
  /// Item will be the data from a Query or Infinite Query
  void put<T>(String key, {required T item});

  /// Delete all stored data.
  void deleteAll();

  /// Close and clean up the storage instance.
  void close();
}
```
For a further example of implementing the storage interface look at the source code for Cached Storage: 
[Source Code](https://github.com/D-James-GH/cached_query/blob/main/packages/cached_storage/lib/cached_storage.dart)
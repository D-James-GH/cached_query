<h1 align="center"><a  href="https://cachedquery.dev">Cached Storage</a></h1>

<p align="center">Visit the <a href="https://cachedquery.dev/">documentation</a> for more information.</p>

A Storage addon to the [CachedQuery](https://pub.dev/packages/cached_query) package.

Built on top of [Sqflite](https://pub.dev/packages/sqflite).

## Features

* Persist queries to disk
* Accepts any json serializable data.

## Getting started

Initialized cached query with the storage interface. This must be initialized before any query is called.

```dart

void main() async {
  CachedQuery.instance.configFlutter(
    storage: await CachedStorage.ensureInitialized(),
  );
}

```

Queries will then automatically be persisted.

## Serialization

Cached Storage uses `jsonEncode` to convert the data of a query to json, which is then stored. If you are returning 
dart objects from the `queryFn` you will need to serialized the json back into the dart object. To do this, pass a 
`serilizer` to the QueryConfig which will be used to turn the stored data back into a dart object.

```dart
 Query<JokeModel>(
  key: 'joke',
  config: QueryConfig(
    // Use a serializer to transform the store json to an object.
    deserializer: (dynamic json) =>
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


## Additional information

This package is an addon for [Cached Query](https://pub.dev/packages/cached_query). For persistent storage take a look at
[Cached Storage].

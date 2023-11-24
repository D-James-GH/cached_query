import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_storage/cached_storage.dart';

// Full project example here: https://github.com/D-James-GH/cached_query/tree/main/examples/query_builder
void main() async {
  CachedQuery.instance.configFlutter(
    storage: await CachedStorage.ensureInitialized(),
    config: const QueryConfig(),
  );
  final joke = await getJoke().result;
}

Query<JokeModel?> getJoke() {
  return Query<JokeModel>(
    key: 'joke',
    config: QueryConfig(
      storageDeserializer: (dynamic json) =>
          JokeModel.fromJson(json as Map<String, dynamic>),
    ),
    queryFn: () async {
      final req = client.get(
        Uri.parse("https://icanhazdadjoke.com/"),
        headers: {"Accept": "application/json"},
      );
      final res = await req;
      return Future.delayed(
        const Duration(milliseconds: 400),
        () => JokeModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        ),
      );
    },
  );
}

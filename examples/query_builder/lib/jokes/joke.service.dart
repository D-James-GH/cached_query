import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import 'package:http/http.dart' as http;
import 'package:query_builder/jokes/joke_model/joke_model.dart';

class JokeService with CachedQuery {
  final http.Client client = http.Client();

  Query<JokeModel?> getJoke() {
    return query<JokeModel>(
        key: 'joke',
        refetchDuration: const Duration(seconds: 4),
        serializer: (json) => JokeModel.fromJson(json),
        queryFn: () async {
          final res = await client.get(Uri.parse("https://icanhazdadjoke.com/"),
              headers: {"Accept": "application/json"});
          if (res.statusCode == 200) {
            return Future.delayed(
              const Duration(milliseconds: 400),
              () => JokeModel.fromJson(jsonDecode(res.body)),
            );
          } else {
            throw Exception();
          }
        });
  }
}

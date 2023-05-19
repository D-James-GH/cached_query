import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:http/http.dart' as http;

import 'joke_model/joke_model.dart';

class JokeService {
  final http.Client client = http.Client();

  Query<JokeModel?> getJoke() {
    return Query<JokeModel>(
      key: 'joke',
      config: QueryConfigFlutter(
        refetchDuration: const Duration(seconds: 4),
        deserializer: (dynamic json) =>
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
}

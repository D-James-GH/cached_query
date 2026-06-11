import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../joke_model/joke_model.dart';

class SimulatedError implements Exception {}

class UnrecoverableError implements Exception {}

class JokeService {
  final http.Client client = http.Client();

  Query<JokeModel> getJoke() {
    return Query<JokeModel>(
      key: 'joke',
      config: QueryConfig(
        staleDuration: const Duration(seconds: 4),
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
  }
}

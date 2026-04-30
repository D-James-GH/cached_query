import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'joke_model/joke_model.dart';

class SimulatedError implements Exception {}

class UnrecoverableError implements Exception {}

class JokeService {
  final http.Client client = http.Client();
  int jokeCount = 0;

  Query<JokeModel?> getJoke() {
    return Query<JokeModel>(
      key: 'joke',
      config: QueryConfig(
        retryConfig: RetryConfig(
          maxRetries: 3,
          delay: (attempt) => Duration(seconds: 2 * attempt),
          whenError: (error, attempt) async {
            if (error is UnrecoverableError) {
              // don't retry on unrecoverable errors
              debugPrint("Unrecoverable error occurred, not retrying.");
              return false;
            }
            // retry on all other errors
            debugPrint("Error occurred: $error. Retrying attempt $attempt...");
            return true;
          },
        ),
        // fetch a new joke every 5 seconds
        pollingInterval: (_) => const Duration(seconds: 5),
        storeQuery: true,
        staleDuration: const Duration(seconds: 4),
        storageDeserializer: (json) =>
            JokeModel.fromJson(json as Map<String, dynamic>),
      ),
      queryFn: () async {
        jokeCount++;

        if (jokeCount % 5 == 0) {
          // simulate an error after 3 jokes to demonstrate retry logic
          throw SimulatedError();
        } else if (jokeCount % 3 == 0) {
          throw UnrecoverableError();
        }

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

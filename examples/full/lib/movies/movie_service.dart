import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:full/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_models/shared_models.dart';

class SimulatedError implements Exception {}

class UnrecoverableError implements Exception {}

class MovieService {
  final http.Client client = http.Client();
  int movieCount = 0;

  Query<Movie?> getMovie() {
    return Query<Movie>(
      key: 'movie',
      config: QueryConfig(
        retryConfig: RetryConfig(
          maxRetries: 3,
          delay: (attempt) => Duration(seconds: 2 * attempt),
          whenError: (error, attempt) async {
            if (error is UnrecoverableError) {
              debugPrint('Unrecoverable error occurred, not retrying.');
              return false;
            }
            debugPrint('Error occurred: $error. Retrying attempt $attempt...');
            return true;
          },
        ),
        pollingInterval: (_) => const Duration(seconds: 5),
        storeQuery: true,
        staleDuration: const Duration(seconds: 4),
        storageDeserializer: (json) =>
            Movie.fromJson(json as Map<String, dynamic>),
      ),
      queryFn: () async {
        movieCount++;

        if (movieCount % 5 == 0) {
          throw SimulatedError();
        } else if (movieCount % 3 == 0) {
          throw UnrecoverableError();
        }

        final res = await client.get(
          Uri.parse('$apiBaseUrl/movies/random?delay=500'),
        );
        return Movie.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      },
    );
  }
}

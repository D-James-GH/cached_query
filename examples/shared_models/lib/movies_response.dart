import 'package:freezed_annotation/freezed_annotation.dart';

import 'movie.dart';

part 'movies_response.freezed.dart';
part 'movies_response.g.dart';

/// Paginated movies list response.
@freezed
abstract class MoviesResponse with _$MoviesResponse {
  const factory MoviesResponse({
    required List<Movie> movies,
    required int total,
    required int skip,
    required int limit,
  }) = _MoviesResponse;

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

/// A movie with fields used by the examples UI.
@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required String imdbId,
    required String title,
    required String plot,
    required String year,
    required String poster,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  /// Creates a [Movie] from OMDb-style JSON keys in movies-250.json.
  factory Movie.fromOmdbJson(Map<String, dynamic> json) => Movie(
        imdbId: json['imdbID'] as String,
        title: json['Title'] as String,
        plot: json['Plot'] as String,
        year: json['Year'] as String,
        poster: json['Poster'] as String,
      );
}

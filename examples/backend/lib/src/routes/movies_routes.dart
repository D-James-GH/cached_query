import 'dart:io';

import 'package:backend/backend.dart';
import 'package:backend/src/data/data_store.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shared_models/shared_models.dart';

/// Routes for movie resources.
class MoviesRoutes {
  MoviesRoutes(this._dataStore);

  final DataStore _dataStore;

  Router get router {
    final router = Router();

    router.get('/movies/random', _getRandomMovie);
    router.get('/movies', _listMovies);
    router.get('/movies/<id>', _getMovie);

    return router;
  }

  Response _listMovies(Request request) {
    final limit = parseQueryInt(
      request.url.queryParameters['limit'],
      defaultValue: 10,
    );
    final skip = parseQueryInt(
      request.url.queryParameters['skip'],
      defaultValue: 0,
    );
    final page = paginate(_dataStore.movies, skip: skip, limit: limit);

    return jsonResponse(
      MoviesResponse(
        movies: page,
        total: _dataStore.movies.length,
        skip: skip,
        limit: limit,
      ).toJson(),
    );
  }

  Response _getRandomMovie(Request request) {
    if (_dataStore.movies.isEmpty) {
      return jsonResponse(
        {'message': 'No movies available'},
        statusCode: HttpStatus.notFound,
      );
    }

    final movie = _dataStore.movies[random.nextInt(_dataStore.movies.length)];
    return jsonResponse(movie.toJson());
  }

  Response _getMovie(Request request, String id) {
    final movie = _dataStore.moviesById[id];
    if (movie == null) {
      return jsonResponse(
        {'message': 'Movie not found'},
        statusCode: HttpStatus.notFound,
      );
    }

    return jsonResponse(movie.toJson());
  }
}

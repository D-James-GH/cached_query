import 'dart:convert';
import 'dart:io';

import 'package:shared_models/shared_models.dart';

/// In-memory store for posts and movies loaded from bundled JSON.
class DataStore {
  DataStore({
    required this.posts,
    required this.movies,
  });

  final List<Post> posts;
  final List<Movie> movies;
  final Map<String, Movie> moviesById = {};

  static Future<DataStore> load() async {
    final postsFile = await _readDataFile('posts.json');
    final postsJson = jsonDecode(postsFile) as Map<String, dynamic>;
    final posts = (postsJson['posts'] as List<dynamic>)
        .map((dynamic e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();

    final moviesFile = await _readDataFile('movies-250.json');
    final moviesJson = jsonDecode(moviesFile) as Map<String, dynamic>;
    final movies = (moviesJson['movies'] as List<dynamic>)
        .map((dynamic e) => Movie.fromOmdbJson(e as Map<String, dynamic>))
        .toList();

    final store = DataStore(posts: posts, movies: movies);
    for (final movie in movies) {
      store.moviesById[movie.imdbId] = movie;
    }
    return store;
  }

  static Future<String> _readDataFile(String name) async {
    final candidates = [
      'data/$name',
      'examples/backend/data/$name',
    ];

    for (final path in candidates) {
      final file = File(path);
      if (file.existsSync()) {
        return file.readAsString();
      }
    }

    throw StateError('Could not find data file: $name');
  }

  Post createPost(CreatePostRequest request) {
    final nextId = posts.fold<int>(
          0,
          (maxId, post) => post.id > maxId ? post.id : maxId,
        ) +
        1;
    final post = Post(
      id: nextId,
      title: request.title,
      body: request.body,
      userId: request.userId,
    );
    posts.add(post);
    return post;
  }
}

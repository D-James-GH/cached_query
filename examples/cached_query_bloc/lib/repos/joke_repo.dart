import 'package:cached_query/cached_query.dart';
import 'package:examples/models/joke_model.dart';
import 'package:examples/services/joke.service.dart';

class JokeRepository extends CachedQuery {
  final _service = JokeService();

  Stream<QueryState<JokeModel?>> getJoke() {
    return query(
      key: 'joke',
      staleTime: const Duration(seconds: 5),
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
    ).stream;
  }

  Future<QueryState<JokeModel?>> getJokeFuture() {
    return query(
      key: 'joke',
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
      staleTime: const Duration(seconds: 10),
    ).result;
  }
}

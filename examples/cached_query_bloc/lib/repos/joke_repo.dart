import 'package:cached_query/cached_query.dart';
import 'package:examples/models/joke_model.dart';
import 'package:examples/services/joke.service.dart';

class JokeRepository extends CachedQuery {
  final _service = JokeService();

  Stream<Query<JokeModel>> getJoke() {
    return queryStream(
      key: 'joke',
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
    );
  }

  Future<Query<JokeModel?>> getJokeFuture(
      void Function(Query<JokeModel>) listener) {
    return query(
      key: 'joke',
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
      staleTime: const Duration(seconds: 10),
      listener: listener,
    );
  }
}

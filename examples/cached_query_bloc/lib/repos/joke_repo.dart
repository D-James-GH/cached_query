import 'package:cached_query/cached_query.dart';
import 'package:examples/models/joke_model.dart';
import 'package:examples/services/joke.service.dart';

class JokeRepository extends CachedQuery {
  final _service = JokeService();

  Query<JokeModel?> getJoke() {
    return query<JokeModel>(
      key: 'joke',
      refetchDuration: const Duration(seconds: 5),
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
    );
  }
}

import 'package:cached_query/cached_query.dart';
import 'package:examples/models/joke.model.dart';
import 'package:examples/services/joke.service.dart';

class JokeRepository extends CachedRepository {
  final _service = JokeService();

  Future<JokeModel> getJoke() async {
    return query(
      key: 'joke',
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
    );
  }
}

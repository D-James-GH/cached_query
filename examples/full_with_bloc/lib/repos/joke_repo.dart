import 'package:cached_query/cached_query.dart';

import '../models/joke_model.dart';
import '../services/joke.service.dart';

class JokeRepository {
  final _service = JokeService();

  Query<JokeModel?> getJoke() {
    return Query<JokeModel>(
      key: 'joke',
      queryFn: () async => JokeModel.fromJson(await _service.getJoke()),
    );
  }
}

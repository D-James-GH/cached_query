import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:query_builder/jokes/joke_model/joke_model.dart';
import 'package:query_builder/jokes/joke_service.dart';

void main() {
  tearDown(CachedQuery.instance.deleteCache);

  test("query test", () async {
    final service = JokeService();
    final query = service.getJoke();
    final result = await query.result;
    expect(result.data, isA<JokeModel>());
  });

  test("query stream test", () async {});
}

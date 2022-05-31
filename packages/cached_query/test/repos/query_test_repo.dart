import 'package:cached_query/cached_query.dart';

class QueryMock {
  static const key = "query";
  static const returnString = "I am a return string";

  Future<String> fetchFunction([Duration duration = Duration.zero]) {
    return Future.delayed(
      duration,
      () => returnString,
    );
  }

  Query<String> getQuery([Duration duration = Duration.zero]) {
    return Query(
      key: key,
      cacheDuration: const Duration(seconds: 1),
      refetchDuration: const Duration(seconds: 2),
      queryFn: fetchFunction,
    );
  }
}

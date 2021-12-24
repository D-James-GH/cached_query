import 'package:cached_query/cached_query.dart';

class QueryMock {
  static const key = "query";
  static const returnString = "I am a return string";

  Query<String> getQuery() {
    return query(
      key: key,
      cacheDuration: const Duration(seconds: 1),
      refetchDuration: const Duration(seconds: 2),
      queryFn: () => Future.delayed(
        Duration.zero,
        () => returnString,
      ),
    );
  }
}

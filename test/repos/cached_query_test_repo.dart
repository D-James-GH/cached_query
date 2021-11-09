import 'package:cached_query/cached_query.dart';

class CachedQueryTestRepo extends CachedQuery {
  Future<Query<String?>> getTimeQuery() {
    return query(
      key: 'timeQuery',
      cacheTime: const Duration(seconds: 1),
      staleTime: const Duration(seconds: 2),
      queryFn: () => Future.delayed(
        const Duration(seconds: 1),
        () => DateTime.now().toString(),
      ),
    );
  }

  Stream<Query<String>> streamTimeQuery() {
    return queryStream(
      key: 'timeQuery',
      cacheTime: const Duration(seconds: 1),
      staleTime: const Duration(seconds: 2),
      queryFn: () => Future.delayed(
        const Duration(seconds: 1),
        () => DateTime.now().toString(),
      ),
    );
  }
}

import 'package:cached_query/cached_query.dart';

class InfiniteQueryTestRepository extends CachedQuery {
  Future<InfiniteQuery<String>> getPage() async {
    return infiniteQuery(
        queryFn: (int page) => Future.delayed(
              const Duration(milliseconds: 500),
              () => ["page: $page"],
            ),
        key: "testkey");
  }
}

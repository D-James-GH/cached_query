import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'repos/infinite_query_test_repo.dart';

void main() async {
  final repo = InfiniteQueryTestRepository();
  group("creating a query", () {
    tearDownAll(deleteCache);
    test("query is created and added to cache", () {
      final query = infiniteQuery<String, int>(
          key: InfiniteQueryTestRepository.key,
          queryFn: repo.getPosts,
          getNextArg: (pageIndex, lastPage) {
            if (lastPage == null) return 1;
            if (lastPage.isEmpty) return null;
            return pageIndex + 1;
          });

      final queryFromCache =
          getInfiniteQuery<String, int>(InfiniteQueryTestRepository.key);
      expect(query, queryFromCache);
    });
  });
  group("Infinite query as a future", () {
    tearDown(deleteCache);
    test("Should return an infinite query", () async {
      final query = infiniteQuery<String, int>(
          key: InfiniteQueryTestRepository.key,
          queryFn: repo.getPosts,
          getNextArg: (pageIndex, lastPage) {
            if (lastPage == null) return 1;
            if (lastPage.isEmpty) return null;
            return pageIndex + 1;
          });
      final res = await query.result;
      expect(res, isA<InfiniteQueryState<String>>());
    });
    test("calling query result twice is de-duped", () async {
      final query = infiniteQuery<String, int>(
          key: InfiniteQueryTestRepository.key,
          queryFn: (page) =>
              Future.delayed(Duration(seconds: 2), () => repo.getPosts(page)),
          getNextArg: (pageIndex, lastPage) {
            if (lastPage == null) return 1;
            if (lastPage.isEmpty) return null;
            return pageIndex + 1;
          });
      String res1 = "";
      String res2 = "";
      query.result.whenComplete(() {
        res1 = DateTime.now().toString();
      });
      query.result.whenComplete(() {
        res2 = DateTime.now().toString();
      });
      expect(res1, res2);
    });
    test("Adding refetchDuration means next result will come from cache.",
        () async {
      final query = infiniteQuery<String, int>(
          key: InfiniteQueryTestRepository.key,
          queryFn: repo.getPosts,
          refetchDuration: Duration(seconds: 5),
          getNextArg: (pageIndex, lastPage) {
            if (lastPage == null) return 1;
            if (lastPage.isEmpty) return null;
            return pageIndex + 1;
          });
      final res1 = await query.result;
      final res2 = await infiniteQuery<String, int>(
          key: InfiniteQueryTestRepository.key,
          queryFn: repo.getPosts,
          getNextArg: (pageIndex, lastPage) {
            if (lastPage == null) return 1;
            if (lastPage.isEmpty) return null;
            return pageIndex + 1;
          }).result;
      expect(res1.timeCreated, res2.timeCreated);
    });
    test("re-fetching does not give the same result", () async {
      final query = infiniteQuery<String, int>(
          key: InfiniteQueryTestRepository.key,
          queryFn: repo.getPosts,
          getNextArg: (pageIndex, lastPage) {
            if (lastPage == null) return 1;
            if (lastPage.isEmpty) return null;
            return pageIndex + 1;
          });
      final res1 = await query.result;
      final res2 = await query.refetch();
      expect(res1.timeCreated, isNot(res2.timeCreated));
    });
  });
}

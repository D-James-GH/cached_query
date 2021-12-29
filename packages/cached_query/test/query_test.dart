import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'repos/query_test_repo.dart';

void main() {
  group("creating a query", () {
    tearDownAll(() {
      GlobalCache.instance.deleteCache();
    });
    test("query is created and added to cache", () {
      final query = QueryMock().getQuery();
      final queryFromCache =
          GlobalCache.instance.getQuery<String>(QueryMock.key);
      expect(query, queryFromCache);
    });
  });

  group("query as a future", () {
    tearDown(() {
      GlobalCache.instance.deleteCache();
    });
    test("result returns the return string", () async {
      final query = QueryMock().getQuery();
      QueryState<String> res = await query.result;
      expect(QueryMock.returnString, res.data);
    });
    test("calling query result twice is de-duped", () async {
      QueryState<String> res1 = await QueryMock().getQuery().result;
      QueryState<String> res2 = await QueryMock().getQuery().result;
      expect(res1.timeCreated, res2.timeCreated);
    });
    test("re-fetching does not give the same result", () async {
      final query = QueryMock().getQuery();
      QueryState<String> res1 = await query.result;
      QueryState<String> res2 = await query.refetch();
      expect(res1.timeCreated, isNot(res2.timeCreated));
    });
  });

  group("Stream query", () {
    tearDown(() {
      GlobalCache.instance.deleteCache();
    });

    test('stream emits QueryState', () async {
      final state = await QueryMock().getQuery().stream.first;
      expect(state, isA<QueryState<String>>());
    });
    test(
        'stream emits 2 values while fetching, loading/currentData then new result',
        () async {
      int i = 0;

      await QueryMock()
          .getQuery(Duration(seconds: 1))
          .stream
          .listen(expectAsync1(
            (event) {
              if (i == 0) {
                expect(event.data, isNull);
              } else if (i == 1) {
                expect(event.data, QueryMock.returnString);
              }
              i++;
            },
            count: 2,
            max: 2,
          ));
    });
    test('refetch causes loading then new query', () async {
      int i = 0;
      QueryState<String>? firstQuery;
      final expectedValues = [true, false, true, false];
      final query = QueryMock().getQuery();
      await query.stream.listen(
        expectAsync1((event) {
          if (i == 3) {
            expect(firstQuery, isNotNull);
            expect(firstQuery?.timeCreated, isNot(event.timeCreated));
          }
          expect(event.isFetching, expectedValues[i]);
          firstQuery = event;
          i++;
        }, max: 4),
      );
      await query.refetch();
    });
  });
  group("update a query", () {
    tearDown(() {
      GlobalCache.instance.deleteCache();
    });
    test("update function should receive old data and update query", () async {
      final query = QueryMock().getQuery();
      final res = await query.result;
      query.update((oldData) {
        expect(oldData, res.data);
        return "Changed query data";
      });
      expect(query.state.data, "Changed query data");
    });
  });

  group("Delete and Invalidate", () {
    tearDown(() {
      GlobalCache.instance.deleteCache();
    });
    test("Delete", () async {
      final query = QueryMock().getQuery();
      query.deleteQuery();
      expect(GlobalCache.instance.getQuery<String>(QueryMock.key), isNull);
    });
    test("Invalidate", () async {
      final query = QueryMock().getQuery();
      query.invalidateQuery();
      expect(query.stale, true);
    });
  });
}

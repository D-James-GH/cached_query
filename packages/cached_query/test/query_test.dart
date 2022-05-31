import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'repos/query_test_repo.dart';

void main() {
  final cachedQuery = CachedQuery.instance;
  group("creating a query", () {
    tearDownAll(cachedQuery.deleteCache);
    test("query is created and added to cache", () {
      final query = QueryMock().getQuery();
      final queryFromCache = cachedQuery.getQuery(QueryMock.key);

      expect(query, queryFromCache);
    });
    test("Query should de-duplicate requests", () async {
      int fetchCount = 0;
      final query1 = Query(
        key: "de-dupe",
        queryFn: () {
          fetchCount++;
          return QueryMock().fetchFunction();
        },
      );
      final query2 = Query(
        key: "de-dupe",
        queryFn: () {
          fetchCount++;
          return QueryMock().fetchFunction();
        },
      );
      await Future.wait<dynamic>([query1.result, query2.result]);
      expect(fetchCount, 1);
    });
  });

  group("query as a future", () {
    tearDown(cachedQuery.deleteCache);
    test("result returns the return string", () async {
      final query = QueryMock().getQuery();
      final QueryState<String> res = await query.result;
      expect(QueryMock.returnString, res.data);
    });
    test("calling query result twice is de-duped", () async {
      final QueryState<String> res1 = await QueryMock().getQuery().result;
      final QueryState<String> res2 = await QueryMock().getQuery().result;
      expect(res1.timeCreated, res2.timeCreated);
    });
    test("re-fetching does not give the same result", () async {
      final query = QueryMock().getQuery();
      final QueryState<String> res1 = await query.result;
      final QueryState<String> res2 = await query.refetch();
      expect(res1.timeCreated, isNot(res2.timeCreated));
    });
    test("Query does not refetch if refetch duration is not up.", () async {
      int fetchCount = 0;
      final query1 = Query(
        key: "de-dupe",
        refetchDuration: const Duration(seconds: 2),
        queryFn: () {
          fetchCount++;
          return QueryMock().fetchFunction();
        },
      );
      await query1.result;
      await query1.result;
      expect(fetchCount, 1);
    });
  });

  group("Stream query", () {
    tearDown(cachedQuery.deleteCache);

    test('stream emits QueryState', () async {
      final state = await QueryMock().getQuery().stream.first;
      expect(state, isA<QueryState<String>>());
    });
    test(
        'stream emits 2 values while fetching, loading/currentData then new result',
        () async {
      int i = 0;

      QueryMock().getQuery(const Duration(seconds: 1)).stream.listen(
            expectAsync1(
              (event) {
                if (i == 0) {
                  expect(event.data, isNull);
                  expect(event.status, QueryStatus.loading);
                } else if (i == 1) {
                  expect(event.data, QueryMock.returnString);
                  expect(event.status, QueryStatus.success);
                }
                i++;
              },
              count: 2,
              max: 2,
            ),
          );
    });
    test('refetch causes loading then new query', () async {
      int i = 0;
      QueryState<String>? firstQuery;
      final expectedValues = [
        QueryStatus.loading,
        QueryStatus.success,
        QueryStatus.loading,
        QueryStatus.success,
      ];
      final query = QueryMock().getQuery();
      query.stream.listen(
        expectAsync1(
          (event) {
            if (i == 3) {
              expect(firstQuery, isNotNull);
              expect(firstQuery?.timeCreated, isNot(event.timeCreated));
            }
            expect(event.status, expectedValues[i]);
            firstQuery = event;
            i++;
          },
          max: 4,
        ),
      );
      await query.refetch();
    });
  });
  group("update a query", () {
    tearDown(cachedQuery.deleteCache);
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
    tearDown(cachedQuery.deleteCache);
    test("Delete", () async {
      QueryMock().getQuery().deleteQuery();
      expect(cachedQuery.getQuery(QueryMock.key), isNull);
    });
    test("Invalidate", () async {
      final query = QueryMock().getQuery()..invalidateQuery();
      expect(query.stale, true);
    });
  });
}

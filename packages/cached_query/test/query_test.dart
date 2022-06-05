import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'repos/query_test_repo.dart';
import 'repos/storage_test.dart';

void main() {
  final cachedQuery = CachedQuery.instance;
  group("creating a query", () {
    tearDownAll(cachedQuery.deleteCache);
    test("query is created and added to cache", () {
      final query = Query(key: "query created", queryFn: fetchFunction);
      final queryFromCache = cachedQuery.getQuery("query created");

      expect(query, queryFromCache);
    });
    test("Query should de-duplicate requests", () async {
      int fetchCount = 0;
      final query1 = Query(
        key: "de-dupe",
        queryFn: () {
          fetchCount++;
          return fetchFunction();
        },
      );
      final query2 = Query(
        key: "de-dupe",
        queryFn: () {
          fetchCount++;
          return fetchFunction();
        },
      );
      await Future.wait<dynamic>([query1.result, query2.result]);
      expect(fetchCount, 1);
    });
  });

  group("query as a future", () {
    tearDown(cachedQuery.deleteCache);
    test("result returns the return string", () async {
      final query = Query(key: "result", queryFn: fetchFunction);
      final QueryState<String> res = await query.result;
      expect(returnString, res.data);
    });
    test("calling query result twice is de-duped", () async {
      final QueryState<String> res1 =
          await Query(key: "calling twice", queryFn: fetchFunction).result;
      final QueryState<String> res2 =
          await Query(key: "calling twice", queryFn: fetchFunction).result;
      expect(res1.timeCreated, res2.timeCreated);
    });
    test("re-fetching does not give the same result", () async {
      final query = Query(key: "re-fetching", queryFn: fetchFunction);
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
          return fetchFunction();
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
      final state = await Query(
        key: "stream emits",
        queryFn: fetchFunction,
      ).stream.first;
      expect(state, isA<QueryState<String>>());
    });
    test(
        'stream emits 2 values while fetching, loading/currentData then new result',
        () async {
      int i = 0;

      Query(
        key: "stream emits 2 values",
        queryFn: fetchFunction,
      ).stream.listen(
            expectAsync1(
              (event) {
                if (i == 0) {
                  expect(event.data, isNull);
                  expect(event.status, QueryStatus.loading);
                } else if (i == 1) {
                  expect(event.data, returnString);
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
      final query = Query(
        key: "refetch loading",
        queryFn: fetchFunction,
      );
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
      final query = Query(
        key: "update func",
        queryFn: fetchFunction,
      );
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
      Query(key: "delete", queryFn: fetchFunction).deleteQuery();
      expect(cachedQuery.getQuery("delete"), isNull);
    });
    test("Invalidate", () async {
      final query = Query(
        key: "invalidate",
        queryFn: fetchFunction,
      )..invalidateQuery();
      expect(query.stale, true);
    });
  });

  group("Fetch from storage", () {
    final storage = StorageTest();
    setUpAll(() => CachedQuery.instance.config(storage: storage));
    tearDown(cachedQuery.deleteCache);

    test("Should store the query on fetch", () async {
      const key = "store";
      const data = "someData";
      storage.deleteAll();
      final query = Query<String>(
        key: key,
        queryFn: () async => Future.value(data),
      );
      await query.result;
      expect(storage.store.length, 1);
      expect(storage.store[key], data);
    });

    test("Should not store query if specified", () async {
      storage.deleteAll();
      final query = Query<String>(
        key: "noStore",
        queryFn: () async => Future.value("data"),
        storeQuery: false,
      );
      await query.result;
      expect(storage.store.length, 0);
    });

    test("Should get initial data from storage before queryFn", () async {
      const key = "getInitial";
      // Make sure the storage has initial data
      storage.put(key, item: StorageTest.data);
      final query = Query<String>(
        key: key,
        queryFn: () async => Future.value("data"),
      );

      final output = <String>[];
      query.stream.listen(
        expectAsync1(
          (event) {
            if (event.data != null) {
              output.add(event.data!);
            }
            if (output.length == 1) {
              expect(output[0], StorageTest.data);
            }
          },
          max: 3,
        ),
      );
    });

    test("Should serialize data if a serialize function is provided", () async {
      const key = "serialize";
      // Make sure the storage has initial data
      storage.put(
        key,
        item: {
          key: {"name": StorageTest.data}
        },
      );
      final query = Query<Serializable>(
        key: key,
        queryFn: () async => Future.value(Serializable("Fetched")),
        serializer: (dynamic json) =>
            Serializable.fromJson(json as Map<String, dynamic>),
      );

      final output = <dynamic>[];
      query.stream.listen(
        expectAsync1(
          (event) {
            if (event.data != null) {
              output.add(event.data!);
            }
            if (output.length == 1) {
              expect(output[0], isA<Serializable>());
              expect((output[0] as Serializable).name, StorageTest.data);
            }
          },
          max: 3,
        ),
      );
    });
    test("Storage should update on each fetch", () async {
      int count = 0;
      const key = "updateStore";
      final query = Query<int>(
        key: key,
        queryFn: () {
          count++;
          return Future.value(count);
        },
      );
      await query.result;
      final res2 = await query.refetch();
      expect(storage.store[key], count.toString());
      expect(storage.store[key], res2.data.toString());
    });
  });
  group("Errors", () {
    tearDown(() {
      cachedQuery
        ..deleteCache()
        ..reset();
    });
    test("Should  add error state to stream", () async {
      final query = Query(
        key: "error",
        queryFn: () async => throw "This is an error",
      );
      final res = await query.result;
      expect(res.status, QueryStatus.error);
    });
    test("Result should rethrow if specified ", () async {
      cachedQuery
        ..reset()
        ..config(config: QueryConfig(shouldRethrow: true));
      try {
        final query = Query<String>(
          key: "error2",
          queryFn: () async {
            throw "this is an error";
          },
        );
        await query.result;
        fail("Should throw");
      } catch (e) {
        expect(e, "this is an error");
      }
    });
  });
}

import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'mock_storage.dart';
import 'repos/query_test_repo.dart';

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
    test("Can create with initial data", () {
      final query = Query<String>(
        key: "initial",
        queryFn: () async => "data",
        initialData: "initial",
      );
      expect(query.state.data, "initial");
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
        config: QueryConfig(
          refetchDuration: const Duration(seconds: 2),
        ),
        queryFn: () {
          fetchCount++;
          return fetchFunction();
        },
      );
      await query1.result;
      await query1.result;
      expect(fetchCount, 1);
    });

    test("onSuccess should be called if successful", () async {
      const response = "this is a response";
      String? res;
      final query = Query<String>(
        key: "onSuccess",
        onSuccess: (dynamic r) => res = r as String,
        queryFn: () async {
          return response;
        },
      );
      await query.result;
      expect(res, response);
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
    test("Initial data is sent first", () async {
      const initialData = "initial data";
      final state = await Query(
        key: "initialStream",
        queryFn: fetchFunction,
        initialData: initialData,
      ).stream.first;
      expect(state.data, initialData);
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
    final storage = MockStorage();
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
        config: QueryConfig(
          storeQuery: false,
        ),
      );
      await query.result;
      expect(storage.store.length, 0);
    });

    test("Should get initial data from storage before queryFn", () async {
      const key = "getInitial";
      // Make sure the storage has initial data
      storage.put(key, item: MockStorage.data);
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
              expect(output[0], MockStorage.data);
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
          key: {"name": MockStorage.data}
        },
      );
      final query = Query<Serializable>(
        key: key,
        queryFn: () async => Future.value(Serializable("Fetched")),
        config: QueryConfig(
          serializer: (dynamic json) =>
              Serializable.fromJson(json as Map<String, dynamic>),
        ),
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
              expect((output[0] as Serializable).name, MockStorage.data);
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
    test("onError should be called", () async {
      String? error;
      final query = Query<String>(
        key: "error2",
        onError: (dynamic e) => error = e as String,
        queryFn: () async {
          throw "this is an error";
        },
      );
      await query.result;
      expect(error, "this is an error");
    });
  });
  test("Can set local query config", () {
    final query = Query(
      key: "local",
      config: QueryConfig(shouldRethrow: true),
      queryFn: () async => "",
    );

    expect(query.config.shouldRethrow, true);
  });
}

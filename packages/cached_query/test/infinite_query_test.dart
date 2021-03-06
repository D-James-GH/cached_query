import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'mock_storage.dart';
import 'repos/infinite_query_test_repo.dart';

void main() async {
  final repo = InfiniteQueryTestRepository();
  final cachedQuery = CachedQuery.instance;
  group("creating a query", () {
    tearDownAll(cachedQuery.deleteCache);
    test("query is created and added to cache", () {
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: repo.getPosts,
        getNextArg: (state) {
          if (state.lastPage == null) return 1;
          if (state.lastPage!.isEmpty) return null;

          return state.length + 1;
        },
      );

      final queryFromCache =
          cachedQuery.getQuery(InfiniteQueryTestRepository.key);
      expect(query, queryFromCache);
    });
    test("Can set initial data", () {
      final query = InfiniteQuery<String, int>(
        key: "initial",
        queryFn: repo.getPosts,
        getNextArg: (state) => 1,
        initialData: ["initialData"],
      );
      expect(query.state.data!.first, "initialData");
    });
    test("Initial data is first in stream", () async {
      final initialQuery = await InfiniteQuery<String, int>(
        key: "initial",
        queryFn: repo.getPosts,
        getNextArg: (state) => 1,
        initialData: ["initialData"],
      ).stream.first;
      expect(initialQuery.data!.first, "initialData");
    });
  });
  group("Infinite query as a future", () {
    tearDown(cachedQuery.deleteCache);
    test("Should return an infinite query", () async {
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: repo.getPosts,
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
      final res = await query.result;
      expect(res, isA<InfiniteQueryState<String>>());
    });
    test("Query result returns data", () async {
      final query = InfiniteQuery<String, int>(
        key: "Posts",
        queryFn: repo.getPosts,
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
      final res = await query.result;
      expect(res.data?.isNotEmpty, true);
    });
    test("Query result returns data with refetch duration set", () async {
      final query = InfiniteQuery<String, int>(
        key: "Posts",
        queryFn: repo.getPosts,
        config: const QueryConfig(
          refetchDuration: Duration(milliseconds: 200),
        ),
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
      final res = await query.result;
      expect(res.data?.isNotEmpty, true);
    });
    test("calling query result twice is de-duped", () async {
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: (page) => Future.delayed(
          const Duration(seconds: 2),
          () => repo.getPosts(page),
        ),
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
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
      int fetchCount = 0;
      Future<String> createResponse(int page) {
        fetchCount++;
        return repo.getPosts(page);
      }

      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: createResponse,
        config: const QueryConfig(
          refetchDuration: Duration(seconds: 5),
        ),
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
      await query.result;
      await InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: createResponse,
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      ).result;
      expect(fetchCount, 1);
    });
    test("re-fetching does not give the same result", () async {
      int fetchCount = 0;
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: (page) {
          fetchCount++;
          return repo.getPosts(page);
        },
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
      await query.result;
      await query.refetch();
      expect(fetchCount, 2);
    });
    test("Should refetch list after refetchDuration", () async {
      int fetchCount = 0;
      final query = InfiniteQuery<String, int>(
        key: "refetch list",
        config: const QueryConfig(
          refetchDuration: Duration.zero,
        ),
        getNextArg: (state) => state.length + 1,
        queryFn: (page) {
          fetchCount++;
          return Future.value("$page");
        },
      );
      await query.result;
      await query.result;
      expect(fetchCount, 2);
    });
  });
  group("Infinite query args", () {
    tearDown(cachedQuery.deleteCache);
    test("Initial index", () async {
      final query = InfiniteQuery<int, int>(
        key: "initialIndex",
        queryFn: repo.getPage,
        getNextArg: (state) {
          if (state.lastPage == null && state.length != 0) return null;
          return state.length + 1;
        },
      );
      final res = await query.result;
      expect(res.data![0], 1);
    });

    test("Should get next page based on next args", () async {
      const initialIndex = 1;
      final query = InfiniteQuery<int, int>(
        key: "nextPage",
        queryFn: repo.getPage,
        getNextArg: (state) {
          if (state.length == 0) return initialIndex;
          return state.length + 1;
        },
      );
      await query.result;
      final res = await query.getNextPage();
      expect(res!.lastPage, 2);
    });
  });
  group("Infinite Query storage", () {
    final storage = MockStorage();
    setUpAll(() => CachedQuery.instance.config(storage: storage));
    tearDown(() {
      storage.deleteAll();
      cachedQuery.deleteCache();
    });

    test("Should store infinite query on fetch", () async {
      const key = "store";
      storage.deleteAll();

      final query = InfiniteQuery<int, int>(
        key: key,
        queryFn: repo.getPage,
        getNextArg: (state) {
          if (state.length == 0) return 0;
          return state.length + 1;
        },
      );
      await query.result;
      expect(storage.store.length, 1);
      expect(storage.store[key], jsonEncode([0]));
    });

    test("Should not store infinite query if specified", () async {
      storage.deleteAll();
      const key = "store";
      final query = InfiniteQuery<int, int>(
        key: key,
        config: const QueryConfig(storeQuery: false),
        queryFn: repo.getPage,
        getNextArg: (state) {
          if (state.length == 0) return 0;
          return state.length + 1;
        },
      );
      await query.result;
      expect(storage.store.length, 0);
    });

    test("Should get Infinite Query initial data from storage before queryFn",
        () async {
      const key = "getInitial";
      const initialData = [3];
      // Make sure the storage has initial data
      storage.put(key, item: initialData);
      final query = InfiniteQuery<int, int>(
        key: key,
        queryFn: repo.getPage,
        getNextArg: (state) {
          if (state.length == 0) return 0;
          return state.length + 1;
        },
      );

      final output = <List<int>>[];
      query.stream.listen(
        expectAsync1(
          (event) {
            if (event.data != null && event.data!.isNotEmpty) {
              output.add(event.data!);
            }
            if (output.length == 1) {
              expect(output[0], initialData);
            }
          },
          max: 3,
        ),
      );
    });

    test("Should serialize data if a serialize function is provided", () async {
      const key = "serialize";
      // Make sure the storage has initial data
      storage.put(key, item: jsonEncode([Serializable(MockStorage.data)]));
      final query = InfiniteQuery<Serializable, int>(
        key: key,
        queryFn: (i) => Future.value(Serializable("$i")),
        config: QueryConfig(
          serializer: (dynamic json) {
            return Serializable.listFromJson(json as List<dynamic>);
          },
        ),
        getNextArg: (state) {
          if (state.length == 0) return 0;
          return state.length + 1;
        },
      );

      int count = 1;
      final output = <dynamic>[];
      query.stream.listen(
        expectAsync1(
          (event) {
            if (event.data != null && event.data!.isNotEmpty) {
              output.add(event.data!);
            }
            if (output.length == 1 || count == 2) {
              expect(output[0], isA<List<Serializable>>());
              expect(
                (output[0] as List<Serializable>).first.name,
                MockStorage.data,
              );
            }
            count++;
          },
          max: 3,
          count: 2,
        ),
      );
    });
    test("Storage should update on each fetch", () async {
      int count = 0;
      const key = "updateStore";
      final query = InfiniteQuery<int, int>(
        key: key,
        getNextArg: (state) {
          if (state.length == 0) return 0;
          return state.length + 1;
        },
        queryFn: (page) {
          count++;
          return Future.value(count);
        },
      );
      await query.result;
      final res2 = await query.refetch();
      expect((jsonDecode(storage.store[key]!) as List).first, count);
      expect(
        (jsonDecode(storage.store[key]!) as List).first,
        res2.data!.first,
      );
    });
  });
}

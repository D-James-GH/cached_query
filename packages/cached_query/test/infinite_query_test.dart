import 'dart:convert';
import 'dart:math';

import 'package:cached_query/cached_query.dart';
import 'package:test/test.dart';

import 'repos/infinite_query_test_repo.dart';
import 'test_implementations.dart';

void main() async {
  final repo = InfiniteQueryTestRepository();
  group("creating a query", () {
    test("query is created and added to cache", () {
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: repo.getPosts,
        getNextArg: (state) {
          if (state == null) return 1;
          if (state.pages.last.isEmpty) return null;

          return state.pages.length + 1;
        },
      );

      final queryFromCache =
          CachedQuery.instance.getQuery(InfiniteQueryTestRepository.key);
      expect(query, queryFromCache);
    });
    test("Can set initial data", () {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: "initial",
        queryFn: repo.getPosts,
        getNextArg: (state) => 1,
        cache: cache,
        initialData: InfiniteQueryData(pages: ["initialData"], args: [1]),
      );
      expect(query.state.data!.pages.first, "initialData");
    });
    test("Initial data is considered fresh", () async {
      final cache = CachedQuery.asNewInstance();
      final initialData = InfiniteQueryData(pages: ["initialData"], args: [1]);
      final query = InfiniteQuery<String, int>(
        key: "initial-fresh",
        cache: cache,
        queryFn: repo.getPosts,
        getNextArg: (state) => 1,
        initialData: initialData,
      );
      final res = await query.fetch();
      expect(res.data, same(initialData));
    });
    test("Initial data is first in stream", () async {
      final initialQuery = await InfiniteQuery<String, int>(
        key: "initial",
        queryFn: repo.getPosts,
        getNextArg: (state) => 1,
        initialData: InfiniteQueryData(pages: ["initialData"], args: [1]),
      ).stream.first;
      expect(initialQuery.data!.pages.first, "initialData");
    });
  });
  group("Get next page", () {
    test("Can get next page", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: "getNext",
        cache: cache,
        queryFn: repo.getPosts,
        getNextArg: (state) {
          if (state == null) return 1;
          return (state.pages.length) + 1;
        },
      );
      await query.fetch();
      await query.getNextPage();

      expect(query.state.data?.pages.length, 2);
      expect(query.state.data?.args.length, 2);
    });
  });
  group("Accessing current state", () {
    test("state is accessible immediately after fetch", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: "accessState",
        cache: cache,
        queryFn: (_) => Future.value("data"),
        getNextArg: (_) => 1,
      );
      final res1 = await query.fetch();
      expect(res1, isA<InfiniteQuerySuccess<String, int>>());

      final query2 = InfiniteQuery<String, int>(
        key: "accessState",
        cache: cache,
        config: QueryConfig(
          staleDuration: const Duration(minutes: 5),
        ),
        queryFn: (_) => Future.value("data"),
        getNextArg: (_) => 1,
      );
      final res = await query2.getNextPage();
      expect(res, isA<InfiniteQuerySuccess<String, int>>());
    });
    test("state is accessible immediately after fetch with initial data",
        () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: "accessState",
        cache: cache,
        config: const QueryConfig(staleDuration: Duration.zero),
        initialData: InfiniteQueryData(pages: ["initial"], args: [1]),
        queryFn: (_) => Future.value("data"),
        getNextArg: (_) => 1,
      );

      final res1 = await query.fetch();
      expect(res1, isA<InfiniteQuerySuccess<String, int>>());
    });
  });
  group("Infinite query as a future", () {
    test("Should return an infinite query", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        cache: cache,
        queryFn: repo.getPosts,
        getNextArg: (state) {
          if (state == null) return 1;
          return (state.pages.length) + 1;
        },
      );
      final res = await query.fetch();
      expect(res, isA<InfiniteQueryStatus<String, int>>());
    });
    test("Query result returns data", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: "Posts",
        queryFn: repo.getPosts,
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      );
      final res = await query.fetch();
      expect(res is InfiniteQuerySuccess, true);
      expect(res.data?.pages.isNotEmpty, true);
    });
    test("Query result returns data with refetch duration set", () async {
      final query = InfiniteQuery<String, int>(
        key: "Posts",
        queryFn: repo.getPosts,
        config: QueryConfig(
          staleDuration: const Duration(milliseconds: 200),
        ),
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      );
      final res = await query.fetch();
      expect(res.data?.pages.isNotEmpty, true);
    });
    test("calling query result twice is de-duped", () async {
      final query = InfiniteQuery<String, int>(
        key: InfiniteQueryTestRepository.key,
        queryFn: (page) => Future.delayed(
          const Duration(seconds: 2),
          () => repo.getPosts(page),
        ),
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      );
      String res1 = "";
      String res2 = "";
      query.fetch().whenComplete(() {
        res1 = DateTime.now().toString();
      });
      query.fetch().whenComplete(() {
        res2 = DateTime.now().toString();
      });
      expect(res1, res2);
    });
    test("Adding refetchDuration means next result will come from cache.",
        () async {
      final cache = CachedQuery.asNewInstance();
      int fetchCount = 0;
      Future<String> createResponse(int page) {
        fetchCount++;
        return repo.getPosts(page);
      }

      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: InfiniteQueryTestRepository.key,
        queryFn: createResponse,
        config: QueryConfig(
          staleDuration: const Duration(seconds: 5),
        ),
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      );
      await query.fetch();
      await InfiniteQuery<String, int>(
        cache: cache,
        key: InfiniteQueryTestRepository.key,
        queryFn: createResponse,
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      ).fetch();
      expect(fetchCount, 1);
    });
    test("re-fetching does not give the same result", () async {
      final cache = CachedQuery.asNewInstance();
      int fetchCount = 0;
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: InfiniteQueryTestRepository.key,
        queryFn: (page) {
          fetchCount++;
          return repo.getPosts(page);
        },
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      );
      await query.fetch();
      await query.refetch();
      expect(fetchCount, 2);
    });

    test("invalidate should refetch if query is active", () async {
      final cache = CachedQuery.asNewInstance();
      int fetchCount = 0;
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: InfiniteQueryTestRepository.key,
        queryFn: (page) {
          fetchCount++;
          return repo.getPosts(page);
        },
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
      );
      query.stream.listen((_) {});
      await query.fetch();
      await query.invalidate();
      expect(fetchCount, 2);
    });
  });
  group("Controlling refetch", () {
    test('Can prevent everything refetching if first page is the same',
        () async {
      int page1Count = 0;
      int page2Count = 0;
      final query = InfiniteQuery<String, int>(
        key: "refetch list",
        onPageRefetched: (page, currentResult, cachedData) {
          if (page == cachedData.pages.firstOrNull &&
              currentResult.pages.length == 1) {
            return cachedData;
          }
          return null;
        },
        config: QueryConfig(
          staleDuration: Duration.zero,
        ),
        getNextArg: (state) {
          return (state?.pages.length ?? 0) + 1;
        },
        queryFn: (page) {
          if (page == 1) {
            page1Count++;
          }
          if (page == 2) {
            page2Count++;
          }
          return Future.value("$page");
        },
      );
      await query.fetch();
      await query.getNextPage();
      await query.refetch();
      // page1 should be re-fetched but page2 shouldn't as the data from page1 will
      // not have changed
      expect(page1Count, 2);
      expect(page2Count, 1);
    });

    test("If the first page changes re-fetch first pages Only", () async {
      int page1Count = 0;
      int page2Count = 0;

      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: "refetchNotFirstPage",
        cache: cache,
        config: QueryConfig(
          staleDuration: Duration.zero,
        ),
        onPageRefetched: (page, currentResult, cachedData) {
          if (page != cachedData.pages.firstOrNull &&
              currentResult.pages.length == 1) {
            return currentResult;
          }
          return null;
        },
        getNextArg: (state) {
          final res = (state?.pages.length ?? 0) + 1;
          return res;
        },
        queryFn: (page) {
          if (page == 1) {
            page1Count++;
          }
          if (page == 2) {
            page2Count++;
          }
          final randomNum = Random().nextInt(1000);
          return Future.value("$page$randomNum");
        },
      );
      await query.fetch();
      await query.getNextPage();
      expect(query.state.data?.pages.length, 2);
      await query.refetch();
      // page1 should be re-fetched but page2 shouldn't as the data from page1 will
      // not have changed
      expect(page1Count, 2);
      expect(page2Count, 1);
      expect(query.state.data?.pages.length, 1);
    });
  });
  group("Infinite re-fetching", () {
    test("Should refetch list after refetchDuration", () async {
      final cache = CachedQuery.asNewInstance();
      int fetchCount = 0;
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: "refetch list",
        config: QueryConfig(
          staleDuration: Duration.zero,
        ),
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
        queryFn: (page) {
          fetchCount++;
          return Future.value("$page");
        },
      );
      await query.fetch();
      await query.fetch();
      expect(fetchCount, 2);
    });
    test("Page should be the same on refetch", () async {
      int fetchCount = 0;
      int? page1;
      int? page2;
      final query = InfiniteQuery<String, int>(
        key: "refetch list",
        config: QueryConfig(
          staleDuration: Duration.zero,
        ),
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
        queryFn: (page) {
          if (fetchCount == 0) {
            page1 = page;
          }
          if (fetchCount == 1) {
            page2 = page;
          }

          fetchCount++;

          return Future.value("$page");
        },
      );
      await query.fetch();
      await query.fetch();
      expect(page1, page2);
    });
    test("revalidating resets the timestamp", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        key: "different_time",
        config: QueryConfig(
          staleDuration: Duration.zero,
        ),
        cache: cache,
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
        queryFn: (page) {
          final randomNum = Random().nextInt(1000);
          return Future.value("$page$randomNum");
        },
      );
      final res1 = await query.fetch();
      final time1 = res1.timeCreated;
      final res2 = await query.refetch();
      final time2 = res2.timeCreated;
      expect(time2, isNot(time1));
    });
  });
  group("Has Reached Max", () {
    test("hasReachedMax should be true if no more args", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: "hasReachedMax",
        queryFn: repo.getPosts,
        getNextArg: (state) {
          final dataLength = state?.pages.length ?? 0;
          if (dataLength > 2) return null;
          if (state?.pages.lastOrNull == null && dataLength != 0) return null;
          return dataLength + 1;
        },
      );
      await query.fetch();
      await query.getNextPage();
      await query.getNextPage();
      expect(query.hasReachedMax(), true);
    });

    test(
        "OLD TEST COMPATIBILITY hasReachedMax resets if refetch changes the data",
        () async {
      final query = InfiniteQuery<String, int>(
        key: "hasReachedMax",
        onPageRefetched: (page, currentResult, cachedData) {
          if (page != cachedData.pages.firstOrNull &&
              currentResult.pages.length == 1) {
            return currentResult;
          }
          return null;
        },
        queryFn: (page) {
          if (page == 1) return repo.getPosts(Random().nextInt(1000));
          return repo.getPosts(page);
        },
        getNextArg: (state) {
          final dataLength = state?.pages.length ?? 0;
          if (dataLength > 2) return null;
          if (state?.pages.lastOrNull == null && dataLength != 0) return null;
          return dataLength + 1;
        },
      );
      await query.fetch();
      await query.getNextPage();
      final res1 = await query.getNextPage();
      expect(res1!.data?.pages.length, 3);
      expect(query.hasReachedMax(), true);
      final res2 = await query.refetch();
      expect(res2.data?.pages.length, 1);
      expect(query.hasReachedMax(), false);
    });
  });
  group("Infinite query args", () {
    test("Initial index", () async {
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<int, int>(
        key: "initialIndex",
        cache: cache,
        queryFn: repo.getPage,
        getNextArg: (state) {
          final dataLength = state?.pages.length ?? 0;
          if (dataLength > 2) return null;
          if (state?.pages.lastOrNull == null && dataLength != 0) return null;
          return dataLength + 1;
        },
      );
      final res = await query.fetch();
      expect(res.data?.pages.first, 1);
    });

    test("Should get next page based on next args", () async {
      final query = InfiniteQuery<int, int>(
        key: "nextPage",
        queryFn: repo.getPage,
        getNextArg: (state) {
          final dataLength = state?.pages.length ?? 0;
          if (dataLength > 2) return null;
          if (state?.pages.lastOrNull == null && dataLength != 0) return null;
          return dataLength + 1;
        },
      );
      await query.fetch();
      final res = await query.getNextPage();
      expect(res!.lastPage, 2);
    });
  });
  group("Infinite Query storage", () {
    TestStorage? storage;
    CachedQuery? cache;
    setUp(() {
      storage = TestStorage();
      cache = CachedQuery.asNewInstance()
        ..config(storage: storage, config: GlobalQueryConfig(storeQuery: true));
    });
    tearDown(() {
      storage = null;
      cache = null;
    });

    test("Should not return if expired", () async {
      const key = "expired";
      const expiredData = "expiredData";
      const newData = "newData";
      const storageDuration = Duration(minutes: 1);
      storage!.put(
        StoredQuery(
          key: key,
          data: [expiredData],
          storageDuration: storageDuration,
          createdAt: DateTime.now().subtract(
            const Duration(days: 1),
          ),
        ),
      );

      final query = InfiniteQuery<String, int>(
        key: key,
        cache: cache,
        config: QueryConfig(storageDuration: storageDuration),
        getNextArg: (state) => 1,
        queryFn: (p) => Future.value(newData),
      );

      final firstData = await query.stream.firstWhere(
        (element) => element.data != null && element.data!.pages.isNotEmpty,
      );
      expect(firstData.data?.pages.first, newData);
    });

    test("Should return stored if not expired", () async {
      const key = "notExpired";
      const data = "data";
      const storageDuration = Duration(minutes: 1);
      storage!.put(
        StoredQuery(
          key: key,
          data: InfiniteQueryData(pages: [data], args: [1]),
          storageDuration: storageDuration,
          createdAt: DateTime.now(),
        ),
      );

      final query = InfiniteQuery<String, int>(
        key: key,
        cache: cache,
        getNextArg: (state) => 1,
        config: QueryConfig(storageDuration: storageDuration),
        queryFn: (p) => Future.value("newData"),
      );

      final firstData = await query.stream.firstWhere(
        (element) => element.data != null && element.data!.pages.isNotEmpty,
      );
      expect(firstData.data?.pages.first, data);
    });
    test("Should store using serializer if available", () async {
      const key = "store";
      const convertedData = [1000];

      final query = InfiniteQuery<int, int>(
        key: key,
        cache: cache,
        queryFn: repo.getPage,
        config: QueryConfig(
          storageSerializer: (dynamic json) => convertedData,
        ),
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      await query.fetch();
      expect(storage!.queries.length, 1);
      expect(
        storage!.queries[key]!.data,
        convertedData,
      );
    });

    test("Should not store infinite query if specified", () async {
      const key = "store";
      final query = InfiniteQuery<int, int>(
        cache: cache,
        key: key,
        config: QueryConfig(storeQuery: false),
        queryFn: repo.getPage,
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      await query.fetch();
      expect(storage!.queries.length, 0);
    });

    test("Should get Infinite Query initial data from storage before queryFn",
        () async {
      const key = "getInitial";
      const initialData = [3];
      final storedQuery = StoredQuery(
        key: key,
        data: InfiniteQueryData(pages: initialData, args: [1]),
        createdAt: DateTime.now(),
      );
      // Make sure the storage has initial data
      storage!.put(storedQuery);
      final query = InfiniteQuery<int, int>(
        key: key,
        cache: cache,
        queryFn: repo.getPage,
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );

      final output = <List<int>>[];
      query.stream.listen(
        expectAsync1(
          (event) {
            if (event.data != null && event.data!.pages.isNotEmpty) {
              output.add(event.data!.pages);
            }
            if (output.length == 1) {
              expect(output[0], initialData);
            }
          },
          max: 10,
        ),
      );
    });

    test("Should deserialize data provided", () async {
      const key = "serialize";
      final storedQuery = StoredQuery(
        key: key,
        data: jsonEncode(
          InfiniteQueryData(
            pages: [Serializable(testQueryRes)],
            args: [1],
          ),
        ),
        createdAt: DateTime.now(),
      );
      storage!.put(storedQuery);
      final query = InfiniteQuery<Serializable, int>(
        cache: cache,
        key: key,
        queryFn: (i) => Future.value(Serializable("fetched")),
        config: QueryConfig(
          shouldFetch: (key, data, createdAt) {
            if (data != null) {
              return false;
            }
            return true;
          },
          storageDeserializer: (str) {
            final json = jsonDecode(str as String) as Map<String, dynamic>;
            return InfiniteQueryData(
              pages: Serializable.listFromJson(json["pages"] as List<dynamic>),
              args: (json["args"] as List<dynamic>).cast<int>(),
            );
          },
        ),
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      final res = await query.fetch();
      expect(res.isError, false);
      expect(res.data!.pages[0].name, testQueryRes);
    });
    test("Storage should update on each fetch", () async {
      int count = 0;
      const key = "updateStore";
      final query = InfiniteQuery<int, int>(
        key: key,
        cache: cache,
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
        queryFn: (page) {
          count++;
          return Future.value(count);
        },
      );
      await query.fetch();
      final res2 = await query.refetch();
      final stored = await storage!.get(key);
      final pages = (stored!.data as InfiniteQueryData<int, int>).pages;
      expect(
        pages.first,
        count,
      );
      expect(
        pages.first,
        res2.data!.pages.first,
      );
    });

    test("Can prevent queryFn being fired after fetch from storage", () async {
      int numCalls = 0;
      const key = "query_no_fetch_storage";
      const data = 1000;
      storage!.put(
        StoredQuery(
          key: key,
          data: InfiniteQueryData(
            pages: [data],
            args: [1],
          ),
          createdAt: DateTime.now(),
        ),
      );

      final query = InfiniteQuery<int, int>(
        key: key,
        cache: cache,
        getNextArg: (state) => 2,
        queryFn: (_) {
          numCalls++;
          return Future.value(1);
        },
        config: QueryConfig(
          shouldFetch: (key, data, createdAt) {
            if (data != null) {
              return false;
            }
            return true;
          },
          staleDuration: Duration.zero,
        ),
      );

      final res = await query.fetch();

      expect(numCalls, 0);
      expect(res.data!.pages, [data]);
    });
  });
  group("Side Effects", () {
    test("onSuccess is called when succeeds", () async {
      String? response;
      final query = InfiniteQuery<String, int>(
        key: "succeeds",
        queryFn: (page) {
          return Future.value(page.toString());
        },
        onSuccess: (r) => response = r.pages.first.toString(),
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      final res = await query.fetch();
      expect(response, res.data?.pages.first);
    });

    test("onSuccess is called when getNext page succeeds", () async {
      String? response;
      final cache = CachedQuery.asNewInstance();
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: "succeeds",
        queryFn: (page) {
          return Future.value(page.toString());
        },
        onSuccess: (r) {
          response = r.pages.last.toString();
        },
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      await query.fetch();
      final res = await query.getNextPage();
      expect(response, res?.data?.pages.last);
    });

    test("onError is called when initial fails", () async {
      String? response;
      dynamic error;
      final query = InfiniteQuery<String, int>(
        key: "fails",
        queryFn: (page) {
          throw "error";
        },
        onSuccess: (dynamic r) => response = r.toString(),
        onError: (dynamic e) => error = e,
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      final res = await query.fetch();
      expect(response, isNull);
      expect(res, isA<InfiniteQueryError<String, int>>());
      expect(error, (res as InfiniteQueryError).error);
    });

    test("onError is called when getNext page fails", () async {
      final cache = CachedQuery.asNewInstance();
      dynamic error;
      int count = 0;
      final query = InfiniteQuery<String, int>(
        cache: cache,
        key: "fails",
        queryFn: (page) {
          if (page == 2) {
            throw "error";
          }
          return Future.value(page.toString());
        },
        onError: (dynamic e) => error = e,
        onSuccess: (_) => count++,
        getNextArg: (state) => (state?.pages.length ?? 0) + 1,
      );
      await query.fetch();
      final res = await query.getNextPage();
      expect(count, 1);
      expect(error, (res as InfiniteQueryError?)?.error);
    });
  });

  group("Should refetch", () {
    test("query should never refresh if returning false", () async {
      final cache = CachedQuery.asNewInstance();
      int numCalls = 0;
      final query = InfiniteQuery(
        cache: cache,
        key: "infinite_query_no_refetch",
        getNextArg: (state) => 1,
        queryFn: (_) {
          numCalls++;
          return Future.value(1);
        },
        config: QueryConfig(
          shouldFetch: (_, __, ___) => false,
          staleDuration: Duration.zero,
        ),
      );

      await query.fetch();
      await query.fetch();

      expect(numCalls, 0);
    });

    test("can still force refetch", () async {
      int numCalls = 0;
      final query = InfiniteQuery(
        key: "infinite_query_force_refetch",
        getNextArg: (state) => 1,
        queryFn: (_) {
          numCalls++;
          return Future.value(1);
        },
        config: QueryConfig(
          // shouldRefetch: (query, _) => false,
          staleDuration: Duration.zero,
        ),
      );

      await query.fetch();
      await query.refetch();

      expect(numCalls, 2);
    });
  });

  group("Caching Query", () {
    test("Two keys retrieve the same instance of cached data", () {
      final cache = CachedQuery.asNewInstance();
      Future<TestObject> queryFunction(int page) => Future.value(TestObject());
      final query1 = InfiniteQuery(
        cache: cache,
        key: "same",
        queryFn: queryFunction,
        getNextArg: (_) => 1,
      );
      final query2 = InfiniteQuery(
        cache: cache,
        key: "same",
        queryFn: queryFunction,
        getNextArg: (_) => 1,
      );
      expect(query1.state.data, same(query2.state.data));
    });
    test("Pass a cache to add query to", () {
      final cache = CachedQuery.asNewInstance();
      Future<String> queryFunction(int page) => Future.value("data");
      final query = InfiniteQuery(
        key: "cacheInstance1",
        queryFn: queryFunction,
        getNextArg: (_) => 1,
        cache: cache,
      );
      expect(cache.getQuery("cacheInstance1"), query);
    });

    test("Can pass CachedQuery for separation", () async {
      Future<String> queryFunction(int page) => Future.value("data");
      final cache = CachedQuery.asNewInstance();
      const key = "differentCaches";

      final query1 = InfiniteQuery(
        key: key,
        queryFn: queryFunction,
        getNextArg: (_) => 1,
        cache: cache,
      );

      final query2 = InfiniteQuery(
        key: key,
        queryFn: queryFunction,
        getNextArg: (_) => 1,
      );

      expect(query1, isNot(same(query2)));
    });
  });
}

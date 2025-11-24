import 'dart:async';

import 'package:cached_query/cached_query.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

import 'testers/query_tester.dart';

void main() {
  test("Can set resume config per query", () async {
    final streamController = StreamController<AppState>();
    final cache = CachedQuery.asNewInstance()
      ..config(
        config: GlobalQueryConfig(
          refetchOnResumeMinBackgroundDuration: Duration.zero,
        ),
        lifecycleStream: streamController.stream,
      );
    final tester1 = QueryTester(
      cache: cache,
      config: const QueryConfig(
        staleDuration: Duration.zero,
        refetchOnResume: true,
      ),
    )..query.stream.listen((_) {});
    final tester2 = QueryTester(
      cache: cache,
      config: const QueryConfig(
        staleDuration: Duration.zero,
        refetchOnResume: false,
      ),
    )..query.stream.listen((_) {});

    await Future.wait([
      tester1.query.fetch(),
      tester2.query.fetch(),
    ]);
    streamController
      ..add(AppState.background)
      ..add(AppState.foreground);
    await Future<void>.delayed(Duration.zero);
    expect(tester1.numFetches, 2);
    expect(tester2.numFetches, 1);
  });

  test("Can override global config", () {
    final cache = CachedQuery.asNewInstance()
      ..config(
        config: const GlobalQueryConfig(refetchOnResume: false),
      );
    final q = Query<String>(
      cache: cache,
      key: "global",
      queryFn: () async => "",
      config: const QueryConfig(refetchOnResume: true),
    );
    expect(q.config.refetchOnResume, true);
  });
  test("On resume will only fetch queries with listeners", () async {
    final streamController = StreamController<AppState>();
    final cache = CachedQuery.asNewInstance()
      ..config(
        config: GlobalQueryConfig(
          refetchOnResumeMinBackgroundDuration: Duration.zero,
        ),
        lifecycleStream: streamController.stream,
      );
    int listenerFetches = 0;
    final queryWithListener = Query<String>(
      cache: cache,
      key: "withListener",
      queryFn: () async {
        listenerFetches++;
        return "data";
      },
      config: const QueryConfig(
        staleDuration: Duration.zero,
        refetchOnResume: true,
      ),
    );
    final subListener = queryWithListener.stream.listen((_) {});

    int noListenerFetches = 0;
    final queryWithoutListener = Query<String>(
      cache: cache,
      key: "withoutListener",
      queryFn: () async {
        noListenerFetches++;
        return "data";
      },
      config: const QueryConfig(
        staleDuration: Duration.zero,
        refetchOnResume: true,
      ),
    );
    final subNoListener = queryWithoutListener.stream.listen((_) {});
    await Future.wait([
      queryWithListener.fetch(),
      queryWithoutListener.fetch(),
    ]);
    await subNoListener.cancel();

    streamController
      ..add(AppState.background)
      ..add(AppState.foreground);
    await Future<void>.delayed(Duration.zero);
    expect(listenerFetches, 2);
    expect(noListenerFetches, 1);
    await subListener.cancel();
  });

  test("Can prevent resume with min refetch background", () async {
    final streamController = StreamController<AppState>();
    final cache = CachedQuery.asNewInstance()
      ..config(
        config: GlobalQueryConfig(
          staleDuration: Duration.zero,
          refetchOnResumeMinBackgroundDuration: Duration(milliseconds: 50),
        ),
        lifecycleStream: streamController.stream,
      );
    final tester1 = QueryTester(cache: cache)..query.stream.listen((_) {});

    await tester1.query.fetch();

    expect(tester1.numFetches, 1);
    streamController.add(AppState.background);
    await Future<void>.delayed(Duration(milliseconds: 10));
    streamController.add(AppState.foreground);

    expect(tester1.numFetches, 1);

    streamController.add(AppState.background);
    await Future<void>.delayed(Duration(milliseconds: 50));
    streamController.add(AppState.foreground);
    await pumpEventQueue();

    expect(tester1.numFetches, 2);
  });

  test("Sending multiple states does not re-trigger", () async {
    final streamController = StreamController<AppState>();
    final cache = CachedQuery.asNewInstance()
      ..config(
        config: GlobalQueryConfig(
          staleDuration: Duration.zero,
          refetchOnResumeMinBackgroundDuration: Duration.zero,
        ),
        lifecycleStream: streamController.stream,
      );
    final tester1 = QueryTester(cache: cache)..query.stream.listen((_) {});

    await tester1.query.fetch();
    streamController
      ..add(AppState.background)
      ..add(AppState.foreground)
      ..add(AppState.foreground)
      ..add(AppState.foreground)
      ..add(AppState.foreground);

    await Future<void>.delayed(Duration.zero);

    expect(tester1.numFetches, 2);
  });
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers/is_query_state.dart';
import 'repo/query_repo.dart';
import 'utils/expect_query_states.dart';

void main() {
  group("Query listener", () {
    setUp(CachedQuery.instance.deleteCache);

    testWidgets(
      "Builds widget with supplied child and calls listener",
      (tester) async {
        const response = "My Title";
        const child = Text('Hello world');
        final sink = expectQueryStates<String>([
          isQueryState(
            QueryStatus.loading(
              isInitialFetch: true,
              timeCreated: DateTime.now(),
              isRefetching: false,
            ),
          ),
          isQueryState(
            QueryStatus.success(
              timeCreated: DateTime.now(),
              data: response,
            ),
          ),
        ]);
        await tester.pumpWidget(
          MaterialApp(
            home: QueryListener(
              query: const TitleRepo(response: response).fetchTitle(),
              listener: sink.add,
              child: child,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final childFinder = find.byWidget(child);
        expect(childFinder, findsOneWidget);
      },
    );

    testWidgets(
      "Does not call listener for loading state if listenWhen is supplied",
      (tester) async {
        const response = "My Title";
        const child = Text('Hello world');
        final sink = expectQueryStates<String>([
          isQueryState(
            QueryStatus.success(data: response, timeCreated: DateTime.now()),
          ),
        ]);
        await tester.pumpWidget(
          MaterialApp(
            home: QueryListener(
              query: const TitleRepo(response: response).fetchTitle(),
              listenWhen: (oldState, newState) => newState.isSuccess,
              listener: sink.add,
              child: child,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final childFinder = find.byWidget(child);
        expect(childFinder, findsOneWidget);
      },
    );

    testWidgets(
      "Query is build from key",
      (tester) async {
        const response = "My Title";
        const child = Text('Hello world');
        final sink = expectQueryStates<String>([
          isQueryState(
            QueryStatus.loading(
              isInitialFetch: true,
              timeCreated: DateTime.now(),
              isRefetching: false,
            ),
          ),
          isQueryState(
            QueryStatus.success(
              data: response,
              timeCreated: DateTime.now(),
            ),
          ),
        ]);
        const TitleRepo(response: response).fetchTitle();
        await tester.pumpWidget(
          MaterialApp(
            home: QueryListener(
              queryKey: TitleRepo.key,
              listener: sink.add,
              child: child,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final childFinder = find.byWidget(child);
        expect(childFinder, findsOneWidget);
      },
    );

    testWidgets(
      "Don't call query if enabled is false",
      (tester) async {
        const response = "My Title";
        const child = Text('Hello world');
        var queryCalled = false;
        const TitleRepo(response: response).fetchTitle(
          onQueryCalled: () {
            queryCalled = true;
          },
        );
        await tester.pumpWidget(
          MaterialApp(
            home: QueryListener(
              queryKey: TitleRepo.key,
              enabled: false,
              listener: (_) {},
              child: child,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(queryCalled, isFalse);
      },
    );
  });
}

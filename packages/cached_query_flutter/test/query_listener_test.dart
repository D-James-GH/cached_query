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
          isQueryState(status: QueryStatus.loading),
          isQueryState(status: QueryStatus.success, data: response),
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
          isQueryState(status: QueryStatus.success, data: response),
        ]);
        await tester.pumpWidget(
          MaterialApp(
            home: QueryListener(
              query: const TitleRepo(response: response).fetchTitle(),
              listenWhen: (oldState, newState) =>
                  newState.status == QueryStatus.success,
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
          isQueryState(status: QueryStatus.loading),
          isQueryState(status: QueryStatus.success, data: response),
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
  });
}

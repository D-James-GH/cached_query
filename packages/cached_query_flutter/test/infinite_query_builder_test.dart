import 'package:cached_query/cached_query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'components/list.dart';
import 'repo/infinite_query_repo.dart';

void main() {
  tearDown(CachedQuery.instance.deleteCache);
  group("Query builder", () {
    testWidgets("Builds widget based on query state", (tester) async {
      await tester.pumpWidget(const ListValue(response: "response"));
      await tester.pumpAndSettle();
      final titleFinder = find.text("0response");
      expect(titleFinder, findsOneWidget);
    });

    testWidgets("Builds twice, once loading second state", (tester) async {
      int buildCount = 0;
      await tester.pumpWidget(
        ListValue(
          response: "title",
          onBuild: () => buildCount++,
        ),
      );
      await tester.pumpAndSettle();
      expect(buildCount, 2);
    });

    testWidgets(
      "Tries to build twice, but only the first build is accepted",
      (tester) async {
        int buildCount = 0;
        await tester.pumpWidget(
          ListValue(
            response: "title",
            buildWhen: (_, __) => buildCount == 0,
            onBuild: () => buildCount++,
          ),
        );
        await tester.pumpAndSettle();
        expect(buildCount, 1);
      },
    );
    testWidgets("Enabled blocks request", (tester) async {
      InfiniteQueryRepo(response: "hello").fetchList();
      await tester.pumpWidget(
        const ListQuery(
          enabled: false,
          queryKey: InfiniteQueryRepo.queryKey,
        ),
      );
      await tester.pumpAndSettle();

      final emptyBoxFinder = find.byKey(const Key("empty-box"));
      expect(emptyBoxFinder, findsOneWidget);
      final titleFinder = find.text("title");
      expect(titleFinder, findsNothing);
      final enableButton = find.byKey(const Key("enable-button"));
      await tester.tap(enableButton);
      await tester.pumpAndSettle();

      expect(emptyBoxFinder, findsNothing);
      expect(titleFinder, findsOneWidget);
    });
    testWidgets("Infinite query builder from key", (tester) async {
      InfiniteQueryRepo(response: "response").fetchList();
      await tester.pumpWidget(
        const ListQuery(
          queryKey: InfiniteQueryRepo.queryKey,
        ),
      );
      await tester.pumpAndSettle();
      final titleFinder = find.text("response");
      expect(titleFinder, findsOneWidget);
    });
  });
}

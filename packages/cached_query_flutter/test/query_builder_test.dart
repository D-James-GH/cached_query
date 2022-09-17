import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'components/title.dart';
import 'components/title_value.dart';
import 'repo/query_repo.dart';

void main() {
  group("Query builder", () {
    setUp(CachedQuery.instance.deleteCache);

    testWidgets("Builds widget based on query state", (tester) async {
      const response = "My Title";
      await tester.pumpWidget(const TitleValue(response: response));
      await tester.pumpAndSettle();
      final titleFinder = find.text(response);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets("Builds twice, once loading second state", (tester) async {
      int buildCount = 0;
      await tester.pumpWidget(
        TitleValue(
          response: "title",
          onBuild: () => buildCount++,
        ),
      );
      await tester.pumpAndSettle();
      expect(buildCount, 2);
    });

    testWidgets("Query builds first with initial data", (tester) async {
      int buildCount = 0;
      const response = "My Title";
      await tester.pumpWidget(
        TitleValue(
          response: response,
          queryDelay: const Duration(seconds: 2),
          onBuild: () => buildCount++,
          initialTitle: "initial",
        ),
      );
      final initialTitleFinder = find.text("initial");
      expect(initialTitleFinder, findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final titleFinder = find.text(response);
      expect(titleFinder, findsOneWidget);
      expect(buildCount, 2);
    });
    testWidgets("Query is build from a key", (tester) async {
      const title = "title here";
      const TitleRepo(response: title).fetchTitle();
      await tester.pumpWidget(
        const Title(
          queryKey: TitleRepo.key,
        ),
      );
      await tester.pumpAndSettle();
      final titleFinder = find.text(title);
      expect(titleFinder, findsOneWidget);
    });
    testWidgets("Can update query key to update query", (tester) async {});
    testWidgets("Can update query to update query", (tester) async {});
  });
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TitleRepo {
  final String response;
  final Duration? queryDelay;
  const TitleRepo({this.queryDelay, required this.response});

  Query<String> fetchTitle({String? initialTitle}) {
    return Query<String>(
      key: "title",
      queryFn: () =>
          Future.delayed(queryDelay ?? Duration.zero, () => response),
      initialData: initialTitle,
      config: const QueryConfig(ignoreCacheDuration: true),
    );
  }
}

class Title extends StatelessWidget {
  final String response;
  final String? initialTitle;
  final void Function()? onBuild;
  final Duration? queryDelay;
  const Title({
    Key? key,
    required this.response,
    this.onBuild,
    this.initialTitle,
    this.queryDelay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QueryBuilder<String>(
        query: TitleRepo(response: response, queryDelay: queryDelay)
            .fetchTitle(initialTitle: initialTitle),
        builder: (context, state) {
          if (onBuild != null) {
            onBuild!();
          }
          if (state.data == null) {
            return const SizedBox();
          }
          return Text(state.data!, key: const Key("title-text"));
        },
      ),
    );
  }
}

void main() {
  group("Query builder", () {
    setUp(CachedQuery.instance.deleteCache);

    testWidgets("Builds widget based on query state", (tester) async {
      const response = "My Title";
      await tester.pumpWidget(const Title(response: response));
      await tester.pumpAndSettle();
      final titleFinder = find.text(response);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets("Builds twice, once loading second state", (tester) async {
      int buildCount = 0;
      await tester.pumpWidget(
        Title(
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
        Title(
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
  });
}

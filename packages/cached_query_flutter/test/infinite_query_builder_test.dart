import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ListRepo {
  final String response;
  ListRepo({required this.response});

  InfiniteQuery<String, int> fetchList() {
    return InfiniteQuery<String, int>(
      getNextArg: (state) {
        if (state.data == null) return 1;
        return state.data!.length + 1;
      },
      key: "title",
      queryFn: (page) async => response,
      config: const QueryConfig(ignoreCacheDuration: true),
    );
  }
}

class ListWidget extends StatelessWidget {
  final String response;
  final void Function()? onBuild;
  const ListWidget({Key? key, required this.response, this.onBuild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfiniteQueryBuilder<String, int>(
        query: ListRepo(response: response).fetchList(),
        builder: (context, state, query) {
          if (onBuild != null) {
            onBuild!();
          }
          if (state.data == null) {
            return const SizedBox();
          }
          return Column(
            children: [
              TextButton(
                key: const Key("button"),
                onPressed: () => query.getNextPage(),
                child: const Text("Get next page"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.data!.length,
                  itemBuilder: (context, i) {
                    return Text("$i$response");
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  group("Query builder", () {
    testWidgets("Builds widget based on query state", (tester) async {
      await tester.pumpWidget(const ListWidget(response: "response"));
      await tester.pumpAndSettle();
      final titleFinder = find.text("0response");
      expect(titleFinder, findsOneWidget);
    });

    testWidgets("Builds twice, once loading second state", (tester) async {
      int buildCount = 0;
      await tester.pumpWidget(
        ListWidget(
          response: "title",
          onBuild: () => buildCount++,
        ),
      );
      await tester.pumpAndSettle();
      expect(buildCount, 2);
    });
  });
}

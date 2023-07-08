import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../repo/infinite_query_repo.dart';

class ListQuery extends StatelessWidget {
  final Object queryKey;
  const ListQuery({Key? key, required this.queryKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfiniteQueryBuilder<String, int>(
        queryKey: queryKey,
        builder: (context, state, query) => ListView.builder(
          itemBuilder: (context, index) {
            if (state.data == null) return const SizedBox();
            return Text(state.data![index]);
          },
          itemCount: state.length,
        ),
      ),
    );
  }
}

class ListValue extends StatelessWidget {
  final String response;
  final void Function()? onBuild;
  final InfiniteQueryBuilderCondition<String>? buildWhen;

  const ListValue({
    Key? key,
    required this.response,
    this.onBuild,
    this.buildWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfiniteQueryBuilder<String, int>(
        buildWhen: buildWhen,
        query: InfiniteQueryRepo(response: response).fetchList(),
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

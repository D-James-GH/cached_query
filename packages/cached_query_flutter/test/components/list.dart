import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../repo/infinite_query_repo.dart';

class ListQuery extends StatefulWidget {
  final bool enabled;
  final Object queryKey;

  const ListQuery({Key? key, required this.queryKey, this.enabled = true})
      : super(key: key);

  @override
  State<ListQuery> createState() => _ListQueryState();
}

class _ListQueryState extends State<ListQuery> {
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InfiniteQueryBuilder<String, int>(
        queryKey: widget.queryKey,
        enabled: enabled,
        builder: (context, state, query) => ListView(
          children: [
            ElevatedButton(
              key: const Key("enable-button"),
              onPressed: () => setState(() {
                enabled = !enabled;
              }),
              child: const Text("enable"),
            ),
            if (state.data == null || state.data!.isEmpty) ...[
              const SizedBox(key: Key("empty-box")),
            ] else ...[
              const Text("title"),
              for (final item in state.data!) Text(item),
            ],
          ],
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
    super.key,
    required this.response,
    this.onBuild,
    this.buildWhen,
  });

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

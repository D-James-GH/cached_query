import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../repo/query_repo.dart';

class TitleValue extends StatefulWidget {
  final String response;
  final String? initialTitle;
  final bool enabled;
  final void Function()? onBuild;
  final Duration? queryDelay;
  final QueryBuilderCondition<QueryState<String>>? buildWhen;

  const TitleValue({
    super.key,
    required this.response,
    this.enabled = true,
    this.onBuild,
    this.initialTitle,
    this.queryDelay,
    this.buildWhen,
  });

  @override
  State<TitleValue> createState() => TitleValueState();
}

class TitleValueState extends State<TitleValue> {
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          ElevatedButton(
            key: const Key("enable-button"),
            onPressed: () => setState(() => enabled = !enabled),
            child: const Text("enable"),
          ),
          QueryBuilder<String>(
            enabled: enabled,
            query: TitleRepo(
              response: widget.response,
              queryDelay: widget.queryDelay,
            ).fetchTitle(initialTitle: widget.initialTitle),
            buildWhen: widget.buildWhen,
            builder: (context, state) {
              if (widget.onBuild != null) {
                widget.onBuild!();
              }
              if (state.data == null) {
                return const SizedBox(key: Key("empty-box"));
              }
              return Text(state.data!, key: const Key("title-text"));
            },
          ),
        ],
      ),
    );
  }
}

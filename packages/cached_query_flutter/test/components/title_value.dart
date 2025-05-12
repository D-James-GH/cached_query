import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

class TitleValue extends StatefulWidget {
  final bool enabled;
  final void Function()? onBuild;
  final QueryBuilderCondition<QueryState<String>>? buildWhen;
  final Query<String> query;

  const TitleValue({
    super.key,
    this.enabled = true,
    this.onBuild,
    this.buildWhen,
    required this.query,
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
          QueryBuilder<QueryState<String>>(
            enabled: enabled,
            query: widget.query,
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

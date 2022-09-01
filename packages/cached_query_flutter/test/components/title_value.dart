import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../repo/query_repo.dart';

class TitleValue extends StatelessWidget {
  final String response;
  final String? initialTitle;
  final void Function()? onBuild;
  final Duration? queryDelay;
  const TitleValue({
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
          if (state.data == null) return const SizedBox();
          return Text(state.data!, key: const Key("title-text"));
        },
      ),
    );
  }
}

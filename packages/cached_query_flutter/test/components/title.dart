import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String? initialTitle;
  final void Function()? onBuild;
  final Object queryKey;
  const Title({
    Key? key,
    this.onBuild,
    this.initialTitle,
    required this.queryKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QueryBuilder<String>(
        queryKey: queryKey,
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

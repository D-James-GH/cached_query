import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../service/post_service.dart' as service;

class Post extends StatelessWidget {
  final int id;
  final bool enabled;

  const Post({Key? key, required this.id, required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<QueryState<PostModel>>(
      enabled: enabled,
      // Can use key if the query already exists.
      queryKey: service.postKey(id),
      builder: (context, state) {
        final data = state.data;
        if (state.isError) return Text((state as QueryError).error.toString());
        if (data == null) return const SizedBox();
        return Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                "Title",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                data.title,
                textAlign: TextAlign.center,
              ),
              const Text(
                "Body",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                data.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

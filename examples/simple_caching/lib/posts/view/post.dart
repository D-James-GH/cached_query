import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../service/post_service.dart' as service;

class Post extends StatelessWidget {
  final int id;

  const Post({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<PostModel>(
      // Can use key if the query already exists.
      queryKey: service.postKey(id),
      builder: (context, state) {
        final data = state.data;
        if (state.error != null) return Text(state.error.toString());
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

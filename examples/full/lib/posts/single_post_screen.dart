import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:full/posts/post_model/post_model.dart';
import 'post_service.dart' as service;
import 'package:flutter/material.dart';

class SinglePostScreen extends StatelessWidget {
  final int id;

  const SinglePostScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Single Post"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              CachedQuery.instance.updateQuery(
                updateFn: (dynamic oldData) {
                  if (oldData is PostModel) {
                    return oldData.copyWith(title: "Changed title");
                  }
                },
                filterFn: (dynamic unencodedKey, key) =>
                    key.startsWith("posts/"),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Press the edit button at the top to edit all titles at once.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 50),
            QueryBuilder<PostModel>(
              query: service.getPostById(id),
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Post Id: ${state.data?.id}"),
                    Text("Post Title: ${state.data?.title}"),
                    Text("Post Body: ${state.data?.body}"),
                    Text("Post User: ${state.data?.userId}"),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),
            QueryBuilder<PostModel>(
              query: service.getPostById(id + 1),
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Post Id2: ${state.data?.id}"),
                    Text("Post Title2: ${state.data?.title}"),
                    Text("Post Body2: ${state.data?.body}"),
                    Text("Post User2: ${state.data?.userId}"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

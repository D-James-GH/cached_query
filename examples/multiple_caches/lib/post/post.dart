import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:multiple_caches/post/post_model/post_model.dart';

class Post extends StatelessWidget {
  final String title;
  final String queryKey;
  final void Function() onRefresh;
  final QueryState<PostModel> queryState;

  const Post({
    super.key,
    required this.queryKey,
    required this.queryState,
    required this.title,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final post = queryState.data;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          Text(
            "Query Key: $queryKey",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (post != null) ...[
            Text(
              "id: ${post.id}",
              textAlign: TextAlign.center,
            ),
            Text(
              "title: ${post.title}",
              textAlign: TextAlign.center,
            ),
            Text(
              "body: ${post.body}",
              textAlign: TextAlign.center,
            ),
          ],
          if (queryState.status == QueryStatus.loading)
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }
}

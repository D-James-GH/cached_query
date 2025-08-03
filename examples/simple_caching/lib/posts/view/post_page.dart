import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:simple_caching/posts/view/post.dart';

import '../service/post_service.dart' as service;

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int currentId = 50;
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: QueryBuilder(
          enabled: enabled,
          query: service.getPostById(currentId),
          builder: (context, state) {
            return Text(
              state.isLoading ? "loading..." : "",
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPost,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() => currentId = currentId - 1),
                  icon: const Icon(Icons.arrow_left),
                ),
                Text(currentId.toString()),
                IconButton(
                  onPressed: () => setState(() => currentId = currentId + 1),
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
            Post(id: currentId, enabled: enabled),
            ElevatedButton(
              onPressed: () => setState(() => enabled = true),
              child: const Text("Enable Query"),
            )
          ],
        ),
      ),
    );
  }

  void _refreshPost() {
    service.getPostById(currentId).refetch();
  }
}

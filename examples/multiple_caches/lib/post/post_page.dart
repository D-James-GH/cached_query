import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:multiple_caches/post/post.dart';
import 'package:multiple_caches/post/service.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final cache = CachedQuery.asNewInstance()..configFlutter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Demo of multiple cache's being used.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Refreshing one does not refresh the other even though they have the same key.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "This is because they are cached in separate places so the queries are separate.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                QueryBuilder(
                  query: getPostById(1, cache),
                  builder: (context, state) {
                    return Post(
                      queryKey: queryKey(1),
                      onRefresh: () => getPostById(1, cache).refetch(),
                      queryState: state,
                      title: "This query is saved using a local cache",
                    );
                  },
                ),
                const Divider(),
                QueryBuilder(
                  query: getPostById(1),
                  builder: (context, state) {
                    return Post(
                      queryKey: queryKey(1),
                      onRefresh: () => getPostById(1).refetch(),
                      queryState: state,
                      title: "This query is saved using a global cache",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

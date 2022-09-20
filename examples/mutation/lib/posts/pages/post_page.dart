import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mutation/posts/components/create_post_form.dart';
import 'package:mutation/posts/posts_repo.dart';

import '../components/post.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: Column(
        children: [
          const CreatePostForm(),
          Expanded(
            child: QueryBuilder(
              query: getPostsQuery(),
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (state.data?.isEmpty ?? true) {
                      return const Text("No posts");
                    }
                    return Post(post: state.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

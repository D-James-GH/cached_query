import 'dart:convert';

import 'package:cached_query/cached_query.dart';
import 'package:http/http.dart' as http;
import 'package:query_builder/posts/post_model/post_model.dart';

class PostService with CachedQuery {
  InfiniteQuery<List<PostModel>, int> getPosts() {
    return infiniteQuery<List<PostModel>, int>(
      key: 'posts',
      serializer: (post) => PostModel.listFromJson(post),
      initialIndex: 1,
      getNextArg: (pageIndex, lastPage) {
        if (lastPage == null) return 1;
        if (lastPage.isEmpty) return null;
        return pageIndex + 1;
      },
      queryFn: (arg) async {
        final uri = Uri.parse(
            'https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$arg');
        var res = await http.get(uri);
        return PostModel.listFromJson(jsonDecode(res.body));
      },
    );
  }

  Future<void> createPost(PostModel post) async {
    mutation<PostModel, PostModel>(
      key: ['posts', post.id],
      arg: post,
      queryFn: (post) async {
        final res = await Future.delayed(
            const Duration(seconds: 1),
            () => {
                  "id": 123,
                  "title": post.title,
                  "userId": post.userId,
                  "body": post.body,
                });
        return PostModel.fromJson(res);
      },
      onSuccess: (args, newPost) {
        updateInfiniteQuery<PostModel, int>(
            key: "posts", updateFn: (old) => [newPost, ...?old]);
        // invalidateQuery('posts');
      },
    );
  }
}

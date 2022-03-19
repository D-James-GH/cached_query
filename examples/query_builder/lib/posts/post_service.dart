import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:query_builder/posts/post_model/post_model.dart';

class PostService {
  InfiniteQuery<List<PostModel>, int> getPosts() {
    return InfiniteQuery<List<PostModel>, int>(
      key: 'posts',
      serializer: (dynamic postJson) => PostModel.listFromJson(
        List<Map<String, dynamic>>.from(postJson as List<dynamic>),
      ),
      initialIndex: 1,
      cacheDuration: const Duration(seconds: 2),
      refetchDuration: const Duration(seconds: 2),
      getNextArg: (pageIndex, lastPage) {
        if (lastPage == null) return 1;
        if (lastPage.isEmpty) return null;
        return pageIndex + 1;
      },
      queryFn: (arg) async {
        final uri = Uri.parse(
          'https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$arg',
        );
        final res = await http.get(uri);
        return PostModel.listFromJson(
          List<Map<String, dynamic>>.from(
            jsonDecode(res.body) as List<dynamic>,
          ),
        );
      },
    );
  }

  Mutation<PostModel, PostModel> createPost() {
    return Mutation<PostModel, PostModel>(
      key: "createPost",
      invalidateQueries: ['posts'],
      queryFn: (post) async {
        final res = await Future.delayed(
          const Duration(milliseconds: 400),
          () => {
            "id": 123,
            "title": post.title,
            "userId": post.userId,
            "body": post.body,
          },
        );
        return PostModel.fromJson(res);
      },
      onSuccess: (args, newPost) {
        CachedQuery.instance.updateInfiniteQuery<List<PostModel>, int>(
          key: "posts",
          updateFn: (old) => [
            [newPost, ...old![0]],
            ...old.sublist(1).toList()
          ],
        );
      },
    );
  }
}

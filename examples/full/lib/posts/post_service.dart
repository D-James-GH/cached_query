import 'dart:convert';
import 'dart:math';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:full/posts/post_model/post_model.dart';

InfiniteQuery<List<PostModel>, int> getPosts() {
  return InfiniteQuery<List<PostModel>, int>(
    key: 'posts',
    config: QueryConfigFlutter(
      refetchOnResume: true,
      refetchDuration: const Duration(seconds: 2),
      serializer: (dynamic postJson) {
        return (postJson as List<dynamic>)
            .map(
              (dynamic page) => PostModel.listFromJson(page as List<dynamic>),
            )
            .toList();
      },
    ),
    getNextArg: (state) {
      if (state.lastPage?.isEmpty ?? false) return null;
      return state.length + 1;
    },
    queryFn: (arg) async {
      final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$arg',
      );
      final res = await http.get(uri);
      if (Random().nextInt(1000) % 2 == 0) {
        throw "An Error has Occurred";
      }
      return Future.delayed(
        const Duration(seconds: 1),
        () => PostModel.listFromJson(
          List<Map<String, dynamic>>.from(
            jsonDecode(res.body) as List<dynamic>,
          ),
        ),
      );
    },
  );
}

Query<PostModel> getPostById(int id) => Query(
      key: "posts/$id",
      queryFn: () async {
        final uri = Uri.parse(
          'https://jsonplaceholder.typicode.com/posts/$id',
        );
        final res = await http.get(uri);
        return PostModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      },
    );

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
    onStartMutation: (newPost) {
      final fallback = (CachedQuery.instance.getQuery("posts")
              as InfiniteQuery<List<PostModel>, int>)
          .state
          .data;
      CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
        key: "posts",
        updateFn: (old) => [
          [newPost, ...old![0]],
          ...old.sublist(1).toList()
        ],
      );
      return fallback;
    },
    onSuccess: (args, newPost) {},
    onError: (arg, error, fallback) {
      CachedQuery.instance.updateInfiniteQuery<List<PostModel>>(
        key: "posts",
        updateFn: (old) => fallback as List<List<PostModel>>,
      );
    },
  );
}

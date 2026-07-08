import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:full/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_models/shared_models.dart';

InfiniteQuery<List<Post>, int> getPosts() {
  return InfiniteQuery(
    key: 'posts',
    config: QueryConfig(
      storageDuration: const Duration(seconds: 60),
      storeQuery: true,
      staleDuration: const Duration(seconds: 5),
      shouldFetch: (key, data, createdAt) => true,
      storageDeserializer: (json) {
        return InfiniteQueryData.fromJson(
          json,
          pagesConverter: (pages) => pages
              .map(
                (page) => (page as List<dynamic>)
                    .map(
                      (dynamic e) => Post.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
              )
              .toList(),
          argsConverter: (args) => args.cast<int>(),
        );
      },
    ),
    onError: print,
    getNextArg: (state) {
      if (state == null || state.args.isEmpty) return 5;

      final lastArg = state.args.last;
      return lastArg + 1;
    },
    getPrevArg: (state) {
      final firstArg = state?.args.firstOrNull;
      if (firstArg == null || firstArg <= 1) return null;
      return firstArg - 1;
    },
    queryFn: (arg) async {
      final skip = (arg - 1) * 10;
      final uri = Uri.parse(
        '$apiBaseUrl/posts?limit=10&skip=$skip&delay=500',
      );
      final res = await http.get(uri);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return PostsResponse.fromJson(json).posts;
    },
  );
}

Query<Post> getPostById(int id) => Query(
      key: 'posts/$id',
      queryFn: () async {
        final uri = Uri.parse(
          '$apiBaseUrl/posts/$id?delay=500',
        );
        final res = await http.get(uri);
        return Post.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      },
    );

Mutation<Post, Post> createPost() {
  return Mutation<Post, Post>(
    key: 'createPost',
    invalidateQueries: ['posts'],
    mutationFn: (post) async {
      final uri = Uri.parse('$apiBaseUrl/posts?delay=500');
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          CreatePostRequest(
            title: post.title,
            body: post.body,
            userId: post.userId,
          ).toJson(),
        ),
      );
      return Post.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    },
    onStartMutation: (newPost) {
      final query = CachedQuery.instance
          .getQuery<InfiniteQuery<List<Post>, int>>('posts');

      final fallback = query?.state.data;

      query?.update(
        (old) {
          return InfiniteQueryData(
            args: old?.args ?? [],
            pages: [
              [newPost, ...?old?.pages.first],
              ...?old?.pages.sublist(1),
            ],
          );
        },
      );

      return fallback;
    },
    onError: (arg, error, fallback) {
      if (fallback != null) {
        CachedQuery.instance
            .getQuery<InfiniteQuery<List<Post>, int>>('posts')
            ?.update(
              (old) => fallback as InfiniteQueryData<List<Post>, int>,
            );
      }
    },
  );
}

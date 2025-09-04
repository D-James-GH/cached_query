import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:full/posts/post_model/post_model.dart';
import 'package:http/http.dart' as http;

InfiniteQuery<List<PostModel>, int> getPosts() {
  return InfiniteQuery(
    key: 'posts',
    config: QueryConfigFlutter(
      storageDuration: const Duration(seconds: 60),
      storeQuery: true,
      staleDuration: const Duration(seconds: 5),
      shouldFetch: (key, data, createdAt) => true,
      storageDeserializer: (json) {
        return InfiniteQueryData.fromJson(
          json,
          pagesConverter: (pages) => pages
              .map(
                (page) => PostModel.listFromJson(page as List<dynamic>),
              )
              .toList(),
          argsConverter: (args) => args.cast<int>(),
        );
      },
    ),
    onError: print,
    getNextArg: (state) {
      if (state?.lastPage?.isEmpty ?? false) return null;
      return (state?.length ?? 0) + 1;
    },
    queryFn: (arg) async {
      final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$arg',
      );
      final res = await http.get(uri);
      // if (Random().nextInt(1000) % 8 == 0) {
      //   throw "A random error has occurred ⚠️";
      // }
      return Future.delayed(
        const Duration(seconds: 1),
        () => PostModel.listFromJson(
          List<Map<String, dynamic>>.from(
            jsonDecode(res.body) as List<dynamic>,
          ),
        ),
      );
    },
    onSuccess: (data) {
      print("Posts fetched: ${data.pages.length} pages");
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
      onSuccess: (data) {
        print("Post $id fetched, updating cache");
        CachedQuery.instance
            .getQuery<InfiniteQuery<List<PostModel>, int>>("posts")
            ?.update((old) {
          old ??= InfiniteQueryData<List<PostModel>, int>(
            pages: [],
            args: [],
          );
          final pages = old.pages.map((page) {
            final index = page.indexWhere((element) => element.id == data.id);
            if (index == -1) return page;
            final newPage = List<PostModel>.from(page);
            newPage[index] = data;
            return newPage;
          }).toList();
          return InfiniteQueryData<List<PostModel>, int>(
            pages: pages,
            args: old.args,
          );
        });
      },
    );

Mutation<PostModel, PostModel> createPost() {
  return Mutation<PostModel, PostModel>(
    key: "createPost",
    invalidateQueries: ['posts'],
    mutationFn: (post) async {
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
      final query = CachedQuery.instance
          .getQuery<InfiniteQuery<List<PostModel>, int>>("posts");

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
            .getQuery<InfiniteQuery<List<PostModel>, int>>("posts")
            ?.update(
              (old) => fallback as InfiniteQueryData<List<PostModel>, int>,
            );
      }
    },
  );
}

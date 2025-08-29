import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_list/posts/post_model/post_model.dart';

InfiniteQuery<List<PostModel>, int> getPosts() {
  return InfiniteQuery<List<PostModel>, int>(
    key: 'posts',
    config: QueryConfig(
      staleDuration: const Duration(seconds: 2),
      storageDeserializer: (json) {
        return InfiniteQueryData.fromJson(
          json,
          pagesConverter: (p) => p
              .map(
                (dynamic page) => PostModel.listFromJson(page as List<dynamic>),
              )
              .toList(),
          argsConverter: (p) => p.cast<int>(),
        );
      },
    ),
    getNextArg: (state) {
      if (state?.lastPage?.isEmpty ?? false) return null;
      return (state?.pages.length ?? 0) + 1;
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

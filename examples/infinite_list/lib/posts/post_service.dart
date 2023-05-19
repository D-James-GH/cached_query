import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_list/posts/post_model/post_model.dart';

InfiniteQuery<List<PostModel>, int> getPosts() {
  return InfiniteQuery<List<PostModel>, int>(
    key: 'posts',
    config: QueryConfig(
      refetchDuration: const Duration(seconds: 2),
      // use a serializer for cached storage
      deserializer: (dynamic postJson) {
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
      return PostModel.listFromJson(
        List<Map<String, dynamic>>.from(
          jsonDecode(res.body) as List<dynamic>,
        ),
      );
    },
  );
}

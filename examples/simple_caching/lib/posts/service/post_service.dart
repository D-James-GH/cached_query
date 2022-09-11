import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:simple_caching/posts/models/post_model.dart';

String postKey(int id) => "postKey$id";

Query<PostModel> getPostById(int id) {
  return Query<PostModel>(
    key: postKey(id),
    queryFn: () async {
      final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/$id',
      );
      final res = await http.get(uri);
      return Future.delayed(
        const Duration(milliseconds: 500),
        () => PostModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        ),
      );
    },
  );
}

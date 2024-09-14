import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import "package:http/http.dart" as http;
import 'package:multiple_caches/post/post_model/post_model.dart';

String queryKey(int id) => "posts/$id";

Query<PostModel> getPostById(int id, [CachedQuery? cache]) => Query(
      key: queryKey(id),
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
      cache: cache,
    );

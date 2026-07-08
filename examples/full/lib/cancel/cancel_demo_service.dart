import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:full/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_models/shared_models.dart';

/// Demo service for cancelling an in-flight backend request.
class CancelDemoService {
  final http.Client _client = http.Client();

  /// Backend URL used by the cancellation demo.
  Uri get cancelDemoUri => Uri.parse(
        '$apiBaseUrl/posts/1?delay=$cancelDemoDelayMs',
      );

  /// Single query instance for the cancellation demo.
  late final Query<Post> query = Query<Post>(
    key: 'posts/1/cancel-demo',
    config: const QueryConfig<Post>(
      staleDuration: Duration.zero,
      refetchOnConnection: false,
      refetchOnResume: false,
    ),
    queryFn: () async {
      final token = CachedQuery.instance.currentCancelToken;
      final streamed = await _client.send(
        http.AbortableRequest(
          'GET',
          cancelDemoUri,
          abortTrigger: token?.whenCancelled,
        ),
      );
      final res = await http.Response.fromStream(streamed);
      return Post.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    },
  );

  /// Closes the underlying HTTP client.
  void dispose() {
    _client.close();
  }
}

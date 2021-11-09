import 'dart:convert';

import 'package:http/http.dart' as http;

class PostService {
  Future<List<dynamic>> getPosts({
    required int limit,
    required int page,
  }) async {
    final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page');
    var res = await http.get(uri);
    // extra delay for testing purposes
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> createPost(
      {required String title,
      required int userId,
      required String body}) async {
    // extra delay for testing purposes
    return Future.delayed(
        const Duration(seconds: 1),
        () => {
              "id": 123,
              "title": title,
              "userId": userId,
              "body": body,
            });
  }
}

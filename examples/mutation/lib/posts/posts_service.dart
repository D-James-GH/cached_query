import 'dart:convert';

import 'package:http/http.dart' as http;

const host = "http://localhost:8080";

Future<Map<String, dynamic>> createPost(Map<String, dynamic> post) async {
  final res = await http.post(
    Uri.parse("$host/posts"),
    body: jsonEncode(post),
  );
  return jsonDecode(res.body);
}

Future<List<dynamic>> getPosts() async {
  final res = await http.get(Uri.parse("$host/posts"));
  return jsonDecode(res.body);
}

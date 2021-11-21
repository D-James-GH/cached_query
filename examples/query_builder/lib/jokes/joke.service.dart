import 'dart:convert';

import 'package:http/http.dart' as http;

class JokeService {
  final http.Client client = http.Client();
  Future<Map<String, dynamic>> getJoke() async {
    final res = await client.get(Uri.parse("https://icanhazdadjoke.com/"),
        headers: {"Accept": "application/json"});
    if (res.statusCode == 200) {
      return Future.delayed(
          const Duration(milliseconds: 400), () => jsonDecode(res.body));
    } else {
      throw Exception();
    }
  }
}

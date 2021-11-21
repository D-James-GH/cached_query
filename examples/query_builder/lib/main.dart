import 'package:flutter/material.dart';

import 'jokes/joke.screen.dart';
import 'posts/post_list_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        PostListScreen.routeName: (_) => const PostListScreen(),
        JokeScreen.routeName: (_) => JokeScreen(),
      },
      title: 'Flutter Demo',
    );
  }
}

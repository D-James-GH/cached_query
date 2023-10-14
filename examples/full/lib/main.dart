import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_storage/cached_storage.dart';
import 'package:flutter/material.dart';
import 'package:full/observer.dart';

import 'jokes/joke_screen.dart';
import 'posts/post_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    storage: await CachedStorage.ensureInitialized(),
    observers: [Observer()],
  );
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

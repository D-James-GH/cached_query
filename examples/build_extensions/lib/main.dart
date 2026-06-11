import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import 'jokes/screens/joke_screen.dart';
import 'posts/screens/post_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CachedQueryProvider(
      cache: CachedQuery.instance,
      child: MaterialApp(
        routes: {
          PostListScreen.routeName: (_) => const PostListScreen(),
          JokeScreen.routeName: (_) => JokeScreen(),
        },
        title: 'Flutter Demo',
      ),
    );
  }
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:multiple_caches/post/post_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set the default configuration for the CachedQuery instance.
  CachedQuery.instance.configFlutter(
    config: const GlobalQueryConfigFlutter(
      staleDuration: Duration(seconds: 4),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: PostPage(),
    );
  }
}

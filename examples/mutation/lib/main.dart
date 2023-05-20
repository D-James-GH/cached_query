import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mutation/posts/pages/post_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance
      .configFlutter(config: GlobalQueryConfigFlutter(shouldRethrow: true));
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

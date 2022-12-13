import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_list/posts/post_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    refetchOnResume: true,
    refetchOnConnection: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: PostListScreen(),
    );
  }
}

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import 'posts/view/post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    config: const GlobalQueryConfigFlutter(
      refetchDuration: Duration(seconds: 4),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: PostPage(),
    );
  }
}

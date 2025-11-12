import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_list_with_bloc/post/pages/details_page.dart';
import 'package:infinite_list_with_bloc/post/pages/posts_with_builder.dart';

import 'post/pages/post_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    config: const GlobalQueryConfig(
      refetchOnResume: true,
      refetchOnConnection: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        PostListPage.routeName: (_) => const PostListPage(),
        DetailsPage.routeName: (_) => const DetailsPage(),
        PostListWithBuilderPage.routeName: (_) =>
            const PostListWithBuilderPage(),
      },
    );
  }
}

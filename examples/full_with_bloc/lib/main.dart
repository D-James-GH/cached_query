import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_with_bloc/screens/joke.screen.dart';
import 'package:full_with_bloc/screens/post_list.screen.dart';

import 'blocs/joke/joke_bloc.dart';
import 'blocs/post/post_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        PostListScreen.routeName: (_) => BlocProvider(
              create: (_) => PostBloc()..add(PostsFetched()),
              child: const PostListScreen(),
            ),
        JokeScreen.routeName: (_) => BlocProvider(
              create: (_) => JokeBloc()..add(JokeFetched()),
              child: const JokeScreen(),
            ),
      },
      title: 'Flutter Demo',
    );
  }
}

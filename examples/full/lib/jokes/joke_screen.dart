import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

import '../posts/post_list_screen.dart';
import 'joke_model/joke_model.dart';
import 'joke_service.dart';

class JokeScreen extends StatelessWidget {
  static const routeName = '/screenTwo';
  final Color color = Colors.white;
  final JokeService service = JokeService();

  JokeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('jokes'),
            QueryBuilder<JokeModel?>(
              query: service.getJoke(),
              builder: (_, state) {
                if (state.status == QueryStatus.loading) {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              PostListScreen.routeName,
            ),
          ),
        ],
      ),
      body: QueryBuilder<JokeModel?>(
        query: service.getJoke(),
        builder: (_, state) {
          return Column(
            children: [
              if (state.status == QueryStatus.error &&
                  state.error is SocketException)
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Theme.of(context).colorScheme.error),
                  child: const Text(
                    "No internet connection",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Text(state.data?.joke ?? "")),
                      if (state.status == QueryStatus.loading)
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

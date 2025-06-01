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

  JokeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('jokes'),
            QueryBuilder(
              query: service.getJoke(),
              builder: (_, state) {
                if (state.isLoading) {
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
      body: QueryBuilder<QueryState<JokeModel?>>(
        query: service.getJoke(),
        builder: (_, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                if (state.isError &&
                    (state as QueryError).error is SocketException)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error),
                    child: const Text(
                      "No internet connection",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.isLoading) const CircularProgressIndicator(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(state.data?.joke ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 24))),
                          ],
                        ),
                        const SizedBox(height: 24),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 40),
                          onPressed: () => service.getJoke().refetch(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:query_builder/jokes/joke.service.dart';
import 'package:query_builder/jokes/joke_model/joke_model.dart';
import 'package:query_builder/posts/post_list_screen.dart';

class JokeScreen extends StatelessWidget {
  static const routeName = '/screenTwo';
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
                if (state.isFetching) {
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
                context, PostListScreen.routeName),
          )
        ],
      ),
      body: QueryBuilder<JokeModel?>(
        query: service.getJoke(),
        builder: (_, state) {
          return Column(
            children: [
              if (state.status == QueryStatus.error &&
                  state.error is SocketException)
                SliverToBoxAdapter(
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).errorColor),
                    child: const Text(
                      "No internet connection",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Expanded(
                  child: Center(
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.data?.joke ?? ""),
                  if (state.isFetching) const CircularProgressIndicator(),
                ],
              ))),
            ],
          );
        },
      ),
    );
  }
}

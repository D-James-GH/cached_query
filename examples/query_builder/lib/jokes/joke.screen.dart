import 'package:cached_query/cached_query.dart';
import 'package:flutter/material.dart';
import 'package:query_builder/jokes/joke.service.dart';
import 'package:query_builder/jokes/joke_model/joke_model.dart';
import 'package:query_builder/posts/post_list_screen.dart';

class JokeScreen extends StatelessWidget with CachedQuery {
  static const routeName = '/screenTwo';
  JokeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('jokes'),
            QueryBuilder<JokeModel?>(
              query: _getJoke,
              builder: (_, state) {
                print(state.isFetching);
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
      body: Center(
        child: QueryBuilder<JokeModel?>(
          query: _getJoke ,
          builder: (_, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.isFetching) const CircularProgressIndicator(),
                Text(state.data?.joke ?? ""),
              ],
            );
          },
        ),
      ),
    );

  }
  Query<JokeModel> _getJoke(){
return query<JokeModel>(
              key: 'joke',
              staleTime: const Duration(seconds: 4),
              queryFn: () async =>
                  JokeModel.fromJson(await JokeService().getJoke()))
  }
}

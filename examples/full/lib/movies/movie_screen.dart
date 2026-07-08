import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';

import '../cancel/cancel_query_screen.dart';
import '../posts/post_list_screen.dart';
import 'movie_service.dart';

class MovieScreen extends StatelessWidget {
  static const routeName = '/movies';
  final MovieService service = MovieService();

  MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('movies'),
            Builder(
              builder: (context) {
                final state = context.watchQuery(query: service.getMovie());
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
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: () => Navigator.pushNamed(
              context,
              CancelQueryScreen.routeName,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right_alt),
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              PostListScreen.routeName,
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final state = context.watchQuery<Movie?>(query: service.getMovie());
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                if (state case QueryError(:final error))
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    child: Text(
                      error is SocketException
                          ? 'No internet connection'
                          : error.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.isLoading) const CircularProgressIndicator(),
                        if (state.data != null) ...[
                          if (state.data!.poster.isNotEmpty &&
                              state.data!.poster != 'N/A')
                            Image.network(
                              state.data!.poster,
                              height: 200,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            state.data!.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.data!.plot,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                        const SizedBox(height: 24),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 40),
                          onPressed: () => service.getMovie().refetch(),
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

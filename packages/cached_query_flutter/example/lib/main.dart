import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

// Full project example here: https://github.com/D-James-GH/cached_query/tree/main/examples/query_builder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FilmTitle(),
    );
  }
}

class FilmTitle extends StatelessWidget {
  const FilmTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('jokes'),
            QueryBuilder<String>(
              query: getFilmTitle(),
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
      ),
      body: QueryBuilder<String>(
        query: getFilmTitle(),
        builder: (_, state) {
          return Column(
            children: [
              if (state.status == QueryStatus.error &&
                  state.error is SocketException)
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Theme.of(context).errorColor),
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
                      Expanded(child: Text(state.data ?? "")),
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

Query<String> getFilmTitle() {
  return Query<String>(
    key: 'title',
    // Override the global config here
    config: const QueryConfig(
      cacheDuration: Duration(seconds: 4),
    ),
    queryFn: () => Future.delayed(
      const Duration(milliseconds: 400),
      () => "Star Wars",
    ),
  );
}

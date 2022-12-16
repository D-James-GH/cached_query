import 'package:cached_query/cached_query.dart';
//ignore_for_file:avoid_print

// Full project example here: https://github.com/D-James-GH/cached_query/tree/main/examples/query_builder

void main() async {
  // Optionally initialise cached query with a config
  CachedQuery.instance.config(
    config: QueryConfig(
      cacheDuration: const Duration(minutes: 5),
    ),
  );
  final filmTitle = getFilmTitle();

  // listen to state updates
  filmTitle.stream.listen((event) {
    print("Stream: ${event.data}");
  });

  // Or just await the result
  print(await filmTitle.result);

  // Calling again gets the same query instance and data from cache
  final sameQuery = getFilmTitle();

  // Can force a refetch and await the result
  // ignore: unused_local_variable
  final refetchResult = await sameQuery.refetch();
}

Query<String> getFilmTitle() {
  return Query<String>(
    key: 'title',
    // Override the global config here
    config: QueryConfig(
      cacheDuration: const Duration(seconds: 4),
    ),
    queryFn: () => Future.delayed(
      const Duration(milliseconds: 400),
      () => "Star Wars",
    ),
  );
}

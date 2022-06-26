import 'package:cached_query/cached_query.dart';

void main() async {
  // Optionally initialise cached query with a config
  CachedQuery.instance.config(
    config: const QueryConfig(
      cacheDuration: Duration(minutes: 5),
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
  final refetchResult = await sameQuery.refetch();
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

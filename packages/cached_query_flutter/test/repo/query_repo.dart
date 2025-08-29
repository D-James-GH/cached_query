import 'package:cached_query/cached_query.dart';

class TitleRepo {
  static const key = 'title';
  final String response;
  final Duration? queryDelay;

  const TitleRepo({this.queryDelay, required this.response});

  Query<String> fetchTitle({
    String? initialTitle,
    CachedQuery? cache,
    void Function()? onQueryCalled,
  }) {
    return Query<String>(
      key: key,
      cache: cache,
      queryFn: () {
        onQueryCalled?.call();
        return Future.delayed(queryDelay ?? Duration.zero, () => response);
      },
      initialData: initialTitle,
      config: const QueryConfig(
        ignoreCacheDuration: true,
        staleDuration: Duration.zero,
      ),
    );
  }

  Mutation<String, String> updateTitle() {
    return Mutation(
      mutationFn: (title) =>
          Future.delayed(queryDelay ?? Duration.zero, () => title),
    );
  }
}

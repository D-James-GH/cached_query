import 'package:cached_query/cached_query.dart';

class TitleRepo {
  static const key = 'title';
  final String response;
  final Duration? queryDelay;
  const TitleRepo({this.queryDelay, required this.response});

  Query<String> fetchTitle({String? initialTitle}) {
    return Query<String>(
      key: key,
      queryFn: () =>
          Future.delayed(queryDelay ?? Duration.zero, () => response),
      initialData: initialTitle,
      config: QueryConfig(ignoreCacheDuration: true),
    );
  }
}

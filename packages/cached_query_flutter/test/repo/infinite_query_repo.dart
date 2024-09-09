import 'package:cached_query/cached_query.dart';

class InfiniteQueryRepo {
  static const queryKey = "infinite key";
  final String response;
  InfiniteQueryRepo({required this.response});

  InfiniteQuery<String, int> fetchList({String? key}) {
    return InfiniteQuery<String, int>(
      getNextArg: (state) {
        if (state.data == null) return 1;
        return state.data!.length + 1;
      },
      key: key ?? queryKey,
      queryFn: (page) async => response,
      config: QueryConfig(ignoreCacheDuration: true),
    );
  }
}

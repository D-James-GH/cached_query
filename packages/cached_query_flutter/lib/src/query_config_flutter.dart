import 'package:cached_query/cached_query.dart';

/// Global config for all queries and infinite queries in flutter.
class QueryConfigFlutter extends QueryConfig {
  /// Whether the onscreen query should refetch when the app comes back into view.
  final bool refetchOnResume;

  /// Global config for all queries and infinite queries in flutter.
  const QueryConfigFlutter({
    this.refetchOnResume = true,
    super.refetchDuration,
    super.cacheDuration,
    super.shouldRethrow,
  });
}

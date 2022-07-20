import '../cached_query.dart';

/// Query Observer
///
/// Observe state changes in every query and mutation.
abstract class QueryObserver {
  /// Called when a query is updated.
  void onQueryChange(QueryState<dynamic> previous, QueryState<dynamic> next) {}

  /// Called if a query fails.
  void onQueryError() {}

  /// Called when a query succeeds
  void onQuerySuccess() {}

  /// Called when an infinite query is updated.
  void onInfiniteQueryChange() {}

  /// Called when an infinite query is updated.
  void onInfiniteQueryError() {}

  /// Called when an infinite query succeeds
  void onInfiniteQuerySuccess() {}
}

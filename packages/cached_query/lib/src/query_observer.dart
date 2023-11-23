import 'package:meta/meta.dart';

import '../cached_query.dart';

/// Query Observer
///
/// Observe state changes in every query and mutation.
abstract class QueryObserver {
  /// Called when a mutation is created in the cache
  @mustCallSuper
  void onMutationCreation(
    Mutation<dynamic, dynamic> query,
  ) {}

  /// Called when a mutation is found in the cache and re-used
  @mustCallSuper
  void onMutationReuse(
    Mutation<dynamic, dynamic> query,
  ) {}

  /// Called when an infinite query or query are created in the cache
  @mustCallSuper
  void onQueryCreation(
    QueryBase<dynamic, dynamic> query,
  ) {}

  /// Called when an infinite query or query are deleted from the cache
  @mustCallSuper
  void onQueryDeletion(Object? key) {}

  /// Called when a query state is updated.
  ///
  /// Called before the state changes
  @mustCallSuper
  void onChange(
    QueryBase<dynamic, dynamic> query,
    QueryState<dynamic> nextState,
  ) {}

  /// Called if a query fails.
  @mustCallSuper
  void onError(
    QueryBase<dynamic, dynamic> query,
    StackTrace stackTrace,
  ) {}

  /// Called if a mutation error happens.
  @mustCallSuper
  void onMutationError(
    Mutation<dynamic, dynamic> mutation,
    StackTrace stackTrace,
  ) {}

  /// Called when the state of a mutation changes.
  @mustCallSuper
  void onMutationChange(
    Mutation<dynamic, dynamic> mutation,
    MutationState<dynamic> nextState,
  ) {}
}

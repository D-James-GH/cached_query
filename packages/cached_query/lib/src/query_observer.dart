import 'package:meta/meta.dart';

import '../cached_query.dart';

/// Query Observer
///
/// Observe state changes in every query and mutation.
abstract class QueryObserver {
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

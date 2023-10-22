import 'package:cached_query/cached_query.dart';

class QueryLogger implements QueryObserver {
  @override
  void onMutationCreation(
    Mutation<dynamic, dynamic> query,
  ) {}

  @override
  void onMutationReuse(
    Mutation<dynamic, dynamic> query,
  ) {}

  @override
  void onQueryCreation(
    QueryBase<dynamic, dynamic> query,
  ) {}

  @override
  void onQueryDeletion(Object? key) {}

  @override
  void onChange(
    QueryBase<dynamic, dynamic> query,
    QueryState<dynamic> nextState,
  ) {}

  @override
  Future<void> onError(
    QueryBase<dynamic, dynamic> query,
    StackTrace stackTrace,
  ) async {}

  @override
  void onMutationError(
    Mutation<dynamic, dynamic> mutation,
    StackTrace stackTrace,
  ) {}

  @override
  void onMutationChange(
    Mutation<dynamic, dynamic> mutation,
    MutationState<dynamic> nextState,
  ) {}
}

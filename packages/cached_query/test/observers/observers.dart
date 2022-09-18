import 'package:cached_query/cached_query.dart';

class QueryChangeObserver extends QueryObserver {
  final void Function(
    QueryBase<dynamic, dynamic> query,
    QueryState<dynamic> state,
  ) onLoadingEvent;

  QueryChangeObserver(this.onLoadingEvent);

  @override
  void onChange(
    QueryBase<dynamic, dynamic> query,
    QueryState<dynamic> nextState,
  ) {
    onLoadingEvent(query, nextState);
    super.onChange(query, nextState);
  }
}

class QueryFailObserver extends QueryObserver {
  final void Function(
    QueryBase<dynamic, dynamic> query,
    StackTrace,
  ) onFailEvent;

  QueryFailObserver(this.onFailEvent);

  @override
  void onError(
    QueryBase<dynamic, dynamic> query,
    StackTrace stackTrace,
  ) {
    onFailEvent(query, stackTrace);
    super.onError(query, stackTrace);
  }
}

class MutationObserver extends QueryObserver {
  final void Function(
    Mutation<dynamic, dynamic> mutation,
    MutationState<dynamic> nextState,
  ) onMutationEvent;

  MutationObserver(this.onMutationEvent);

  @override
  void onMutationChange(
    Mutation<dynamic, dynamic> mutation,
    MutationState<dynamic> nextState,
  ) {
    onMutationEvent(mutation, nextState);
    super.onMutationChange(mutation, nextState);
  }
}

class MutationErrorObserver extends QueryObserver {
  final void Function(
    Mutation<dynamic, dynamic> mutation,
    StackTrace trace,
  ) onMutationEvent;

  MutationErrorObserver(this.onMutationEvent);

  @override
  void onMutationError(
    Mutation<dynamic, dynamic> mutation,
    StackTrace stackTrace,
  ) {
    onMutationEvent(mutation, stackTrace);
    super.onMutationError(mutation, stackTrace);
  }
}

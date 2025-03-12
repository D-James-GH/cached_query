import 'package:cached_query/src/mutation.dart';
import 'package:cached_query/src/query/_query.dart';
import 'package:cached_query/src/query_observer.dart';
import 'package:cached_query/src/query_state.dart';
import 'dart:developer' as developer;

/// An observer to sent change events to the dev tools.
class DevtoolsObserver implements QueryObserver {
  void _emit(String name, Map<String, dynamic> data) {
    developer.postEvent("cached_query:$name", data);
  }

  @override
  void onChange(
    QueryBase query,
    QueryState<dynamic> nextState,
  ) {
    _emit("query_changed", {"key": query.key});
  }

  @override
  void onError(QueryBase query, StackTrace stackTrace) {
    _emit("query_error", {"key": query.key});
  }

  @override
  void onMutationChange(
    Mutation<dynamic, dynamic> mutation,
    MutationState<dynamic> nextState,
  ) {
    _emit("mutation_changed", {"key": mutation.key});
  }

  @override
  void onMutationCreation(Mutation<dynamic, dynamic> query) {
    _emit("mutation_created", {"key": query.key});
  }

  @override
  void onMutationError(
    Mutation<dynamic, dynamic> mutation,
    StackTrace stackTrace,
  ) {
    _emit("mutation_error", {"key": mutation.key});
  }

  @override
  void onMutationReuse(Mutation<dynamic, dynamic> query) {
    _emit("mutation_reuse", {"key": query.key});
  }

  @override
  void onQueryCreation(QueryBase query) {
    _emit("query_created", {"key": query.key});
  }

  @override
  void onQueryDeletion(Object? key) {
    _emit("query_deleted", {"key": key});
  }
}

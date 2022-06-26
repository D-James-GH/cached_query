import 'package:cached_query/cached_query.dart';

/// Generic status of a query or mutation.
enum QueryStatus {
  /// Whether the query is loading or fetching.
  loading,

  /// Whether the query has returned without an error.
  success,

  /// Whether the query has returned with an error.
  error,

  /// The Query has not started.
  initial,
}

/// {@template queryState}
/// [InfiniteQueryState] holds the current state of an [InfiniteQuery]
///
/// Should not be instantiated manually.
/// {@endtemplate}
class QueryState<T> implements StateBase {
  /// Current data of the query.
  @override
  final T? data;

  /// Timestamp of the query.
  ///
  /// Time is reset if new data is fetched.
  @override
  final DateTime timeCreated;

  /// Status of the previous fetch.
  @override
  final QueryStatus status;

  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  @override
  final dynamic error;

  /// {@macro queryState}
  const QueryState({
    this.error,
    this.data,
    required this.timeCreated,
    this.status = QueryStatus.initial,
  });

  /// Creates a copy of the current [QueryState] with the given filed
  /// replaced.
  QueryState<T> copyWith({
    T? data,
    DateTime? timeCreated,
    QueryStatus? status,
    dynamic error,
  }) {
    return QueryState(
      data: data ?? this.data,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          timeCreated == other.timeCreated &&
          error == other.error &&
          status == other.status;

  @override
  int get hashCode =>
      runtimeType.hashCode ^ data.hashCode ^ status.hashCode ^ error.hashCode;
}

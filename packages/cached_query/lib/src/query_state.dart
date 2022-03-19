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
/// {@endTemplate}
class QueryState<T> extends StateBase {
  /// Current data of the query.
  @override
  final T? data;

  /// Timestamp of the [InfiniteQuery]
  ///
  /// Time is reset if new data is fetched.
  final DateTime timeCreated;

  /// Status of the previous fetch.
  final QueryStatus status;

  /// True if the query is currently fetching.
  final bool isFetching;

  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  final dynamic error;

  /// {@macro queryState}
  const QueryState({
    this.error,
    this.data,
    required this.timeCreated,
    this.status = QueryStatus.initial,
    this.isFetching = false,
  });

  /// Creates a copy of the current [QueryState] with the given filed
  /// replaced.
  QueryState<T> copyWith({
    T? data,
    DateTime? timeCreated,
    QueryStatus? status,
    bool? isFetching,
    dynamic error,
  }) {
    return QueryState(
      data: data ?? this.data,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      error: error ?? this.error,
      isFetching: isFetching ?? this.isFetching,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          isFetching == other.isFetching &&
          timeCreated == other.timeCreated &&
          error == other.error &&
          status == other.status;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      data.hashCode ^
      status.hashCode ^
      isFetching.hashCode ^
      error.hashCode;
}

import 'package:cached_query/cached_query.dart';

/// {@template infiniteQueryState}
/// [InfiniteQueryState] holds the current state of an [InfiniteQuery]
/// {@endtemplate}
class InfiniteQueryState<T> extends QueryState<List<T>> {
  final Object? Function(InfiniteQueryState<T>) _getNextArg;

  /// True if there are no more pages available to fetch.
  ///
  /// Calculated using [GetNextArg], if it has returned null then this is true.
  @Deprecated("Use the function on the query (InfiniteQuery.hasReachedMax())")
  bool get hasReachedMax => _getNextArg(this) == null;

  /// The last response from the queryFn
  final T? lastPage;

  /// The length of the current data list.
  ///
  /// Returns 0 if there is no data yet
  int get length => data?.length ?? 0;

  /// {@macro infiniteQueryState}
  InfiniteQueryState({
    required dynamic Function(InfiniteQueryState<T>) getNextArg,
    this.lastPage,
    List<T>? data,
    QueryStatus status = QueryStatus.initial,
    dynamic error,
    required DateTime timeCreated,
  })  : _getNextArg = getNextArg,
        super(
          status: status,
          error: error,
          timeCreated: timeCreated,
          data: data,
        );

  /// Creates a copy of the current [InfiniteQueryState] with the given filed
  /// replaced.
  @override
  InfiniteQueryState<T> copyWith({
    List<T>? data,
    int? currentIndex,
    QueryStatus? status,
    DateTime? timeCreated,
    T? lastPage,
    dynamic error,
  }) {
    return InfiniteQueryState(
      lastPage: lastPage ?? this.lastPage,
      getNextArg: _getNextArg,
      error: error ?? this.error,
      data: data ?? this.data,
      status: status ?? this.status,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          timeCreated == other.timeCreated &&
          error == other.error &&
          hasReachedMax == other.hasReachedMax &&
          status == other.status;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      data.hashCode ^
      status.hashCode ^
      error.hashCode ^
      hasReachedMax.hashCode;
}

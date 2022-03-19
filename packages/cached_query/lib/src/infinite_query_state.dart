import 'package:cached_query/cached_query.dart';

/// {@template infiniteQueryState}
/// [InfiniteQueryState] holds the current state of an [InfiniteQuery]
/// {@endTemplate}
class InfiniteQueryState<T> extends StateBase {
  /// List of responses from the [queryFn]
  @override
  final List<T> data;

  /// Current page index
  final int currentPage;

  /// True if there are no more pages available to fetch.
  ///
  /// Set to true if [GetNextArg] has returned null.
  final bool hasReachedMax;

  /// Status of the previous fetch.
  final QueryStatus? status;

  /// True if the query is currently fetching.
  final bool isFetching;

  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  final dynamic error;

  /// Timestamp of the [InfiniteQuery]
  ///
  /// Time is reset if new data is fetched.
  final DateTime timeCreated;

  /// {@macro infiniteQueryState}
  const InfiniteQueryState({
    this.hasReachedMax = false,
    required this.data,
    this.status = QueryStatus.initial,
    this.isFetching = false,
    this.error,
    required this.timeCreated,
    required this.currentPage,
  });

  /// Get the last page in the [data]
  T? get lastPage => data.isNotEmpty ? data[data.length - 1] : null;

  /// Creates a copy of the current [InfiniteQueryState] with the given filed
  /// replaced.
  InfiniteQueryState<T> copyWith({
    List<T>? data,
    QueryStatus? status,
    bool? isFetching,
    bool? hasReachedMax,
    DateTime? timeCreated,
    dynamic error,
  }) {
    return InfiniteQueryState(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
      data: data ?? this.data,
      isFetching: isFetching ?? this.isFetching,
      status: status ?? this.status,
      currentPage: currentPage,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          isFetching == other.isFetching &&
          timeCreated == other.timeCreated &&
          error == other.error &&
          hasReachedMax == other.hasReachedMax &&
          currentPage == other.currentPage &&
          status == other.status;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      data.hashCode ^
      status.hashCode ^
      isFetching.hashCode ^
      error.hashCode ^
      currentPage.hashCode ^
      hasReachedMax.hashCode;
}

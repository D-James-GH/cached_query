import 'package:cached_query/cached_query.dart';

class InfiniteQueryState<T> extends StateBase {
  @override
  final List<T> data;
  final int currentPage;
  final bool hasReachedMax;
  final QueryStatus? status;
  final bool isFetching;
  final dynamic error;
  final DateTime timeCreated;

  const InfiniteQueryState({
    this.hasReachedMax = false,
    required this.data,
    this.status = QueryStatus.initial,
    this.isFetching = false,
    this.error,
    required this.timeCreated,
    required this.currentPage,
  });

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

import './query_state.dart';

class InfiniteQueryState<T> {
  final List<T>? data;
  final int currentPage;
  final bool hasReachedMax;
  final QueryStatus? status;
  final bool isFetching;
  final DateTime timeCreated;

  const InfiniteQueryState({
    this.hasReachedMax = false,
    this.data,
    this.status = QueryStatus.initial,
    this.isFetching = false,
    required this.timeCreated,
    required this.currentPage,
  });

  InfiniteQueryState<T> copyWith({
    List<T>? data,
    QueryStatus? status,
    bool? isFetching,
    bool? hasReachedMax,
    DateTime? timeCreated,
  }) {
    return InfiniteQueryState(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      data: data ?? this.data,
      isFetching: isFetching ?? this.isFetching,
      status: status ?? this.status,
      currentPage: currentPage,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }
}

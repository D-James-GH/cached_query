import './query.dart';

class InfiniteQuery<T> {
  final List<T>? data;
  final int currentPage;
  final Future<InfiniteQuery<T>> Function() getNextPage;
  final bool hasReachedMax;
  final QueryStatus? status;
  final bool isFetching;
  final DateTime timeCreated;
  final Stream<InfiniteQuery<T>> Function() _stream;
  Stream<InfiniteQuery<T>> get stream => _stream();

  const InfiniteQuery({
    this.hasReachedMax = false,
    this.data,
    this.status = QueryStatus.initial,
    this.isFetching = false,
    required this.timeCreated,
    required this.currentPage,
    required this.getNextPage,
    required Stream<InfiniteQuery<T>> Function() createStream,
  }) : _stream = createStream;

  InfiniteQuery<T> copyWith({
    List<T>? data,
    QueryStatus? status,
    bool? isFetching,
    bool? hasReachedMax,
    DateTime? timeCreated,
  }) {
    return InfiniteQuery(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      data: data ?? this.data,
      isFetching: isFetching ?? this.isFetching,
      getNextPage: getNextPage,
      status: status ?? this.status,
      currentPage: currentPage,
      timeCreated: timeCreated ?? this.timeCreated,
      createStream: _stream,
    );
  }
}

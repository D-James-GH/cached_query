enum QueryStatus { fetching, success, error, initial }

class QueryState<T> {
  final T? data;
  final DateTime timeCreated;
  final QueryStatus status;
  final bool isFetching;

  QueryState({
    this.data,
    required this.timeCreated,
    this.status = QueryStatus.initial,
    this.isFetching = false,
  });

  QueryState<T> copyWith({
    T? data,
    DateTime? timeCreated,
    QueryStatus? status,
    bool? isFetching,
  }) {
    return QueryState(
      data: data ?? this.data,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      isFetching: isFetching ?? this.isFetching,
    );
  }
}

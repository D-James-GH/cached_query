enum QueryStatus { loading, success, error, initial }

class Query<T> {
  final T? data;
  final DateTime timeCreated;
  final QueryStatus status;
  final bool isFetching;
  final Stream<Query<T>> Function() getStream;

  const Query({
    required this.getStream,
    this.data,
    required this.timeCreated,
    this.status = QueryStatus.initial,
    this.isFetching = false,
  });

  Query<T> copyWith({
    T? data,
    DateTime? timeCreated,
    QueryStatus? status,
    bool? isFetching,
  }) {
    return Query(
      data: data ?? this.data,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      isFetching: isFetching ?? this.isFetching,
      getStream: getStream,
    );
  }
}

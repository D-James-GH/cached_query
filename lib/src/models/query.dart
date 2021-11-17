enum QueryStatus { loading, success, error, initial }

class Query<T> {
  final T? data;
  final DateTime timeCreated;
  final QueryStatus status;
  final bool isFetching;

  const Query({
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
    );
  }
}

enum QueryStatus { loading, success, error, initial }

class Query<T> {
  final T? data;
  final DateTime timeCreated;
  final QueryStatus status;
  final bool isFetching;
  final Stream<Query<T>> Function() _stream;
  Stream<Query<T>> get stream => _stream();

  const Query({
    required Stream<Query<T>> Function() createStream,
    this.data,
    required this.timeCreated,
    this.status = QueryStatus.initial,
    this.isFetching = false,
  }) : _stream = createStream;

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
      createStream: _stream,
    );
  }
}

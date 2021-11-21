enum QueryStatus { loading, success, error, initial }

class QueryState<T> {
  final T? data;
  final DateTime timeCreated;
  final QueryStatus status;
  final bool isFetching;

  const QueryState({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          isFetching == other.isFetching &&
          timeCreated == other.timeCreated &&
          status == other.status;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      data.hashCode ^
      status.hashCode ^
      isFetching.hashCode;
}

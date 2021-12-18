import 'package:cached_query/cached_query.dart';

enum QueryStatus { loading, success, error, initial }

class QueryState<T> extends StateBase {
  @override
  final T? data;
  final DateTime timeCreated;
  final QueryStatus status;
  final bool isFetching;
  final dynamic error;

  const QueryState({
    this.error,
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
    dynamic error,
  }) {
    return QueryState(
      data: data ?? this.data,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      error: error ?? this.error,
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
          error == other.error &&
          status == other.status;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      data.hashCode ^
      status.hashCode ^
      isFetching.hashCode ^
      error.hashCode;
}

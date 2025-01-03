part "infinite_query_state.dart";

/// {@template QueryState}
/// An Interface for query state and infinite query state.
/// {@endtemplate}
sealed class QueryState<T> {
  /// The data stored in the query;
  T? get data;

  /// Timestamp of the query.
  ///
  /// Time is reset if new data is fetched.
  DateTime get timeCreated;

  /// True if the query is currently fetching data.
  bool get isLoading;

  /// True if the query is in the initial state.
  bool get isInitial;

  /// True if the query has successfully fetched data.
  bool get isSuccess;

  /// True if the query has errored.
  bool get isError;

  /// Copy the current state with new data
  QueryState<T> copyWithData(T? data);
}

/// {@template QueryState}
/// An Interface for the query state.
/// {@endtemplate}
sealed class QueryStatus<T> implements QueryState<T> {
  @override
  final DateTime timeCreated;

  @override
  final T? data;

  /// {@macro QueryState}
  const QueryStatus({required this.timeCreated, this.data});

  const factory QueryStatus.initial({
    required DateTime timeCreated,
    T? data,
  }) = QueryInitial;

  const factory QueryStatus.loading({
    required DateTime timeCreated,
    required bool isRefetching,
    T? data,
  }) = QueryLoading<T>;

  const factory QueryStatus.error({
    required DateTime timeCreated,
    T? data,
    required StackTrace stackTrace,
    required dynamic error,
  }) = QueryError<T>;

  const factory QueryStatus.success({
    required DateTime timeCreated,
    T? data,
  }) = QuerySuccess<T>;

  QueryStatus<T> copyWithData(T? data) {
    return switch (this) {
      QueryInitial<T>() => QueryInitial(timeCreated: timeCreated, data: data),
      QuerySuccess<T>() => QuerySuccess(timeCreated: timeCreated, data: data),
      QueryLoading<T>(:final isRefetching) => QueryLoading(
          timeCreated: timeCreated,
          isRefetching: isRefetching,
          data: data,
        ),
      QueryError<T>(:final error, :final stackTrace) => QueryError(
          timeCreated: timeCreated,
          data: data,
          stackTrace: stackTrace,
          error: error,
        ),
    };
  }

  @override
  bool get isLoading => this is QueryLoading;

  @override
  bool get isInitial => this is QueryInitial;

  @override
  bool get isSuccess => this is QuerySuccess;

  @override
  bool get isError => this is QueryError;
}

/// {@template QueryInitial}
/// The initial state of the query, before the `queryFn` has been called.
/// {@endtemplate}
class QueryInitial<T> extends QueryStatus<T> {
  /// {@macro QueryInitial}
  const QueryInitial({required super.timeCreated, super.data});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryInitial &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          data == other.data;

  @override
  int get hashCode => timeCreated.hashCode ^ data.hashCode;
}

/// {@template QuerySuccess}
/// The state of the query when the `queryFn` has been successfully called.
/// {@endtemplate}
class QuerySuccess<T> extends QueryStatus<T> {
  /// {@macro QuerySuccess}
  const QuerySuccess({required super.timeCreated, super.data});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuerySuccess &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          data == other.data;

  @override
  int get hashCode => timeCreated.hashCode ^ data.hashCode;
}

/// {@template QueryLoading}
/// The state of the query when the `queryFn` is currently being called.
/// {@endtemplate}
class QueryLoading<T> extends QueryStatus<T> {
  /// Whether the query is currently refetching
  final bool isRefetching;

  /// {@macro QueryLoading}
  const QueryLoading({
    required super.timeCreated,
    super.data,
    required this.isRefetching,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryLoading &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          isRefetching == other.isRefetching &&
          data == other.data;

  @override
  int get hashCode => timeCreated.hashCode ^ data.hashCode;
}

/// {@template QueryError}
/// The state of the query when an error is thrown.
/// {@endtemplate}
class QueryError<T> extends QueryStatus<T> {
  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  final dynamic error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  ///{@macro QueryError}
  const QueryError({
    required super.timeCreated,
    super.data,
    required this.stackTrace,
    required this.error,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryError &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          data == other.data &&
          stackTrace == other.stackTrace &&
          error == other.error;

  @override
  int get hashCode =>
      timeCreated.hashCode ^
      data.hashCode ^
      error.hashCode ^
      stackTrace.hashCode;
}

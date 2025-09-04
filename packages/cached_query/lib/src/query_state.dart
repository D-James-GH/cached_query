import 'package:cached_query/cached_query.dart';

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
  QueryState<T> copyWithData(T data);
}

/// {@template QueryState}
/// An Interface for the query state.
/// {@endtemplate}
sealed class QueryStatus<T> implements QueryState<T> {
  @override
  final DateTime timeCreated;

  @override
  T? get data;

  /// {@macro QueryState}
  const QueryStatus({required this.timeCreated});

  const factory QueryStatus.initial({
    required DateTime timeCreated,
    T? data,
  }) = QueryInitial;

  const factory QueryStatus.loading({
    required DateTime timeCreated,
    required bool isRefetching,
    required bool isInitialFetch,
    required T? data,
  }) = QueryLoading<T>;

  const factory QueryStatus.error({
    required DateTime timeCreated,
    required T? data,
    required StackTrace stackTrace,
    required dynamic error,
  }) = QueryError<T>;

  const factory QueryStatus.success({
    required DateTime timeCreated,
    required T data,
  }) = QuerySuccess<T>;

  @override
  QueryStatus<T> copyWithData(T data, [DateTime? timeCreated]) {
    timeCreated ??= this.timeCreated;
    return switch (this) {
      QueryInitial<T>() => QueryInitial(timeCreated: timeCreated, data: data),
      QuerySuccess<T>() => QuerySuccess(timeCreated: timeCreated, data: data),
      QueryLoading<T>(:final isRefetching, :final isInitialFetch) =>
        QueryLoading(
          isInitialFetch: isInitialFetch,
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

  /// Returns the current error if the query is in an error state.
  dynamic get error {
    return switch (this) {
      QueryError<T>(:final error) => error,
      _ => null,
    };
  }
}

/// {@template QueryInitial}
/// The initial state of the query, before the `queryFn` has been called.
/// {@endtemplate}
class QueryInitial<T> extends QueryStatus<T> {
  @override
  final T? data;

  /// {@macro QueryInitial}
  const QueryInitial({required super.timeCreated, this.data});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryInitial &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          data == other.data;

  @override
  int get hashCode => timeCreated.hashCode ^ data.hashCode;

  @override
  String toString() {
    return 'QueryInitial(timeCreated: $timeCreated, data: $data)';
  }
}

/// {@template QuerySuccess}
/// The state of the query when the `queryFn` has been successfully called.
/// {@endtemplate}
class QuerySuccess<T> extends QueryStatus<T> {
  @override
  final T data;

  /// {@macro QuerySuccess}
  const QuerySuccess({required super.timeCreated, required this.data});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuerySuccess &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          data == other.data;

  @override
  int get hashCode => timeCreated.hashCode ^ data.hashCode;

  @override
  String toString() {
    return 'QuerySuccess(timeCreated: $timeCreated, data: $data)';
  }
}

/// {@template QueryLoading}
/// The state of the query when the `queryFn` is currently being called.
/// {@endtemplate}
class QueryLoading<T> extends QueryStatus<T> {
  @override
  final T? data;

  /// True if the query has never been fetched before.
  final bool isInitialFetch;

  /// Whether the query is currently refetching
  final bool isRefetching;

  /// {@macro QueryLoading}
  const QueryLoading({
    required super.timeCreated,
    this.data,
    required this.isRefetching,
    required this.isInitialFetch,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryLoading &&
          isInitialFetch == other.isInitialFetch &&
          runtimeType == other.runtimeType &&
          timeCreated == other.timeCreated &&
          isRefetching == other.isRefetching &&
          data == other.data;

  @override
  int get hashCode =>
      timeCreated.hashCode ^
      data.hashCode ^
      isRefetching.hashCode ^
      isInitialFetch.hashCode;

  @override
  String toString() {
    return 'QueryLoading(timeCreated: $timeCreated, data: $data, isInitialFetch: $isInitialFetch, isRefetching: $isRefetching)';
  }
}

/// {@template QueryError}
/// The state of the query when an error is thrown.
/// {@endtemplate}
class QueryError<T> extends QueryStatus<T> {
  @override
  final T? data;

  /// Current error for the query.
  @override
  final dynamic error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  ///{@macro QueryError}
  const QueryError({
    required super.timeCreated,
    this.data,
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

  @override
  String toString() {
    return 'QueryError(timeCreated: $timeCreated, data: $data, error: $error, stackTrace: $stackTrace)';
  }
}

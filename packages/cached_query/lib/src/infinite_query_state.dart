part of "query_state.dart";

/// {@template InfiniteQueryData}
/// An Interface for infinite query data.
/// {@endtemplate}
abstract interface class InfiniteQueryData<T, Arg> {
  /// The pages of data returned from the queryFn
  List<T>? get data;

  /// The pageParams used to fetch the page of the same index
  List<Arg?>? get pageParams;
}

/// {@template infiniteQueryState}
/// [InfiniteQueryStatus] holds the current state of an [InfiniteQuery]
/// {@endtemplate}
sealed class InfiniteQueryStatus<T, Arg>
    implements QueryState<List<T>>, InfiniteQueryData<T, Arg> {
  @override
  final DateTime timeCreated;

  @override
  final List<T>? data;

  /// {@macro infiniteQueryState}
  const InfiniteQueryStatus({required this.timeCreated, required this.data});

  const factory InfiniteQueryStatus.initial({
    required DateTime timeCreated,
    required List<T>? data,
  }) = InfiniteQueryInitial<T, Arg>;

  ///{@macro InfiniteQuerySuccess}
  const factory InfiniteQueryStatus.success({
    required DateTime timeCreated,
    required List<T> data,
    required List<Arg> pageParams,
  }) = InfiniteQuerySuccess<T, Arg>;

  ///{@macro InfiniteQueryLoading}
  const factory InfiniteQueryStatus.loading({
    required DateTime timeCreated,
    required List<T>? data,
    required List<Arg>? pageParams,
    required bool isRefetching,
    required bool isFetchingNextPage,
  }) = InfiniteQueryLoading<T, Arg>;

  ///{@macro InfiniteQueryError}
  const factory InfiniteQueryStatus.error({
    required DateTime timeCreated,
    required dynamic error,
    required StackTrace stackTrace,
    required List<T>? data,
    required List<Arg>? pageParams,
  }) = InfiniteQueryError<T, Arg>;

  /// Copy the current state with new data
  @override
  InfiniteQueryStatus<T, Arg> copyWithData(List<T>? data);

  @override
  bool get isInitial => this is InfiniteQueryInitial;

  @override
  bool get isLoading => this is InfiniteQueryLoading;

  @override
  bool get isError => this is InfiniteQueryError;

  @override
  bool get isSuccess => this is InfiniteQuerySuccess;

  /// The pages of data returned from the queryFn
  @override
  List<Arg?>? get pageParams => switch (this) {
        InfiniteQueryInitial<T, Arg>() => null,
        InfiniteQuerySuccess<T, Arg>(:final pageParams) => pageParams,
        InfiniteQueryLoading<T, Arg>(:final pageParams) ||
        InfiniteQueryError<T, Arg>(:final pageParams) =>
          pageParams,
      };

  /// The last page of data returned from the queryFn
  T? get lastPage {
    if (this is InfiniteQueryInitial<T, Arg>) {
      return null;
    }
    final data = this.data;
    if (data == null || data.isEmpty) return null;
    return data.last;
  }

  /// The number of pages that have been fetched
  @Deprecated("Use data.length instead")
  int get length {
    return data?.length ?? 0;
  }

  /// The first page of data returned from the queryFn
  T? get firstPage {
    if (this is InfiniteQueryInitial<T, Arg>) {
      return null;
    }
    final data = this.data;
    if (data == null || data.isEmpty) return null;
    return data.first;
  }
}

/// {@template InfiniteQueryInitial}
/// The initial state of the query, before the `queryFn` has been called.
/// {@endtemplate}
class InfiniteQueryInitial<T, Arg> extends InfiniteQueryStatus<T, Arg> {
  /// {@macro InfiniteQueryInitial}
  const InfiniteQueryInitial({
    required super.timeCreated,
    super.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryInitial &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode => timeCreated.hashCode ^ data.hashCode;

  @override
  InfiniteQueryInitial<T, Arg> copyWithData(List<T>? data) {
    return InfiniteQueryInitial<T, Arg>(
      timeCreated: timeCreated,
      data: data,
    );
  }
}

/// {@template InfiniteQueryLoading}
/// Loading state of an infinite query.
/// {@endtemplate}
class InfiniteQueryLoading<T, Arg> extends InfiniteQueryStatus<T, Arg>
    implements InfiniteQueryData<T, Arg> {
  /// True if the query is currently re-fetching data.
  final bool isRefetching;

  /// True if the query is currently fetching the next page of data.
  final bool isFetchingNextPage;

  @override
  final List<Arg?>? pageParams;

  /// {@macro InfiniteQueryLoading}
  const InfiniteQueryLoading({
    required super.timeCreated,
    required super.data,
    required this.pageParams,
    required this.isRefetching,
    required this.isFetchingNextPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryLoading &&
          runtimeType == other.runtimeType &&
          isRefetching == other.isRefetching &&
          isFetchingNextPage == other.isFetchingNextPage &&
          data == other.data &&
          pageParams == other.pageParams &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode =>
      isRefetching.hashCode ^
      isFetchingNextPage.hashCode ^
      data.hashCode ^
      pageParams.hashCode ^
      timeCreated.hashCode;

  @override
  InfiniteQueryLoading<T, Arg> copyWithData(List<T>? data) {
    return InfiniteQueryLoading<T, Arg>(
      timeCreated: timeCreated,
      data: data,
      pageParams: pageParams,
      isRefetching: isRefetching,
      isFetchingNextPage: isFetchingNextPage,
    );
  }
}

/// {@template InfiniteQuerySuccess}
/// Successful response of an infinite query.
/// {@endtemplate}
class InfiniteQuerySuccess<T, Arg> extends InfiniteQueryStatus<T, Arg>
    implements InfiniteQueryData<T, Arg> {
  @override
  final List<Arg?> pageParams;

  ///{@macro InfiniteQuerySuccess}
  const InfiniteQuerySuccess({
    required super.timeCreated,
    required super.data,
    required this.pageParams,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQuerySuccess &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          pageParams == other.pageParams &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode =>
      data.hashCode ^ pageParams.hashCode ^ timeCreated.hashCode;

  @override
  InfiniteQuerySuccess<T, Arg> copyWithData(List<T>? data) {
    return InfiniteQuerySuccess<T, Arg>(
      timeCreated: timeCreated,
      data: data,
      pageParams: pageParams,
    );
  }
}

/// {@template InfiniteQueryError}
/// Error response of an infinite query.
/// {@endtemplate}
class InfiniteQueryError<T, Arg> extends InfiniteQueryStatus<T, Arg>
    implements InfiniteQueryData<T, Arg> {
  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  final dynamic error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  final List<Arg?>? pageParams;

  /// {@macro InfiniteQueryError}
  const InfiniteQueryError({
    required super.timeCreated,
    required super.data,
    required this.error,
    required this.stackTrace,
    required this.pageParams,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryError &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          stackTrace == other.stackTrace &&
          data == other.data &&
          pageParams == other.pageParams &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode =>
      error.hashCode ^
      stackTrace.hashCode ^
      data.hashCode ^
      pageParams.hashCode ^
      timeCreated.hashCode;

  @override
  InfiniteQueryError<T, Arg> copyWithData(List<T>? data) {
    return InfiniteQueryError<T, Arg>(
      timeCreated: timeCreated,
      data: data,
      error: error,
      stackTrace: stackTrace,
      pageParams: pageParams,
    );
  }
}

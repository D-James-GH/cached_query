// ignore_for_file: deprecated_member_use_from_same_package

part of "query_state.dart";

/// {@template InfiniteQueryData}
/// An Interface for infinite query data.
/// {@endtemplate}
final class InfiniteQueryData<T, Arg> {
  /// The pages of data returned from the queryFn
  List<T> pages;

  /// The arguments used to fetch the page of the same index
  List<Arg> args;

  /// {@macro InfiniteQueryData}
  InfiniteQueryData({required this.pages, required this.args});

  /// Converts the data to a json object.
  Map<String, dynamic> toJson() {
    return {
      'pages': pages,
      'args': args,
    };
  }

  /// Converts the json object to a [InfiniteQueryData].
  factory InfiniteQueryData.fromJson(
    dynamic json, {
    required List<T> Function(List<dynamic> json) pagesConverter,
    required List<Arg> Function(List<dynamic> json) argsConverter,
  }) {
    return InfiniteQueryData(
      pages: pagesConverter(json['pages'] as List<dynamic>),
      args: argsConverter(json['args'] as List<dynamic>),
    );
  }

  /// The last page of the infinite query.
  T? get lastPage {
    if (pages.isEmpty) return null;
    return pages.last;
  }

  /// The first page of the infinite query.
  T? get firstPage {
    if (pages.isEmpty) return null;
    return pages.first;
  }

  /// The number of pages in the infinite query.
  int get length => pages.length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryData &&
          runtimeType == other.runtimeType &&
          pages == other.pages &&
          args == other.args;

  @override
  int get hashCode => pages.hashCode ^ args.hashCode;

  @override
  String toString() {
    return 'InfiniteQueryData(pages: $pages, args: $args)';
  }
}

/// {@template infiniteQueryState}
/// [InfiniteQueryStatus] holds the current state of an [InfiniteQuery]
/// {@endtemplate}
sealed class InfiniteQueryStatus<T, Arg>
    implements QueryState<InfiniteQueryData<T, Arg>> {
  @override
  final DateTime timeCreated;

  @override
  InfiniteQueryData<T, Arg>? get data;

  /// {@macro infiniteQueryState}
  const InfiniteQueryStatus({required this.timeCreated});

  const factory InfiniteQueryStatus.initial({
    required DateTime timeCreated,
    required InfiniteQueryData<T, Arg>? data,
  }) = InfiniteQueryInitial<T, Arg>;

  ///{@macro InfiniteQuerySuccess}
  const factory InfiniteQueryStatus.success({
    required DateTime timeCreated,
    required bool hasReachedMax,
    required bool hasNextPage,
    required bool hasPreviousPage,
    required InfiniteQueryData<T, Arg> data,
  }) = InfiniteQuerySuccess<T, Arg>;

  ///{@macro InfiniteQueryLoading}
  const factory InfiniteQueryStatus.loading({
    required DateTime timeCreated,
    required InfiniteQueryData<T, Arg>? data,
    required bool isRefetching,
    required bool isFetchingNextPage,
    required bool isInitialFetch,
  }) = InfiniteQueryLoading<T, Arg>;

  ///{@macro InfiniteQueryError}
  const factory InfiniteQueryStatus.error({
    required DateTime timeCreated,
    required dynamic error,
    required StackTrace stackTrace,
    required InfiniteQueryData<T, Arg>? data,
  }) = InfiniteQueryError<T, Arg>;

  /// Copy the current state with new data
  @override
  InfiniteQueryStatus<T, Arg> copyWithData(
    InfiniteQueryData<T, Arg>? data, [
    DateTime? timeCreated,
  ]);

  @override
  bool get isInitial => this is InfiniteQueryInitial;

  @override
  bool get isLoading => this is InfiniteQueryLoading;

  @override
  bool get isError => this is InfiniteQueryError;

  @override
  bool get isSuccess => this is InfiniteQuerySuccess;

  /// The last page of data returned from the queryFn
  T? get lastPage {
    if (this is InfiniteQueryInitial<T, Arg>) {
      return null;
    }
    final data = this.data;
    if (data == null || data.pages.isEmpty) return null;
    return data.pages.last;
  }

  /// The number of pages that have been fetched
  int get length {
    return data?.pages.length ?? 0;
  }

  /// The first page of data returned from the queryFn
  T? get firstPage {
    if (this is InfiniteQueryInitial<T, Arg>) {
      return null;
    }
    final data = this.data;
    if (data == null || data.pages.isEmpty) return null;
    return data.pages.first;
  }

  /// Returns the current error if the query is in an error state.
  dynamic get error {
    return switch (this) {
      InfiniteQueryError<T, Arg>(:final error) => error,
      _ => null,
    };
  }
}

/// {@template InfiniteQueryInitial}
/// The initial state of the query, before the `queryFn` has been called.
/// {@endtemplate}
final class InfiniteQueryInitial<T, Arg> extends InfiniteQueryStatus<T, Arg> {
  @override
  final InfiniteQueryData<T, Arg>? data;

  /// {@macro InfiniteQueryInitial}
  const InfiniteQueryInitial({
    required super.timeCreated,
    this.data,
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
  InfiniteQueryInitial<T, Arg> copyWithData(
    InfiniteQueryData<T, Arg>? data, [
    DateTime? timeCreated,
  ]) {
    return InfiniteQueryInitial<T, Arg>(
      timeCreated: timeCreated ?? this.timeCreated,
      data: data,
    );
  }

  @override
  String toString() {
    return 'InfiniteQueryInitial(timeCreated: $timeCreated, data: $data)';
  }
}

/// {@template InfiniteQueryLoading}
/// Loading state of an infinite query.
/// {@endtemplate}
final class InfiniteQueryLoading<T, Arg> extends InfiniteQueryStatus<T, Arg> {
  @override
  final InfiniteQueryData<T, Arg>? data;

  /// True if the query has never been fetched before.
  final bool isInitialFetch;

  /// True if the query is currently re-fetching data.
  final bool isRefetching;

  /// True if the query is currently fetching the next page of data.
  final bool isFetchingNextPage;

  /// {@macro InfiniteQueryLoading}
  const InfiniteQueryLoading({
    required super.timeCreated,
    required this.data,
    required this.isRefetching,
    required this.isFetchingNextPage,
    required this.isInitialFetch,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryLoading &&
          runtimeType == other.runtimeType &&
          isInitialFetch == other.isInitialFetch &&
          isRefetching == other.isRefetching &&
          isFetchingNextPage == other.isFetchingNextPage &&
          data == other.data &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode =>
      isInitialFetch.hashCode ^
      isRefetching.hashCode ^
      isFetchingNextPage.hashCode ^
      data.hashCode ^
      timeCreated.hashCode;

  @override
  InfiniteQueryLoading<T, Arg> copyWithData(
    InfiniteQueryData<T, Arg>? data, [
    DateTime? timeCreated,
  ]) {
    return InfiniteQueryLoading<T, Arg>(
      isInitialFetch: isInitialFetch,
      timeCreated: timeCreated ?? this.timeCreated,
      data: data,
      isRefetching: isRefetching,
      isFetchingNextPage: isFetchingNextPage,
    );
  }

  @override
  String toString() {
    return 'InfiniteQueryLoading(timeCreated: $timeCreated, data: $data, isRefetching: $isRefetching, isFetchingNextPage: $isFetchingNextPage, isInitialFetch: $isInitialFetch)';
  }
}

/// {@template InfiniteQuerySuccess}
/// Successful response of an infinite query.
/// {@endtemplate}
class InfiniteQuerySuccess<T, Arg> extends InfiniteQueryStatus<T, Arg> {
  @override
  final InfiniteQueryData<T, Arg> data;

  /// True if there are no more pages to fetch.
  @Deprecated(
    "Use hasNextPage() instead. Since adding previous page fetching, hasReachedMax is less clear.",
  )
  final bool hasReachedMax;

  /// True if there is a next page to fetch.
  final bool hasNextPage;

  /// True if there is a previous page to fetch.
  final bool hasPreviousPage;

  ///{@macro InfiniteQuerySuccess}
  const InfiniteQuerySuccess({
    required super.timeCreated,
    required this.hasReachedMax,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQuerySuccess &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          hasNextPage == other.hasNextPage &&
          hasPreviousPage == other.hasPreviousPage &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode =>
      data.hashCode ^
      timeCreated.hashCode ^
      hasNextPage.hashCode ^
      hasPreviousPage.hashCode ^
      hasReachedMax.hashCode ^
      timeCreated.hashCode;

  @override
  InfiniteQuerySuccess<T, Arg> copyWithData(
    InfiniteQueryData<T, Arg>? data, [
    DateTime? timeCreated,
  ]) {
    assert(
      data != null,
      "Data in a successfully fetched query cannot be null; Please report this bug.",
    );
    return InfiniteQuerySuccess<T, Arg>(
      timeCreated: timeCreated ?? this.timeCreated,
      hasReachedMax: hasReachedMax,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
      data: data!,
    );
  }

  @override
  String toString() {
    return 'InfiniteQuerySuccess(timeCreated: $timeCreated, data: $data, hasReachedMax: $hasReachedMax, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
  }
}

/// {@template InfiniteQueryError}
/// Error response of an infinite query.
/// {@endtemplate}
final class InfiniteQueryError<T, Arg> extends InfiniteQueryStatus<T, Arg> {
  @override
  final InfiniteQueryData<T, Arg>? data;

  /// Current error for the query.
  ///
  /// Equal to null if there is no error.
  @override
  final dynamic error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  /// {@macro InfiniteQueryError}
  const InfiniteQueryError({
    required super.timeCreated,
    required this.data,
    required this.error,
    required this.stackTrace,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfiniteQueryError &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          stackTrace == other.stackTrace &&
          data == other.data &&
          timeCreated == other.timeCreated;

  @override
  int get hashCode =>
      error.hashCode ^
      stackTrace.hashCode ^
      data.hashCode ^
      timeCreated.hashCode;

  @override
  InfiniteQueryError<T, Arg> copyWithData(
    InfiniteQueryData<T, Arg>? data, [
    DateTime? timeCreated,
  ]) {
    return InfiniteQueryError<T, Arg>(
      timeCreated: timeCreated ?? this.timeCreated,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    return 'InfiniteQueryError(timeCreated: $timeCreated, error: $error, stackTrace: $stackTrace, data: $data)';
  }
}

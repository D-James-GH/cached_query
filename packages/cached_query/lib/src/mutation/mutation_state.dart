/// {@template mutationState}
/// [MutationState] holds the current state of a [Mutation].
///
/// Should not be instantiated manually. Instead should be read from [Mutation].
/// {@endtemplate}
sealed class MutationState<T> {
  /// Response of the [MutationQueryCallback].
  T? get data;

  /// {@macro mutationState}
  const MutationState();

  /// Whether this is the initial state
  bool get isInitial => this is MutationInitial;

  /// Whether this is the loading state
  bool get isLoading => this is MutationLoading;

  /// Whether this is the success state
  bool get isSuccess => this is MutationSuccess;

  /// Whether this is the error state
  bool get isError => this is MutationError;

  /// Returns the current error if the query is in an error state.
  dynamic get error {
    return switch (this) {
      MutationError<T>(:final error) => error,
      _ => null,
    };
  }
}

/// {@template MutationInitial}
/// The initial state of the mutation.
/// {@endtemplate}
class MutationInitial<T> extends MutationState<T> {
  @override
  final T? data;

  /// {@macro MutationInitial}
  const MutationInitial({this.data});

  @override
  String toString() => 'MutationInitial(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationInitial &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// {@template MutationLoading}
/// The loading state of the mutation.
/// {@endtemplate}
class MutationLoading<T> extends MutationState<T> {
  @override
  final T? data;

  /// {@macro MutationLoading}
  const MutationLoading({this.data});

  @override
  String toString() => 'MutationLoading(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationLoading &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// {@template MutationSuccess}
/// The success state of the mutation.
/// {@endtemplate}
class MutationSuccess<T> extends MutationState<T> {
  @override
  final T data;

  /// {@macro MutationSuccess}
  const MutationSuccess({required this.data});

  @override
  String toString() => 'MutationSuccess(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationSuccess &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// {@template MutationError}
/// The error state of the mutation.
/// {@endtemplate}
class MutationError<T> extends MutationState<T> {
  @override
  final T? data;

  /// The error of the mutation.
  @override
  final Object error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  /// {@macro MutationError}
  const MutationError({
    this.data,
    required this.error,
    required this.stackTrace,
  });

  @override
  String toString() {
    return 'MutationError(data: $data, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationError &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          error == other.error &&
          stackTrace == other.stackTrace;

  @override
  int get hashCode => data.hashCode ^ error.hashCode ^ stackTrace.hashCode;
}

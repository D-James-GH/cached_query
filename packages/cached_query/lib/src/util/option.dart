/// {@template Option}
/// A utility class that represents an optional value.
///
/// It's a sealed class that can be either a [Some] with a value of type [T]
/// or a [None] with no value.
///
/// Use [Option.some] to create a [Some] with a value of type [T].
/// Use [Option.none] to create a [None].
///
/// This is rarely needed. Null safety is usually good enough. It is only needed when working with
/// type parameters that are nullable.
///
/// In this case we want to know whether a use is caching a nullable value OR
/// no value has be cached.
///
/// {@endtemplate}
sealed class Option<T> {
  /// {@macro Option}
  const Option();

  factory Option.fromNullable(
    T? initialData,
  ) {
    return initialData == null ? Option.none() : Option.some(initialData);
  }

  factory Option.some(T value) = Some<T>;
  factory Option.none() = None<T>;

  /// Returns true if this is a [Some], false if it is a [None].
  bool get isSome => this is Some<T>;

  /// Returns true if this is a [None], false if it is a [Some].
  bool get isNone => this is None<T>;

  /// Returns the value if this is a [Some], null if it is a [None].
  T? get valueOrNull => switch (this) {
        Some<T>(:final value) => value,
        None<T>() => null,
      };
}

/// {@template Some}
/// Represents an optional value that is present.
/// {@endtemplate}
class Some<T> extends Option<T> {
  ///// {@macro Some}
  final T value;

  /// {@macro Some}
  Some(this.value);
}

/// {@template None}
/// Represents an optional value that is absent.
/// {@endtemplate}
class None<T> extends Option<T> {
  /// {@macro None}
  const None();
}

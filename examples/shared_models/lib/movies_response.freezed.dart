// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movies_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoviesResponse {
  List<Movie> get movies;
  int get total;
  int get skip;
  int get limit;

  /// Create a copy of MoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MoviesResponseCopyWith<MoviesResponse> get copyWith =>
      _$MoviesResponseCopyWithImpl<MoviesResponse>(
          this as MoviesResponse, _$identity);

  /// Serializes this MoviesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MoviesResponse &&
            const DeepCollectionEquality().equals(other.movies, movies) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(movies), total, skip, limit);

  @override
  String toString() {
    return 'MoviesResponse(movies: $movies, total: $total, skip: $skip, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $MoviesResponseCopyWith<$Res> {
  factory $MoviesResponseCopyWith(
          MoviesResponse value, $Res Function(MoviesResponse) _then) =
      _$MoviesResponseCopyWithImpl;
  @useResult
  $Res call({List<Movie> movies, int total, int skip, int limit});
}

/// @nodoc
class _$MoviesResponseCopyWithImpl<$Res>
    implements $MoviesResponseCopyWith<$Res> {
  _$MoviesResponseCopyWithImpl(this._self, this._then);

  final MoviesResponse _self;
  final $Res Function(MoviesResponse) _then;

  /// Create a copy of MoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movies = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(_self.copyWith(
      movies: null == movies
          ? _self.movies
          : movies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      skip: null == skip
          ? _self.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MoviesResponse].
extension MoviesResponsePatterns on MoviesResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MoviesResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MoviesResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MoviesResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MoviesResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<Movie> movies, int total, int skip, int limit)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MoviesResponse() when $default != null:
        return $default(_that.movies, _that.total, _that.skip, _that.limit);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<Movie> movies, int total, int skip, int limit)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponse():
        return $default(_that.movies, _that.total, _that.skip, _that.limit);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<Movie> movies, int total, int skip, int limit)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponse() when $default != null:
        return $default(_that.movies, _that.total, _that.skip, _that.limit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MoviesResponse implements MoviesResponse {
  const _MoviesResponse(
      {required final List<Movie> movies,
      required this.total,
      required this.skip,
      required this.limit})
      : _movies = movies;
  factory _MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);

  final List<Movie> _movies;
  @override
  List<Movie> get movies {
    if (_movies is EqualUnmodifiableListView) return _movies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_movies);
  }

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;

  /// Create a copy of MoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MoviesResponseCopyWith<_MoviesResponse> get copyWith =>
      __$MoviesResponseCopyWithImpl<_MoviesResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MoviesResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MoviesResponse &&
            const DeepCollectionEquality().equals(other._movies, _movies) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_movies), total, skip, limit);

  @override
  String toString() {
    return 'MoviesResponse(movies: $movies, total: $total, skip: $skip, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class _$MoviesResponseCopyWith<$Res>
    implements $MoviesResponseCopyWith<$Res> {
  factory _$MoviesResponseCopyWith(
          _MoviesResponse value, $Res Function(_MoviesResponse) _then) =
      __$MoviesResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<Movie> movies, int total, int skip, int limit});
}

/// @nodoc
class __$MoviesResponseCopyWithImpl<$Res>
    implements _$MoviesResponseCopyWith<$Res> {
  __$MoviesResponseCopyWithImpl(this._self, this._then);

  final _MoviesResponse _self;
  final $Res Function(_MoviesResponse) _then;

  /// Create a copy of MoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? movies = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(_MoviesResponse(
      movies: null == movies
          ? _self._movies
          : movies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      skip: null == skip
          ? _self.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

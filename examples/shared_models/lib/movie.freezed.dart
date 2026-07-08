// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Movie {
  String get imdbId;
  String get title;
  String get plot;
  String get year;
  String get poster;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieCopyWith<Movie> get copyWith =>
      _$MovieCopyWithImpl<Movie>(this as Movie, _$identity);

  /// Serializes this Movie to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Movie &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.plot, plot) || other.plot == plot) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.poster, poster) || other.poster == poster));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imdbId, title, plot, year, poster);

  @override
  String toString() {
    return 'Movie(imdbId: $imdbId, title: $title, plot: $plot, year: $year, poster: $poster)';
  }
}

/// @nodoc
abstract mixin class $MovieCopyWith<$Res> {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) _then) =
      _$MovieCopyWithImpl;
  @useResult
  $Res call(
      {String imdbId, String title, String plot, String year, String poster});
}

/// @nodoc
class _$MovieCopyWithImpl<$Res> implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._self, this._then);

  final Movie _self;
  final $Res Function(Movie) _then;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imdbId = null,
    Object? title = null,
    Object? plot = null,
    Object? year = null,
    Object? poster = null,
  }) {
    return _then(_self.copyWith(
      imdbId: null == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      plot: null == plot
          ? _self.plot
          : plot // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      poster: null == poster
          ? _self.poster
          : poster // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Movie].
extension MoviePatterns on Movie {
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
    TResult Function(_Movie value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Movie() when $default != null:
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
    TResult Function(_Movie value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Movie():
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
    TResult? Function(_Movie value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Movie() when $default != null:
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
    TResult Function(String imdbId, String title, String plot, String year,
            String poster)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Movie() when $default != null:
        return $default(
            _that.imdbId, _that.title, _that.plot, _that.year, _that.poster);
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
    TResult Function(String imdbId, String title, String plot, String year,
            String poster)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Movie():
        return $default(
            _that.imdbId, _that.title, _that.plot, _that.year, _that.poster);
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
    TResult? Function(String imdbId, String title, String plot, String year,
            String poster)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Movie() when $default != null:
        return $default(
            _that.imdbId, _that.title, _that.plot, _that.year, _that.poster);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Movie implements Movie {
  const _Movie(
      {required this.imdbId,
      required this.title,
      required this.plot,
      required this.year,
      required this.poster});
  factory _Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  final String imdbId;
  @override
  final String title;
  @override
  final String plot;
  @override
  final String year;
  @override
  final String poster;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieCopyWith<_Movie> get copyWith =>
      __$MovieCopyWithImpl<_Movie>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MovieToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Movie &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.plot, plot) || other.plot == plot) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.poster, poster) || other.poster == poster));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imdbId, title, plot, year, poster);

  @override
  String toString() {
    return 'Movie(imdbId: $imdbId, title: $title, plot: $plot, year: $year, poster: $poster)';
  }
}

/// @nodoc
abstract mixin class _$MovieCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$MovieCopyWith(_Movie value, $Res Function(_Movie) _then) =
      __$MovieCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String imdbId, String title, String plot, String year, String poster});
}

/// @nodoc
class __$MovieCopyWithImpl<$Res> implements _$MovieCopyWith<$Res> {
  __$MovieCopyWithImpl(this._self, this._then);

  final _Movie _self;
  final $Res Function(_Movie) _then;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imdbId = null,
    Object? title = null,
    Object? plot = null,
    Object? year = null,
    Object? poster = null,
  }) {
    return _then(_Movie(
      imdbId: null == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      plot: null == plot
          ? _self.plot
          : plot // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      poster: null == poster
          ? _self.poster
          : poster // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

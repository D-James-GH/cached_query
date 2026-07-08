// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'posts_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostsResponse {
  List<Post> get posts;
  int get total;
  int get skip;
  int get limit;

  /// Create a copy of PostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostsResponseCopyWith<PostsResponse> get copyWith =>
      _$PostsResponseCopyWithImpl<PostsResponse>(
          this as PostsResponse, _$identity);

  /// Serializes this PostsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostsResponse &&
            const DeepCollectionEquality().equals(other.posts, posts) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(posts), total, skip, limit);

  @override
  String toString() {
    return 'PostsResponse(posts: $posts, total: $total, skip: $skip, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $PostsResponseCopyWith<$Res> {
  factory $PostsResponseCopyWith(
          PostsResponse value, $Res Function(PostsResponse) _then) =
      _$PostsResponseCopyWithImpl;
  @useResult
  $Res call({List<Post> posts, int total, int skip, int limit});
}

/// @nodoc
class _$PostsResponseCopyWithImpl<$Res>
    implements $PostsResponseCopyWith<$Res> {
  _$PostsResponseCopyWithImpl(this._self, this._then);

  final PostsResponse _self;
  final $Res Function(PostsResponse) _then;

  /// Create a copy of PostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(_self.copyWith(
      posts: null == posts
          ? _self.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
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

/// Adds pattern-matching-related methods to [PostsResponse].
extension PostsResponsePatterns on PostsResponse {
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
    TResult Function(_PostsResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostsResponse() when $default != null:
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
    TResult Function(_PostsResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostsResponse():
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
    TResult? Function(_PostsResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostsResponse() when $default != null:
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
    TResult Function(List<Post> posts, int total, int skip, int limit)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostsResponse() when $default != null:
        return $default(_that.posts, _that.total, _that.skip, _that.limit);
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
    TResult Function(List<Post> posts, int total, int skip, int limit) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostsResponse():
        return $default(_that.posts, _that.total, _that.skip, _that.limit);
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
    TResult? Function(List<Post> posts, int total, int skip, int limit)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostsResponse() when $default != null:
        return $default(_that.posts, _that.total, _that.skip, _that.limit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PostsResponse implements PostsResponse {
  const _PostsResponse(
      {required final List<Post> posts,
      required this.total,
      required this.skip,
      required this.limit})
      : _posts = posts;
  factory _PostsResponse.fromJson(Map<String, dynamic> json) =>
      _$PostsResponseFromJson(json);

  final List<Post> _posts;
  @override
  List<Post> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;

  /// Create a copy of PostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostsResponseCopyWith<_PostsResponse> get copyWith =>
      __$PostsResponseCopyWithImpl<_PostsResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostsResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostsResponse &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_posts), total, skip, limit);

  @override
  String toString() {
    return 'PostsResponse(posts: $posts, total: $total, skip: $skip, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class _$PostsResponseCopyWith<$Res>
    implements $PostsResponseCopyWith<$Res> {
  factory _$PostsResponseCopyWith(
          _PostsResponse value, $Res Function(_PostsResponse) _then) =
      __$PostsResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<Post> posts, int total, int skip, int limit});
}

/// @nodoc
class __$PostsResponseCopyWithImpl<$Res>
    implements _$PostsResponseCopyWith<$Res> {
  __$PostsResponseCopyWithImpl(this._self, this._then);

  final _PostsResponse _self;
  final $Res Function(_PostsResponse) _then;

  /// Create a copy of PostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? posts = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
  }) {
    return _then(_PostsResponse(
      posts: null == posts
          ? _self._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
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

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryInstance {
  String get key;
  String get type;
  InstanceRef get valueRef;

  /// Create a copy of QueryInstance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryInstanceCopyWith<QueryInstance> get copyWith =>
      _$QueryInstanceCopyWithImpl<QueryInstance>(
          this as QueryInstance, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryInstance &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.valueRef, valueRef) ||
                other.valueRef == valueRef));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, valueRef);

  @override
  String toString() {
    return 'QueryInstance(key: $key, type: $type, valueRef: $valueRef)';
  }
}

/// @nodoc
abstract mixin class $QueryInstanceCopyWith<$Res> {
  factory $QueryInstanceCopyWith(
          QueryInstance value, $Res Function(QueryInstance) _then) =
      _$QueryInstanceCopyWithImpl;
  @useResult
  $Res call({String key, String type, InstanceRef valueRef});
}

/// @nodoc
class _$QueryInstanceCopyWithImpl<$Res>
    implements $QueryInstanceCopyWith<$Res> {
  _$QueryInstanceCopyWithImpl(this._self, this._then);

  final QueryInstance _self;
  final $Res Function(QueryInstance) _then;

  /// Create a copy of QueryInstance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? valueRef = null,
  }) {
    return _then(_self.copyWith(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      valueRef: null == valueRef
          ? _self.valueRef
          : valueRef // ignore: cast_nullable_to_non_nullable
              as InstanceRef,
    ));
  }
}

/// Adds pattern-matching-related methods to [QueryInstance].
extension QueryInstancePatterns on QueryInstance {
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
    TResult Function(_QueryItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryItem() when $default != null:
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
    TResult Function(_QueryItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryItem():
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
    TResult? Function(_QueryItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryItem() when $default != null:
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
    TResult Function(String key, String type, InstanceRef valueRef)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryItem() when $default != null:
        return $default(_that.key, _that.type, _that.valueRef);
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
    TResult Function(String key, String type, InstanceRef valueRef) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryItem():
        return $default(_that.key, _that.type, _that.valueRef);
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
    TResult? Function(String key, String type, InstanceRef valueRef)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryItem() when $default != null:
        return $default(_that.key, _that.type, _that.valueRef);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _QueryItem implements QueryInstance {
  const _QueryItem(
      {required this.key, required this.type, required this.valueRef});

  @override
  final String key;
  @override
  final String type;
  @override
  final InstanceRef valueRef;

  /// Create a copy of QueryInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QueryItemCopyWith<_QueryItem> get copyWith =>
      __$QueryItemCopyWithImpl<_QueryItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QueryItem &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.valueRef, valueRef) ||
                other.valueRef == valueRef));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, valueRef);

  @override
  String toString() {
    return 'QueryInstance(key: $key, type: $type, valueRef: $valueRef)';
  }
}

/// @nodoc
abstract mixin class _$QueryItemCopyWith<$Res>
    implements $QueryInstanceCopyWith<$Res> {
  factory _$QueryItemCopyWith(
          _QueryItem value, $Res Function(_QueryItem) _then) =
      __$QueryItemCopyWithImpl;
  @override
  @useResult
  $Res call({String key, String type, InstanceRef valueRef});
}

/// @nodoc
class __$QueryItemCopyWithImpl<$Res> implements _$QueryItemCopyWith<$Res> {
  __$QueryItemCopyWithImpl(this._self, this._then);

  final _QueryItem _self;
  final $Res Function(_QueryItem) _then;

  /// Create a copy of QueryInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? valueRef = null,
  }) {
    return _then(_QueryItem(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      valueRef: null == valueRef
          ? _self.valueRef
          : valueRef // ignore: cast_nullable_to_non_nullable
              as InstanceRef,
    ));
  }
}

/// @nodoc
mixin _$QueryListState {
  String? get selectedKey;
  List<QueryInstance> get queries;

  /// Create a copy of QueryListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryListStateCopyWith<QueryListState> get copyWith =>
      _$QueryListStateCopyWithImpl<QueryListState>(
          this as QueryListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryListState &&
            (identical(other.selectedKey, selectedKey) ||
                other.selectedKey == selectedKey) &&
            const DeepCollectionEquality().equals(other.queries, queries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, selectedKey, const DeepCollectionEquality().hash(queries));

  @override
  String toString() {
    return 'QueryListState(selectedKey: $selectedKey, queries: $queries)';
  }
}

/// @nodoc
abstract mixin class $QueryListStateCopyWith<$Res> {
  factory $QueryListStateCopyWith(
          QueryListState value, $Res Function(QueryListState) _then) =
      _$QueryListStateCopyWithImpl;
  @useResult
  $Res call({String? selectedKey, List<QueryInstance> queries});
}

/// @nodoc
class _$QueryListStateCopyWithImpl<$Res>
    implements $QueryListStateCopyWith<$Res> {
  _$QueryListStateCopyWithImpl(this._self, this._then);

  final QueryListState _self;
  final $Res Function(QueryListState) _then;

  /// Create a copy of QueryListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedKey = freezed,
    Object? queries = null,
  }) {
    return _then(_self.copyWith(
      selectedKey: freezed == selectedKey
          ? _self.selectedKey
          : selectedKey // ignore: cast_nullable_to_non_nullable
              as String?,
      queries: null == queries
          ? _self.queries
          : queries // ignore: cast_nullable_to_non_nullable
              as List<QueryInstance>,
    ));
  }
}

/// Adds pattern-matching-related methods to [QueryListState].
extension QueryListStatePatterns on QueryListState {
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
    TResult Function(_QueryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
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
    TResult Function(_QueryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState():
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
    TResult? Function(_QueryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
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
    TResult Function(String? selectedKey, List<QueryInstance> queries)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
        return $default(_that.selectedKey, _that.queries);
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
    TResult Function(String? selectedKey, List<QueryInstance> queries) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState():
        return $default(_that.selectedKey, _that.queries);
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
    TResult? Function(String? selectedKey, List<QueryInstance> queries)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryState() when $default != null:
        return $default(_that.selectedKey, _that.queries);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _QueryState implements QueryListState {
  const _QueryState(
      {this.selectedKey, required final List<QueryInstance> queries})
      : _queries = queries;

  @override
  final String? selectedKey;
  final List<QueryInstance> _queries;
  @override
  List<QueryInstance> get queries {
    if (_queries is EqualUnmodifiableListView) return _queries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queries);
  }

  /// Create a copy of QueryListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QueryStateCopyWith<_QueryState> get copyWith =>
      __$QueryStateCopyWithImpl<_QueryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QueryState &&
            (identical(other.selectedKey, selectedKey) ||
                other.selectedKey == selectedKey) &&
            const DeepCollectionEquality().equals(other._queries, _queries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, selectedKey, const DeepCollectionEquality().hash(_queries));

  @override
  String toString() {
    return 'QueryListState(selectedKey: $selectedKey, queries: $queries)';
  }
}

/// @nodoc
abstract mixin class _$QueryStateCopyWith<$Res>
    implements $QueryListStateCopyWith<$Res> {
  factory _$QueryStateCopyWith(
          _QueryState value, $Res Function(_QueryState) _then) =
      __$QueryStateCopyWithImpl;
  @override
  @useResult
  $Res call({String? selectedKey, List<QueryInstance> queries});
}

/// @nodoc
class __$QueryStateCopyWithImpl<$Res> implements _$QueryStateCopyWith<$Res> {
  __$QueryStateCopyWithImpl(this._self, this._then);

  final _QueryState _self;
  final $Res Function(_QueryState) _then;

  /// Create a copy of QueryListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedKey = freezed,
    Object? queries = null,
  }) {
    return _then(_QueryState(
      selectedKey: freezed == selectedKey
          ? _self.selectedKey
          : selectedKey // ignore: cast_nullable_to_non_nullable
              as String?,
      queries: null == queries
          ? _self._queries
          : queries // ignore: cast_nullable_to_non_nullable
              as List<QueryInstance>,
    ));
  }
}

// dart format on

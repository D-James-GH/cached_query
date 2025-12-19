// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryStateDetails implements DiagnosticableTreeMixin {
  String get dataRuntimeType;
  String get status;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryStateDetailsCopyWith<QueryStateDetails> get copyWith =>
      _$QueryStateDetailsCopyWithImpl<QueryStateDetails>(
          this as QueryStateDetails, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryStateDetails'))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryStateDetails &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dataRuntimeType, status);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryStateDetails(dataRuntimeType: $dataRuntimeType, status: $status)';
  }
}

/// @nodoc
abstract mixin class $QueryStateDetailsCopyWith<$Res> {
  factory $QueryStateDetailsCopyWith(
          QueryStateDetails value, $Res Function(QueryStateDetails) _then) =
      _$QueryStateDetailsCopyWithImpl;
  @useResult
  $Res call({String dataRuntimeType, String status});
}

/// @nodoc
class _$QueryStateDetailsCopyWithImpl<$Res>
    implements $QueryStateDetailsCopyWith<$Res> {
  _$QueryStateDetailsCopyWithImpl(this._self, this._then);

  final QueryStateDetails _self;
  final $Res Function(QueryStateDetails) _then;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      dataRuntimeType: null == dataRuntimeType
          ? _self.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [QueryStateDetails].
extension QueryStateDetailsPatterns on QueryStateDetails {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QueryStateDetailsJson value)? json,
    TResult Function(QueryStateDetailsString value)? string,
    TResult Function(InfiniteQueryDetailsJson value)? infiniteJson,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case QueryStateDetailsJson() when json != null:
        return json(_that);
      case QueryStateDetailsString() when string != null:
        return string(_that);
      case InfiniteQueryDetailsJson() when infiniteJson != null:
        return infiniteJson(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(QueryStateDetailsJson value) json,
    required TResult Function(QueryStateDetailsString value) string,
    required TResult Function(InfiniteQueryDetailsJson value) infiniteJson,
  }) {
    final _that = this;
    switch (_that) {
      case QueryStateDetailsJson():
        return json(_that);
      case QueryStateDetailsString():
        return string(_that);
      case InfiniteQueryDetailsJson():
        return infiniteJson(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QueryStateDetailsJson value)? json,
    TResult? Function(QueryStateDetailsString value)? string,
    TResult? Function(InfiniteQueryDetailsJson value)? infiniteJson,
  }) {
    final _that = this;
    switch (_that) {
      case QueryStateDetailsJson() when json != null:
        return json(_that);
      case QueryStateDetailsString() when string != null:
        return string(_that);
      case InfiniteQueryDetailsJson() when infiniteJson != null:
        return infiniteJson(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String dataRuntimeType, String status, dynamic data)? json,
    TResult Function(String dataRuntimeType, String status, String? data)?
        string,
    TResult Function(
            String status, String dataRuntimeType, List<dynamic>? pages)?
        infiniteJson,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case QueryStateDetailsJson() when json != null:
        return json(_that.dataRuntimeType, _that.status, _that.data);
      case QueryStateDetailsString() when string != null:
        return string(_that.dataRuntimeType, _that.status, _that.data);
      case InfiniteQueryDetailsJson() when infiniteJson != null:
        return infiniteJson(_that.status, _that.dataRuntimeType, _that.pages);
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
  TResult when<TResult extends Object?>({
    required TResult Function(
            String dataRuntimeType, String status, dynamic data)
        json,
    required TResult Function(
            String dataRuntimeType, String status, String? data)
        string,
    required TResult Function(
            String status, String dataRuntimeType, List<dynamic>? pages)
        infiniteJson,
  }) {
    final _that = this;
    switch (_that) {
      case QueryStateDetailsJson():
        return json(_that.dataRuntimeType, _that.status, _that.data);
      case QueryStateDetailsString():
        return string(_that.dataRuntimeType, _that.status, _that.data);
      case InfiniteQueryDetailsJson():
        return infiniteJson(_that.status, _that.dataRuntimeType, _that.pages);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String dataRuntimeType, String status, dynamic data)?
        json,
    TResult? Function(String dataRuntimeType, String status, String? data)?
        string,
    TResult? Function(
            String status, String dataRuntimeType, List<dynamic>? pages)?
        infiniteJson,
  }) {
    final _that = this;
    switch (_that) {
      case QueryStateDetailsJson() when json != null:
        return json(_that.dataRuntimeType, _that.status, _that.data);
      case QueryStateDetailsString() when string != null:
        return string(_that.dataRuntimeType, _that.status, _that.data);
      case InfiniteQueryDetailsJson() when infiniteJson != null:
        return infiniteJson(_that.status, _that.dataRuntimeType, _that.pages);
      case _:
        return null;
    }
  }
}

/// @nodoc

class QueryStateDetailsJson
    with DiagnosticableTreeMixin
    implements QueryStateDetails {
  const QueryStateDetailsJson(
      {required this.dataRuntimeType, required this.status, this.data});

  @override
  final String dataRuntimeType;
  @override
  final String status;
  final dynamic data;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryStateDetailsJsonCopyWith<QueryStateDetailsJson> get copyWith =>
      _$QueryStateDetailsJsonCopyWithImpl<QueryStateDetailsJson>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryStateDetails.json'))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryStateDetailsJson &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dataRuntimeType, status,
      const DeepCollectionEquality().hash(data));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryStateDetails.json(dataRuntimeType: $dataRuntimeType, status: $status, data: $data)';
  }
}

/// @nodoc
abstract mixin class $QueryStateDetailsJsonCopyWith<$Res>
    implements $QueryStateDetailsCopyWith<$Res> {
  factory $QueryStateDetailsJsonCopyWith(QueryStateDetailsJson value,
          $Res Function(QueryStateDetailsJson) _then) =
      _$QueryStateDetailsJsonCopyWithImpl;
  @override
  @useResult
  $Res call({String dataRuntimeType, String status, dynamic data});
}

/// @nodoc
class _$QueryStateDetailsJsonCopyWithImpl<$Res>
    implements $QueryStateDetailsJsonCopyWith<$Res> {
  _$QueryStateDetailsJsonCopyWithImpl(this._self, this._then);

  final QueryStateDetailsJson _self;
  final $Res Function(QueryStateDetailsJson) _then;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
    Object? data = freezed,
  }) {
    return _then(QueryStateDetailsJson(
      dataRuntimeType: null == dataRuntimeType
          ? _self.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class QueryStateDetailsString
    with DiagnosticableTreeMixin
    implements QueryStateDetails {
  const QueryStateDetailsString(
      {required this.dataRuntimeType, required this.status, this.data});

  @override
  final String dataRuntimeType;
  @override
  final String status;
  final String? data;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryStateDetailsStringCopyWith<QueryStateDetailsString> get copyWith =>
      _$QueryStateDetailsStringCopyWithImpl<QueryStateDetailsString>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryStateDetails.string'))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryStateDetailsString &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dataRuntimeType, status, data);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryStateDetails.string(dataRuntimeType: $dataRuntimeType, status: $status, data: $data)';
  }
}

/// @nodoc
abstract mixin class $QueryStateDetailsStringCopyWith<$Res>
    implements $QueryStateDetailsCopyWith<$Res> {
  factory $QueryStateDetailsStringCopyWith(QueryStateDetailsString value,
          $Res Function(QueryStateDetailsString) _then) =
      _$QueryStateDetailsStringCopyWithImpl;
  @override
  @useResult
  $Res call({String dataRuntimeType, String status, String? data});
}

/// @nodoc
class _$QueryStateDetailsStringCopyWithImpl<$Res>
    implements $QueryStateDetailsStringCopyWith<$Res> {
  _$QueryStateDetailsStringCopyWithImpl(this._self, this._then);

  final QueryStateDetailsString _self;
  final $Res Function(QueryStateDetailsString) _then;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
    Object? data = freezed,
  }) {
    return _then(QueryStateDetailsString(
      dataRuntimeType: null == dataRuntimeType
          ? _self.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class InfiniteQueryDetailsJson
    with DiagnosticableTreeMixin
    implements QueryStateDetails {
  const InfiniteQueryDetailsJson(
      {required this.status,
      required this.dataRuntimeType,
      final List<dynamic>? pages})
      : _pages = pages;

  @override
  final String status;
  @override
  final String dataRuntimeType;
  final List<dynamic>? _pages;
  List<dynamic>? get pages {
    final value = _pages;
    if (value == null) return null;
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InfiniteQueryDetailsJsonCopyWith<InfiniteQueryDetailsJson> get copyWith =>
      _$InfiniteQueryDetailsJsonCopyWithImpl<InfiniteQueryDetailsJson>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryStateDetails.infiniteJson'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('pages', pages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InfiniteQueryDetailsJson &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            const DeepCollectionEquality().equals(other._pages, _pages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, dataRuntimeType,
      const DeepCollectionEquality().hash(_pages));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryStateDetails.infiniteJson(status: $status, dataRuntimeType: $dataRuntimeType, pages: $pages)';
  }
}

/// @nodoc
abstract mixin class $InfiniteQueryDetailsJsonCopyWith<$Res>
    implements $QueryStateDetailsCopyWith<$Res> {
  factory $InfiniteQueryDetailsJsonCopyWith(InfiniteQueryDetailsJson value,
          $Res Function(InfiniteQueryDetailsJson) _then) =
      _$InfiniteQueryDetailsJsonCopyWithImpl;
  @override
  @useResult
  $Res call({String status, String dataRuntimeType, List<dynamic>? pages});
}

/// @nodoc
class _$InfiniteQueryDetailsJsonCopyWithImpl<$Res>
    implements $InfiniteQueryDetailsJsonCopyWith<$Res> {
  _$InfiniteQueryDetailsJsonCopyWithImpl(this._self, this._then);

  final InfiniteQueryDetailsJson _self;
  final $Res Function(InfiniteQueryDetailsJson) _then;

  /// Create a copy of QueryStateDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? dataRuntimeType = null,
    Object? pages = freezed,
  }) {
    return _then(InfiniteQueryDetailsJson(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dataRuntimeType: null == dataRuntimeType
          ? _self.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      pages: freezed == pages
          ? _self._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ));
  }
}

/// @nodoc
mixin _$QueryDetailsState implements DiagnosticableTreeMixin {
  String get key;
  String get type;
  bool? get stale;
  QueryStateDetails get state;

  /// Create a copy of QueryDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryDetailsStateCopyWith<QueryDetailsState> get copyWith =>
      _$QueryDetailsStateCopyWithImpl<QueryDetailsState>(
          this as QueryDetailsState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryDetailsState'))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('stale', stale))
      ..add(DiagnosticsProperty('state', state));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryDetailsState &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.stale, stale) || other.stale == stale) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, stale, state);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryDetailsState(key: $key, type: $type, stale: $stale, state: $state)';
  }
}

/// @nodoc
abstract mixin class $QueryDetailsStateCopyWith<$Res> {
  factory $QueryDetailsStateCopyWith(
          QueryDetailsState value, $Res Function(QueryDetailsState) _then) =
      _$QueryDetailsStateCopyWithImpl;
  @useResult
  $Res call({String key, String type, bool? stale, QueryStateDetails state});

  $QueryStateDetailsCopyWith<$Res> get state;
}

/// @nodoc
class _$QueryDetailsStateCopyWithImpl<$Res>
    implements $QueryDetailsStateCopyWith<$Res> {
  _$QueryDetailsStateCopyWithImpl(this._self, this._then);

  final QueryDetailsState _self;
  final $Res Function(QueryDetailsState) _then;

  /// Create a copy of QueryDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? stale = freezed,
    Object? state = null,
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
      stale: freezed == stale
          ? _self.stale
          : stale // ignore: cast_nullable_to_non_nullable
              as bool?,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as QueryStateDetails,
    ));
  }

  /// Create a copy of QueryDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueryStateDetailsCopyWith<$Res> get state {
    return $QueryStateDetailsCopyWith<$Res>(_self.state, (value) {
      return _then(_self.copyWith(state: value));
    });
  }
}

/// Adds pattern-matching-related methods to [QueryDetailsState].
extension QueryDetailsStatePatterns on QueryDetailsState {
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
    TResult Function(_QueryDetailsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryDetailsState() when $default != null:
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
    TResult Function(_QueryDetailsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryDetailsState():
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
    TResult? Function(_QueryDetailsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryDetailsState() when $default != null:
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
    TResult Function(
            String key, String type, bool? stale, QueryStateDetails state)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QueryDetailsState() when $default != null:
        return $default(_that.key, _that.type, _that.stale, _that.state);
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
    TResult Function(
            String key, String type, bool? stale, QueryStateDetails state)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryDetailsState():
        return $default(_that.key, _that.type, _that.stale, _that.state);
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
    TResult? Function(
            String key, String type, bool? stale, QueryStateDetails state)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QueryDetailsState() when $default != null:
        return $default(_that.key, _that.type, _that.stale, _that.state);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _QueryDetailsState
    with DiagnosticableTreeMixin
    implements QueryDetailsState {
  const _QueryDetailsState(
      {required this.key, required this.type, this.stale, required this.state});

  @override
  final String key;
  @override
  final String type;
  @override
  final bool? stale;
  @override
  final QueryStateDetails state;

  /// Create a copy of QueryDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QueryDetailsStateCopyWith<_QueryDetailsState> get copyWith =>
      __$QueryDetailsStateCopyWithImpl<_QueryDetailsState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'QueryDetailsState'))
      ..add(DiagnosticsProperty('key', key))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('stale', stale))
      ..add(DiagnosticsProperty('state', state));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QueryDetailsState &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.stale, stale) || other.stale == stale) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, stale, state);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryDetailsState(key: $key, type: $type, stale: $stale, state: $state)';
  }
}

/// @nodoc
abstract mixin class _$QueryDetailsStateCopyWith<$Res>
    implements $QueryDetailsStateCopyWith<$Res> {
  factory _$QueryDetailsStateCopyWith(
          _QueryDetailsState value, $Res Function(_QueryDetailsState) _then) =
      __$QueryDetailsStateCopyWithImpl;
  @override
  @useResult
  $Res call({String key, String type, bool? stale, QueryStateDetails state});

  @override
  $QueryStateDetailsCopyWith<$Res> get state;
}

/// @nodoc
class __$QueryDetailsStateCopyWithImpl<$Res>
    implements _$QueryDetailsStateCopyWith<$Res> {
  __$QueryDetailsStateCopyWithImpl(this._self, this._then);

  final _QueryDetailsState _self;
  final $Res Function(_QueryDetailsState) _then;

  /// Create a copy of QueryDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? stale = freezed,
    Object? state = null,
  }) {
    return _then(_QueryDetailsState(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      stale: freezed == stale
          ? _self.stale
          : stale // ignore: cast_nullable_to_non_nullable
              as bool?,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as QueryStateDetails,
    ));
  }

  /// Create a copy of QueryDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueryStateDetailsCopyWith<$Res> get state {
    return $QueryStateDetailsCopyWith<$Res>(_self.state, (value) {
      return _then(_self.copyWith(state: value));
    });
  }
}

// dart format on

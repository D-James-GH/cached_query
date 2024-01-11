// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$QueryStateDetailsJson {
  String get dataRuntimeType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryStateDetailsJsonCopyWith<QueryStateDetailsJson> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryStateDetailsJsonCopyWith<$Res> {
  factory $QueryStateDetailsJsonCopyWith(QueryStateDetailsJson value,
          $Res Function(QueryStateDetailsJson) then) =
      _$QueryStateDetailsJsonCopyWithImpl<$Res, QueryStateDetailsJson>;
  @useResult
  $Res call(
      {String dataRuntimeType, String status, Map<String, dynamic>? data});
}

/// @nodoc
class _$QueryStateDetailsJsonCopyWithImpl<$Res,
        $Val extends QueryStateDetailsJson>
    implements $QueryStateDetailsJsonCopyWith<$Res> {
  _$QueryStateDetailsJsonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      dataRuntimeType: null == dataRuntimeType
          ? _value.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryStateDetailsJsonImplCopyWith<$Res>
    implements $QueryStateDetailsJsonCopyWith<$Res> {
  factory _$$QueryStateDetailsJsonImplCopyWith(
          _$QueryStateDetailsJsonImpl value,
          $Res Function(_$QueryStateDetailsJsonImpl) then) =
      __$$QueryStateDetailsJsonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dataRuntimeType, String status, Map<String, dynamic>? data});
}

/// @nodoc
class __$$QueryStateDetailsJsonImplCopyWithImpl<$Res>
    extends _$QueryStateDetailsJsonCopyWithImpl<$Res,
        _$QueryStateDetailsJsonImpl>
    implements _$$QueryStateDetailsJsonImplCopyWith<$Res> {
  __$$QueryStateDetailsJsonImplCopyWithImpl(_$QueryStateDetailsJsonImpl _value,
      $Res Function(_$QueryStateDetailsJsonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
    Object? data = freezed,
  }) {
    return _then(_$QueryStateDetailsJsonImpl(
      dataRuntimeType: null == dataRuntimeType
          ? _value.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$QueryStateDetailsJsonImpl
    with DiagnosticableTreeMixin
    implements _QueryStateDetailsJson {
  const _$QueryStateDetailsJsonImpl(
      {required this.dataRuntimeType,
      required this.status,
      final Map<String, dynamic>? data})
      : _data = data;

  @override
  final String dataRuntimeType;
  @override
  final String status;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryStateDetailsJson(dataRuntimeType: $dataRuntimeType, status: $status, data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueryStateDetailsJson'))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryStateDetailsJsonImpl &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dataRuntimeType, status,
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryStateDetailsJsonImplCopyWith<_$QueryStateDetailsJsonImpl>
      get copyWith => __$$QueryStateDetailsJsonImplCopyWithImpl<
          _$QueryStateDetailsJsonImpl>(this, _$identity);
}

abstract class _QueryStateDetailsJson implements QueryStateDetailsJson {
  const factory _QueryStateDetailsJson(
      {required final String dataRuntimeType,
      required final String status,
      final Map<String, dynamic>? data}) = _$QueryStateDetailsJsonImpl;

  @override
  String get dataRuntimeType;
  @override
  String get status;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$$QueryStateDetailsJsonImplCopyWith<_$QueryStateDetailsJsonImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QueryStateDetailsString {
  String get dataRuntimeType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryStateDetailsStringCopyWith<QueryStateDetailsString> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryStateDetailsStringCopyWith<$Res> {
  factory $QueryStateDetailsStringCopyWith(QueryStateDetailsString value,
          $Res Function(QueryStateDetailsString) then) =
      _$QueryStateDetailsStringCopyWithImpl<$Res, QueryStateDetailsString>;
  @useResult
  $Res call({String dataRuntimeType, String status, String? data});
}

/// @nodoc
class _$QueryStateDetailsStringCopyWithImpl<$Res,
        $Val extends QueryStateDetailsString>
    implements $QueryStateDetailsStringCopyWith<$Res> {
  _$QueryStateDetailsStringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      dataRuntimeType: null == dataRuntimeType
          ? _value.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryStateDetailsStringImplCopyWith<$Res>
    implements $QueryStateDetailsStringCopyWith<$Res> {
  factory _$$QueryStateDetailsStringImplCopyWith(
          _$QueryStateDetailsStringImpl value,
          $Res Function(_$QueryStateDetailsStringImpl) then) =
      __$$QueryStateDetailsStringImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String dataRuntimeType, String status, String? data});
}

/// @nodoc
class __$$QueryStateDetailsStringImplCopyWithImpl<$Res>
    extends _$QueryStateDetailsStringCopyWithImpl<$Res,
        _$QueryStateDetailsStringImpl>
    implements _$$QueryStateDetailsStringImplCopyWith<$Res> {
  __$$QueryStateDetailsStringImplCopyWithImpl(
      _$QueryStateDetailsStringImpl _value,
      $Res Function(_$QueryStateDetailsStringImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataRuntimeType = null,
    Object? status = null,
    Object? data = freezed,
  }) {
    return _then(_$QueryStateDetailsStringImpl(
      dataRuntimeType: null == dataRuntimeType
          ? _value.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$QueryStateDetailsStringImpl
    with DiagnosticableTreeMixin
    implements _QueryStateDetailsString {
  const _$QueryStateDetailsStringImpl(
      {required this.dataRuntimeType, required this.status, this.data});

  @override
  final String dataRuntimeType;
  @override
  final String status;
  @override
  final String? data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryStateDetailsString(dataRuntimeType: $dataRuntimeType, status: $status, data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueryStateDetailsString'))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryStateDetailsStringImpl &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dataRuntimeType, status, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryStateDetailsStringImplCopyWith<_$QueryStateDetailsStringImpl>
      get copyWith => __$$QueryStateDetailsStringImplCopyWithImpl<
          _$QueryStateDetailsStringImpl>(this, _$identity);
}

abstract class _QueryStateDetailsString implements QueryStateDetailsString {
  const factory _QueryStateDetailsString(
      {required final String dataRuntimeType,
      required final String status,
      final String? data}) = _$QueryStateDetailsStringImpl;

  @override
  String get dataRuntimeType;
  @override
  String get status;
  @override
  String? get data;
  @override
  @JsonKey(ignore: true)
  _$$QueryStateDetailsStringImplCopyWith<_$QueryStateDetailsStringImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InfiniteQueryDetailsJson {
  String get status => throw _privateConstructorUsedError;
  String get dataRuntimeType => throw _privateConstructorUsedError;
  List<dynamic>? get pages => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InfiniteQueryDetailsJsonCopyWith<InfiniteQueryDetailsJson> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfiniteQueryDetailsJsonCopyWith<$Res> {
  factory $InfiniteQueryDetailsJsonCopyWith(InfiniteQueryDetailsJson value,
          $Res Function(InfiniteQueryDetailsJson) then) =
      _$InfiniteQueryDetailsJsonCopyWithImpl<$Res, InfiniteQueryDetailsJson>;
  @useResult
  $Res call({String status, String dataRuntimeType, List<dynamic>? pages});
}

/// @nodoc
class _$InfiniteQueryDetailsJsonCopyWithImpl<$Res,
        $Val extends InfiniteQueryDetailsJson>
    implements $InfiniteQueryDetailsJsonCopyWith<$Res> {
  _$InfiniteQueryDetailsJsonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? dataRuntimeType = null,
    Object? pages = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dataRuntimeType: null == dataRuntimeType
          ? _value.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      pages: freezed == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InfiniteQueryDetailsJsonImplCopyWith<$Res>
    implements $InfiniteQueryDetailsJsonCopyWith<$Res> {
  factory _$$InfiniteQueryDetailsJsonImplCopyWith(
          _$InfiniteQueryDetailsJsonImpl value,
          $Res Function(_$InfiniteQueryDetailsJsonImpl) then) =
      __$$InfiniteQueryDetailsJsonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String dataRuntimeType, List<dynamic>? pages});
}

/// @nodoc
class __$$InfiniteQueryDetailsJsonImplCopyWithImpl<$Res>
    extends _$InfiniteQueryDetailsJsonCopyWithImpl<$Res,
        _$InfiniteQueryDetailsJsonImpl>
    implements _$$InfiniteQueryDetailsJsonImplCopyWith<$Res> {
  __$$InfiniteQueryDetailsJsonImplCopyWithImpl(
      _$InfiniteQueryDetailsJsonImpl _value,
      $Res Function(_$InfiniteQueryDetailsJsonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? dataRuntimeType = null,
    Object? pages = freezed,
  }) {
    return _then(_$InfiniteQueryDetailsJsonImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dataRuntimeType: null == dataRuntimeType
          ? _value.dataRuntimeType
          : dataRuntimeType // ignore: cast_nullable_to_non_nullable
              as String,
      pages: freezed == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ));
  }
}

/// @nodoc

class _$InfiniteQueryDetailsJsonImpl
    with DiagnosticableTreeMixin
    implements _InfiniteQueryDetailsJson {
  const _$InfiniteQueryDetailsJsonImpl(
      {required this.status,
      required this.dataRuntimeType,
      final List<dynamic>? pages})
      : _pages = pages;

  @override
  final String status;
  @override
  final String dataRuntimeType;
  final List<dynamic>? _pages;
  @override
  List<dynamic>? get pages {
    final value = _pages;
    if (value == null) return null;
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InfiniteQueryDetailsJson(status: $status, dataRuntimeType: $dataRuntimeType, pages: $pages)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InfiniteQueryDetailsJson'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('dataRuntimeType', dataRuntimeType))
      ..add(DiagnosticsProperty('pages', pages));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfiniteQueryDetailsJsonImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataRuntimeType, dataRuntimeType) ||
                other.dataRuntimeType == dataRuntimeType) &&
            const DeepCollectionEquality().equals(other._pages, _pages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, dataRuntimeType,
      const DeepCollectionEquality().hash(_pages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InfiniteQueryDetailsJsonImplCopyWith<_$InfiniteQueryDetailsJsonImpl>
      get copyWith => __$$InfiniteQueryDetailsJsonImplCopyWithImpl<
          _$InfiniteQueryDetailsJsonImpl>(this, _$identity);
}

abstract class _InfiniteQueryDetailsJson implements InfiniteQueryDetailsJson {
  const factory _InfiniteQueryDetailsJson(
      {required final String status,
      required final String dataRuntimeType,
      final List<dynamic>? pages}) = _$InfiniteQueryDetailsJsonImpl;

  @override
  String get status;
  @override
  String get dataRuntimeType;
  @override
  List<dynamic>? get pages;
  @override
  @JsonKey(ignore: true)
  _$$InfiniteQueryDetailsJsonImplCopyWith<_$InfiniteQueryDetailsJsonImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QueryDetailsState {
  String get key => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool? get stale => throw _privateConstructorUsedError;
  QueryStateDetails get state => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryDetailsStateCopyWith<QueryDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryDetailsStateCopyWith<$Res> {
  factory $QueryDetailsStateCopyWith(
          QueryDetailsState value, $Res Function(QueryDetailsState) then) =
      _$QueryDetailsStateCopyWithImpl<$Res, QueryDetailsState>;
  @useResult
  $Res call({String key, String type, bool? stale, QueryStateDetails state});
}

/// @nodoc
class _$QueryDetailsStateCopyWithImpl<$Res, $Val extends QueryDetailsState>
    implements $QueryDetailsStateCopyWith<$Res> {
  _$QueryDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? stale = freezed,
    Object? state = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      stale: freezed == stale
          ? _value.stale
          : stale // ignore: cast_nullable_to_non_nullable
              as bool?,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as QueryStateDetails,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryDetailsStateImplCopyWith<$Res>
    implements $QueryDetailsStateCopyWith<$Res> {
  factory _$$QueryDetailsStateImplCopyWith(_$QueryDetailsStateImpl value,
          $Res Function(_$QueryDetailsStateImpl) then) =
      __$$QueryDetailsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String type, bool? stale, QueryStateDetails state});
}

/// @nodoc
class __$$QueryDetailsStateImplCopyWithImpl<$Res>
    extends _$QueryDetailsStateCopyWithImpl<$Res, _$QueryDetailsStateImpl>
    implements _$$QueryDetailsStateImplCopyWith<$Res> {
  __$$QueryDetailsStateImplCopyWithImpl(_$QueryDetailsStateImpl _value,
      $Res Function(_$QueryDetailsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? stale = freezed,
    Object? state = null,
  }) {
    return _then(_$QueryDetailsStateImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      stale: freezed == stale
          ? _value.stale
          : stale // ignore: cast_nullable_to_non_nullable
              as bool?,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as QueryStateDetails,
    ));
  }
}

/// @nodoc

class _$QueryDetailsStateImpl
    with DiagnosticableTreeMixin
    implements _QueryDetailsState {
  const _$QueryDetailsStateImpl(
      {required this.key, required this.type, this.stale, required this.state});

  @override
  final String key;
  @override
  final String type;
  @override
  final bool? stale;
  @override
  final QueryStateDetails state;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueryDetailsState(key: $key, type: $type, stale: $stale, state: $state)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
            other is _$QueryDetailsStateImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.stale, stale) || other.stale == stale) &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, stale, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryDetailsStateImplCopyWith<_$QueryDetailsStateImpl> get copyWith =>
      __$$QueryDetailsStateImplCopyWithImpl<_$QueryDetailsStateImpl>(
          this, _$identity);
}

abstract class _QueryDetailsState implements QueryDetailsState {
  const factory _QueryDetailsState(
      {required final String key,
      required final String type,
      final bool? stale,
      required final QueryStateDetails state}) = _$QueryDetailsStateImpl;

  @override
  String get key;
  @override
  String get type;
  @override
  bool? get stale;
  @override
  QueryStateDetails get state;
  @override
  @JsonKey(ignore: true)
  _$$QueryDetailsStateImplCopyWith<_$QueryDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QueryInstance {
  String get key => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  InstanceRef get valueRef => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryInstanceCopyWith<QueryInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryInstanceCopyWith<$Res> {
  factory $QueryInstanceCopyWith(
          QueryInstance value, $Res Function(QueryInstance) then) =
      _$QueryInstanceCopyWithImpl<$Res, QueryInstance>;
  @useResult
  $Res call({String key, String type, InstanceRef valueRef});
}

/// @nodoc
class _$QueryInstanceCopyWithImpl<$Res, $Val extends QueryInstance>
    implements $QueryInstanceCopyWith<$Res> {
  _$QueryInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? valueRef = null,
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
      valueRef: null == valueRef
          ? _value.valueRef
          : valueRef // ignore: cast_nullable_to_non_nullable
              as InstanceRef,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryItemImplCopyWith<$Res>
    implements $QueryInstanceCopyWith<$Res> {
  factory _$$QueryItemImplCopyWith(
          _$QueryItemImpl value, $Res Function(_$QueryItemImpl) then) =
      __$$QueryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String type, InstanceRef valueRef});
}

/// @nodoc
class __$$QueryItemImplCopyWithImpl<$Res>
    extends _$QueryInstanceCopyWithImpl<$Res, _$QueryItemImpl>
    implements _$$QueryItemImplCopyWith<$Res> {
  __$$QueryItemImplCopyWithImpl(
      _$QueryItemImpl _value, $Res Function(_$QueryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? valueRef = null,
  }) {
    return _then(_$QueryItemImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      valueRef: null == valueRef
          ? _value.valueRef
          : valueRef // ignore: cast_nullable_to_non_nullable
              as InstanceRef,
    ));
  }
}

/// @nodoc

class _$QueryItemImpl implements _QueryItem {
  const _$QueryItemImpl(
      {required this.key, required this.type, required this.valueRef});

  @override
  final String key;
  @override
  final String type;
  @override
  final InstanceRef valueRef;

  @override
  String toString() {
    return 'QueryInstance(key: $key, type: $type, valueRef: $valueRef)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryItemImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.valueRef, valueRef) ||
                other.valueRef == valueRef));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, valueRef);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryItemImplCopyWith<_$QueryItemImpl> get copyWith =>
      __$$QueryItemImplCopyWithImpl<_$QueryItemImpl>(this, _$identity);
}

abstract class _QueryItem implements QueryInstance {
  const factory _QueryItem(
      {required final String key,
      required final String type,
      required final InstanceRef valueRef}) = _$QueryItemImpl;

  @override
  String get key;
  @override
  String get type;
  @override
  InstanceRef get valueRef;
  @override
  @JsonKey(ignore: true)
  _$$QueryItemImplCopyWith<_$QueryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QueryListState {
  String? get selectedKey => throw _privateConstructorUsedError;
  List<QueryInstance> get queries => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryListStateCopyWith<QueryListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryListStateCopyWith<$Res> {
  factory $QueryListStateCopyWith(
          QueryListState value, $Res Function(QueryListState) then) =
      _$QueryListStateCopyWithImpl<$Res, QueryListState>;
  @useResult
  $Res call({String? selectedKey, List<QueryInstance> queries});
}

/// @nodoc
class _$QueryListStateCopyWithImpl<$Res, $Val extends QueryListState>
    implements $QueryListStateCopyWith<$Res> {
  _$QueryListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedKey = freezed,
    Object? queries = null,
  }) {
    return _then(_value.copyWith(
      selectedKey: freezed == selectedKey
          ? _value.selectedKey
          : selectedKey // ignore: cast_nullable_to_non_nullable
              as String?,
      queries: null == queries
          ? _value.queries
          : queries // ignore: cast_nullable_to_non_nullable
              as List<QueryInstance>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryStateImplCopyWith<$Res>
    implements $QueryListStateCopyWith<$Res> {
  factory _$$QueryStateImplCopyWith(
          _$QueryStateImpl value, $Res Function(_$QueryStateImpl) then) =
      __$$QueryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? selectedKey, List<QueryInstance> queries});
}

/// @nodoc
class __$$QueryStateImplCopyWithImpl<$Res>
    extends _$QueryListStateCopyWithImpl<$Res, _$QueryStateImpl>
    implements _$$QueryStateImplCopyWith<$Res> {
  __$$QueryStateImplCopyWithImpl(
      _$QueryStateImpl _value, $Res Function(_$QueryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedKey = freezed,
    Object? queries = null,
  }) {
    return _then(_$QueryStateImpl(
      selectedKey: freezed == selectedKey
          ? _value.selectedKey
          : selectedKey // ignore: cast_nullable_to_non_nullable
              as String?,
      queries: null == queries
          ? _value._queries
          : queries // ignore: cast_nullable_to_non_nullable
              as List<QueryInstance>,
    ));
  }
}

/// @nodoc

class _$QueryStateImpl implements _QueryState {
  const _$QueryStateImpl(
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

  @override
  String toString() {
    return 'QueryListState(selectedKey: $selectedKey, queries: $queries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryStateImpl &&
            (identical(other.selectedKey, selectedKey) ||
                other.selectedKey == selectedKey) &&
            const DeepCollectionEquality().equals(other._queries, _queries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, selectedKey, const DeepCollectionEquality().hash(_queries));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryStateImplCopyWith<_$QueryStateImpl> get copyWith =>
      __$$QueryStateImplCopyWithImpl<_$QueryStateImpl>(this, _$identity);
}

abstract class _QueryState implements QueryListState {
  const factory _QueryState(
      {final String? selectedKey,
      required final List<QueryInstance> queries}) = _$QueryStateImpl;

  @override
  String? get selectedKey;
  @override
  List<QueryInstance> get queries;
  @override
  @JsonKey(ignore: true)
  _$$QueryStateImplCopyWith<_$QueryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppEvent {
  String get name => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  EventType get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppEventCopyWith<AppEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppEventCopyWith<$Res> {
  factory $AppEventCopyWith(AppEvent value, $Res Function(AppEvent) then) =
      _$AppEventCopyWithImpl<$Res, AppEvent>;
  @useResult
  $Res call({String name, Map<String, dynamic> data, EventType type});
}

/// @nodoc
class _$AppEventCopyWithImpl<$Res, $Val extends AppEvent>
    implements $AppEventCopyWith<$Res> {
  _$AppEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppEventImplCopyWith<$Res>
    implements $AppEventCopyWith<$Res> {
  factory _$$AppEventImplCopyWith(
          _$AppEventImpl value, $Res Function(_$AppEventImpl) then) =
      __$$AppEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, Map<String, dynamic> data, EventType type});
}

/// @nodoc
class __$$AppEventImplCopyWithImpl<$Res>
    extends _$AppEventCopyWithImpl<$Res, _$AppEventImpl>
    implements _$$AppEventImplCopyWith<$Res> {
  __$$AppEventImplCopyWithImpl(
      _$AppEventImpl _value, $Res Function(_$AppEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? type = null,
  }) {
    return _then(_$AppEventImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
    ));
  }
}

/// @nodoc

class _$AppEventImpl implements _AppEvent {
  const _$AppEventImpl(
      {required this.name,
      required final Map<String, dynamic> data,
      required this.type})
      : _data = data;

  @override
  final String name;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final EventType type;

  @override
  String toString() {
    return 'AppEvent(name: $name, data: $data, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppEventImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_data), type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppEventImplCopyWith<_$AppEventImpl> get copyWith =>
      __$$AppEventImplCopyWithImpl<_$AppEventImpl>(this, _$identity);
}

abstract class _AppEvent implements AppEvent {
  const factory _AppEvent(
      {required final String name,
      required final Map<String, dynamic> data,
      required final EventType type}) = _$AppEventImpl;

  @override
  String get name;
  @override
  Map<String, dynamic> get data;
  @override
  EventType get type;
  @override
  @JsonKey(ignore: true)
  _$$AppEventImplCopyWith<_$AppEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

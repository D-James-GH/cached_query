// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'joke_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$JokeStateTearOff {
  const _$JokeStateTearOff();

  _JokeState call({JokeStatus status = JokeStatus.initial, JokeModel? joke}) {
    return _JokeState(
      status: status,
      joke: joke,
    );
  }
}

/// @nodoc
const $JokeState = _$JokeStateTearOff();

/// @nodoc
mixin _$JokeState {
  JokeStatus get status => throw _privateConstructorUsedError;
  JokeModel? get joke => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JokeStateCopyWith<JokeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JokeStateCopyWith<$Res> {
  factory $JokeStateCopyWith(JokeState value, $Res Function(JokeState) then) =
      _$JokeStateCopyWithImpl<$Res>;
  $Res call({JokeStatus status, JokeModel? joke});

  $JokeModelCopyWith<$Res>? get joke;
}

/// @nodoc
class _$JokeStateCopyWithImpl<$Res> implements $JokeStateCopyWith<$Res> {
  _$JokeStateCopyWithImpl(this._value, this._then);

  final JokeState _value;
  // ignore: unused_field
  final $Res Function(JokeState) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? joke = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JokeStatus,
      joke: joke == freezed
          ? _value.joke
          : joke // ignore: cast_nullable_to_non_nullable
              as JokeModel?,
    ));
  }

  @override
  $JokeModelCopyWith<$Res>? get joke {
    if (_value.joke == null) {
      return null;
    }

    return $JokeModelCopyWith<$Res>(_value.joke!, (value) {
      return _then(_value.copyWith(joke: value));
    });
  }
}

/// @nodoc
abstract class _$JokeStateCopyWith<$Res> implements $JokeStateCopyWith<$Res> {
  factory _$JokeStateCopyWith(
          _JokeState value, $Res Function(_JokeState) then) =
      __$JokeStateCopyWithImpl<$Res>;
  @override
  $Res call({JokeStatus status, JokeModel? joke});

  @override
  $JokeModelCopyWith<$Res>? get joke;
}

/// @nodoc
class __$JokeStateCopyWithImpl<$Res> extends _$JokeStateCopyWithImpl<$Res>
    implements _$JokeStateCopyWith<$Res> {
  __$JokeStateCopyWithImpl(_JokeState _value, $Res Function(_JokeState) _then)
      : super(_value, (v) => _then(v as _JokeState));

  @override
  _JokeState get _value => super._value as _JokeState;

  @override
  $Res call({
    Object? status = freezed,
    Object? joke = freezed,
  }) {
    return _then(_JokeState(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JokeStatus,
      joke: joke == freezed
          ? _value.joke
          : joke // ignore: cast_nullable_to_non_nullable
              as JokeModel?,
    ));
  }
}

/// @nodoc

class _$_JokeState implements _JokeState {
  const _$_JokeState({this.status = JokeStatus.initial, this.joke});

  @JsonKey(defaultValue: JokeStatus.initial)
  @override
  final JokeStatus status;
  @override
  final JokeModel? joke;

  @override
  String toString() {
    return 'JokeState(status: $status, joke: $joke)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _JokeState &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.joke, joke) ||
                const DeepCollectionEquality().equals(other.joke, joke)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(joke);

  @JsonKey(ignore: true)
  @override
  _$JokeStateCopyWith<_JokeState> get copyWith =>
      __$JokeStateCopyWithImpl<_JokeState>(this, _$identity);
}

abstract class _JokeState implements JokeState {
  const factory _JokeState({JokeStatus status, JokeModel? joke}) = _$_JokeState;

  @override
  JokeStatus get status => throw _privateConstructorUsedError;
  @override
  JokeModel? get joke => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$JokeStateCopyWith<_JokeState> get copyWith =>
      throw _privateConstructorUsedError;
}

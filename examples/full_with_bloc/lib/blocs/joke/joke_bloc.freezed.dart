// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$JokeStateCopyWithImpl<$Res, JokeState>;
  @useResult
  $Res call({JokeStatus status, JokeModel? joke});

  $JokeModelCopyWith<$Res>? get joke;
}

/// @nodoc
class _$JokeStateCopyWithImpl<$Res, $Val extends JokeState>
    implements $JokeStateCopyWith<$Res> {
  _$JokeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? joke = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JokeStatus,
      joke: freezed == joke
          ? _value.joke
          : joke // ignore: cast_nullable_to_non_nullable
              as JokeModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $JokeModelCopyWith<$Res>? get joke {
    if (_value.joke == null) {
      return null;
    }

    return $JokeModelCopyWith<$Res>(_value.joke!, (value) {
      return _then(_value.copyWith(joke: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_JokeStateCopyWith<$Res> implements $JokeStateCopyWith<$Res> {
  factory _$$_JokeStateCopyWith(
          _$_JokeState value, $Res Function(_$_JokeState) then) =
      __$$_JokeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({JokeStatus status, JokeModel? joke});

  @override
  $JokeModelCopyWith<$Res>? get joke;
}

/// @nodoc
class __$$_JokeStateCopyWithImpl<$Res>
    extends _$JokeStateCopyWithImpl<$Res, _$_JokeState>
    implements _$$_JokeStateCopyWith<$Res> {
  __$$_JokeStateCopyWithImpl(
      _$_JokeState _value, $Res Function(_$_JokeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? joke = freezed,
  }) {
    return _then(_$_JokeState(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JokeStatus,
      joke: freezed == joke
          ? _value.joke
          : joke // ignore: cast_nullable_to_non_nullable
              as JokeModel?,
    ));
  }
}

/// @nodoc

class _$_JokeState implements _JokeState {
  const _$_JokeState({this.status = JokeStatus.initial, this.joke});

  @override
  @JsonKey()
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
        (other.runtimeType == runtimeType &&
            other is _$_JokeState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joke, joke) || other.joke == joke));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, joke);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JokeStateCopyWith<_$_JokeState> get copyWith =>
      __$$_JokeStateCopyWithImpl<_$_JokeState>(this, _$identity);
}

abstract class _JokeState implements JokeState {
  const factory _JokeState({final JokeStatus status, final JokeModel? joke}) =
      _$_JokeState;

  @override
  JokeStatus get status;
  @override
  JokeModel? get joke;
  @override
  @JsonKey(ignore: true)
  _$$_JokeStateCopyWith<_$_JokeState> get copyWith =>
      throw _privateConstructorUsedError;
}

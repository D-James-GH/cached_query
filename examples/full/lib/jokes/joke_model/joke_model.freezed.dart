// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JokeModel _$JokeModelFromJson(Map<String, dynamic> json) {
  return _JokeModel.fromJson(json);
}

/// @nodoc
mixin _$JokeModel {
  String get joke => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JokeModelCopyWith<JokeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JokeModelCopyWith<$Res> {
  factory $JokeModelCopyWith(JokeModel value, $Res Function(JokeModel) then) =
      _$JokeModelCopyWithImpl<$Res, JokeModel>;
  @useResult
  $Res call({String joke, String id});
}

/// @nodoc
class _$JokeModelCopyWithImpl<$Res, $Val extends JokeModel>
    implements $JokeModelCopyWith<$Res> {
  _$JokeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joke = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      joke: null == joke
          ? _value.joke
          : joke // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JokeModelImplCopyWith<$Res>
    implements $JokeModelCopyWith<$Res> {
  factory _$$JokeModelImplCopyWith(
          _$JokeModelImpl value, $Res Function(_$JokeModelImpl) then) =
      __$$JokeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String joke, String id});
}

/// @nodoc
class __$$JokeModelImplCopyWithImpl<$Res>
    extends _$JokeModelCopyWithImpl<$Res, _$JokeModelImpl>
    implements _$$JokeModelImplCopyWith<$Res> {
  __$$JokeModelImplCopyWithImpl(
      _$JokeModelImpl _value, $Res Function(_$JokeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joke = null,
    Object? id = null,
  }) {
    return _then(_$JokeModelImpl(
      joke: null == joke
          ? _value.joke
          : joke // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JokeModelImpl implements _JokeModel {
  const _$JokeModelImpl({required this.joke, required this.id});

  factory _$JokeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JokeModelImplFromJson(json);

  @override
  final String joke;
  @override
  final String id;

  @override
  String toString() {
    return 'JokeModel(joke: $joke, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JokeModelImpl &&
            (identical(other.joke, joke) || other.joke == joke) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, joke, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JokeModelImplCopyWith<_$JokeModelImpl> get copyWith =>
      __$$JokeModelImplCopyWithImpl<_$JokeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JokeModelImplToJson(
      this,
    );
  }
}

abstract class _JokeModel implements JokeModel {
  const factory _JokeModel(
      {required final String joke, required final String id}) = _$JokeModelImpl;

  factory _JokeModel.fromJson(Map<String, dynamic> json) =
      _$JokeModelImpl.fromJson;

  @override
  String get joke;
  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$JokeModelImplCopyWith<_$JokeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

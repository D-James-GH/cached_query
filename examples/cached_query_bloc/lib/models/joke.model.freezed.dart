// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'joke.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JokeModel _$JokeModelFromJson(Map<String, dynamic> json) {
  return _JokeModel.fromJson(json);
}

/// @nodoc
class _$JokeModelTearOff {
  const _$JokeModelTearOff();

  _JokeModel call({required String text, required String id}) {
    return _JokeModel(
      text: text,
      id: id,
    );
  }

  JokeModel fromJson(Map<String, Object> json) {
    return JokeModel.fromJson(json);
  }
}

/// @nodoc
const $JokeModel = _$JokeModelTearOff();

/// @nodoc
mixin _$JokeModel {
  String get text => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JokeModelCopyWith<JokeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JokeModelCopyWith<$Res> {
  factory $JokeModelCopyWith(JokeModel value, $Res Function(JokeModel) then) =
      _$JokeModelCopyWithImpl<$Res>;
  $Res call({String text, String id});
}

/// @nodoc
class _$JokeModelCopyWithImpl<$Res> implements $JokeModelCopyWith<$Res> {
  _$JokeModelCopyWithImpl(this._value, this._then);

  final JokeModel _value;
  // ignore: unused_field
  final $Res Function(JokeModel) _then;

  @override
  $Res call({
    Object? text = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$JokeModelCopyWith<$Res> implements $JokeModelCopyWith<$Res> {
  factory _$JokeModelCopyWith(
          _JokeModel value, $Res Function(_JokeModel) then) =
      __$JokeModelCopyWithImpl<$Res>;
  @override
  $Res call({String text, String id});
}

/// @nodoc
class __$JokeModelCopyWithImpl<$Res> extends _$JokeModelCopyWithImpl<$Res>
    implements _$JokeModelCopyWith<$Res> {
  __$JokeModelCopyWithImpl(_JokeModel _value, $Res Function(_JokeModel) _then)
      : super(_value, (v) => _then(v as _JokeModel));

  @override
  _JokeModel get _value => super._value as _JokeModel;

  @override
  $Res call({
    Object? text = freezed,
    Object? id = freezed,
  }) {
    return _then(_JokeModel(
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_JokeModel implements _JokeModel {
  const _$_JokeModel({required this.text, required this.id});

  factory _$_JokeModel.fromJson(Map<String, dynamic> json) =>
      _$$_JokeModelFromJson(json);

  @override
  final String text;
  @override
  final String id;

  @override
  String toString() {
    return 'JokeModel(text: $text, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _JokeModel &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(id);

  @JsonKey(ignore: true)
  @override
  _$JokeModelCopyWith<_JokeModel> get copyWith =>
      __$JokeModelCopyWithImpl<_JokeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JokeModelToJson(this);
  }
}

abstract class _JokeModel implements JokeModel {
  const factory _JokeModel({required String text, required String id}) =
      _$_JokeModel;

  factory _JokeModel.fromJson(Map<String, dynamic> json) =
      _$_JokeModel.fromJson;

  @override
  String get text => throw _privateConstructorUsedError;
  @override
  String get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$JokeModelCopyWith<_JokeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

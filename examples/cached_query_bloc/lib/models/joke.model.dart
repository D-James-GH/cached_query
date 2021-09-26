import 'package:freezed_annotation/freezed_annotation.dart';

part 'joke.model.freezed.dart';

@freezed
class JokeModel with _$JokeModel {
  const factory JokeModel({
    required String text,
    required String id,
  }) = _JokeModel;

  factory JokeModel.fromJson(Map<String, dynamic> json) =>
      _$JokeModelFromJson(json);
}

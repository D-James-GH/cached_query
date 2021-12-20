import 'package:freezed_annotation/freezed_annotation.dart';

part 'joke_model.freezed.dart';
part 'joke_model.g.dart';

@freezed
class JokeModel with _$JokeModel {
  const factory JokeModel({
    required String joke,
    required String id,
  }) = _JokeModel;

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return _$JokeModelFromJson(json);
  }
}

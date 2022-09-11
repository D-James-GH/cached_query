import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  static List<PostModel> listFromJson(List<dynamic> json) => json
      .map(
        (dynamic postJson) =>
            PostModel.fromJson(postJson as Map<String, dynamic>),
      )
      .toList();
}

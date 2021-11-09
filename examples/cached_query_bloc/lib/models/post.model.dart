import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.model.freezed.dart';
part 'post.model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return _$PostModelFromJson(json);
  }

  static List<PostModel> listFromJson(List<dynamic> json) =>
      json.map((e) => PostModel.fromJson(e)).toList();
}

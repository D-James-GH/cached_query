import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.model.freezed.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required String title,
    required String body,
    int? userId,
  }) = _PostModel;
}

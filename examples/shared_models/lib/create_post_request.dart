import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_request.freezed.dart';
part 'create_post_request.g.dart';

/// Request body for creating a post.
@freezed
abstract class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String title,
    required String body,
    required int userId,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}

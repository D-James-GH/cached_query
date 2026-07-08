import 'package:freezed_annotation/freezed_annotation.dart';

import 'post.dart';

part 'posts_response.freezed.dart';
part 'posts_response.g.dart';

/// Paginated posts list response.
@freezed
abstract class PostsResponse with _$PostsResponse {
  const factory PostsResponse({
    required List<Post> posts,
    required int total,
    required int skip,
    required int limit,
  }) = _PostsResponse;

  factory PostsResponse.fromJson(Map<String, dynamic> json) =>
      _$PostsResponseFromJson(json);
}

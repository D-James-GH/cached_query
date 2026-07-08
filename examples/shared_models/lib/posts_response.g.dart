// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostsResponse _$PostsResponseFromJson(Map<String, dynamic> json) =>
    _PostsResponse(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PostsResponseToJson(_PostsResponse instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

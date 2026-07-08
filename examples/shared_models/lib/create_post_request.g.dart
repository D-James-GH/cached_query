// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    _CreatePostRequest(
      title: json['title'] as String,
      body: json['body'] as String,
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$CreatePostRequestToJson(_CreatePostRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
    };

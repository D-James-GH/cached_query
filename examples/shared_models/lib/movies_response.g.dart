// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoviesResponse _$MoviesResponseFromJson(Map<String, dynamic> json) =>
    _MoviesResponse(
      movies: (json['movies'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$MoviesResponseToJson(_MoviesResponse instance) =>
    <String, dynamic>{
      'movies': instance.movies,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

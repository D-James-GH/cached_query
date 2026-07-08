// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Movie _$MovieFromJson(Map<String, dynamic> json) => _Movie(
      imdbId: json['imdbId'] as String,
      title: json['title'] as String,
      plot: json['plot'] as String,
      year: json['year'] as String,
      poster: json['poster'] as String,
    );

Map<String, dynamic> _$MovieToJson(_Movie instance) => <String, dynamic>{
      'imdbId': instance.imdbId,
      'title': instance.title,
      'plot': instance.plot,
      'year': instance.year,
      'poster': instance.poster,
    };

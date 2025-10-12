// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sns_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnsContentImpl _$$SnsContentImplFromJson(Map<String, dynamic> json) =>
    _$SnsContentImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      source: $enumDecode(_$SnsSourceEnumMap, json['source']),
      contentUrl: json['contentUrl'] as String,
      creatorName: json['creatorName'] as String,
      viewCount: (json['viewCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$SnsContentImplToJson(_$SnsContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnailUrl': instance.thumbnailUrl,
      'source': _$SnsSourceEnumMap[instance.source]!,
      'contentUrl': instance.contentUrl,
      'creatorName': instance.creatorName,
      'viewCount': instance.viewCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': _$ContentTypeEnumMap[instance.type]!,
    };

const _$SnsSourceEnumMap = {
  SnsSource.youtube: 'youtube',
  SnsSource.instagram: 'instagram',
  SnsSource.tiktok: 'tiktok',
};

const _$ContentTypeEnumMap = {
  ContentType.video: 'video',
  ContentType.image: 'image',
  ContentType.reels: 'reels',
  ContentType.shorts: 'shorts',
};

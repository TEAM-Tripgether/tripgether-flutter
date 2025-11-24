// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentModelImpl _$$ContentModelImplFromJson(Map<String, dynamic> json) =>
    _$ContentModelImpl(
      contentId: json['contentId'] as String,
      platform: json['platform'] as String? ?? 'UNKNOWN',
      status: json['status'] as String? ?? 'PENDING',
      platformUploader: json['platformUploader'] as String?,
      caption: json['caption'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      originalUrl: json['originalUrl'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      lastCheckedAt: json['lastCheckedAt'] == null
          ? null
          : DateTime.parse(json['lastCheckedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String? ?? 'system',
      updatedBy: json['updatedBy'] as String? ?? 'system',
      places:
          (json['places'] as List<dynamic>?)
              ?.map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ContentModelImplToJson(_$ContentModelImpl instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'platform': instance.platform,
      'status': instance.status,
      'platformUploader': instance.platformUploader,
      'caption': instance.caption,
      'thumbnailUrl': instance.thumbnailUrl,
      'originalUrl': instance.originalUrl,
      'title': instance.title,
      'summary': instance.summary,
      'lastCheckedAt': instance.lastCheckedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'places': instance.places,
      'metadata': instance.metadata,
    };

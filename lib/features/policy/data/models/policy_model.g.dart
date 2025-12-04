// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PolicyModelImpl _$$PolicyModelImplFromJson(Map<String, dynamic> json) =>
    _$PolicyModelImpl(
      title: json['title'] as String,
      version: json['version'] as String,
      lastUpdated: json['lastUpdated'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => PolicySection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PolicyModelImplToJson(_$PolicyModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'version': instance.version,
      'lastUpdated': instance.lastUpdated,
      'sections': instance.sections,
    };

_$PolicySectionImpl _$$PolicySectionImplFromJson(Map<String, dynamic> json) =>
    _$PolicySectionImpl(
      heading: json['heading'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$PolicySectionImplToJson(_$PolicySectionImpl instance) =>
    <String, dynamic>{'heading': instance.heading, 'content': instance.content};

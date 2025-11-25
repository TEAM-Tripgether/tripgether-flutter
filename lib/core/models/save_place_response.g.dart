// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_place_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavePlaceResponseImpl _$$SavePlaceResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SavePlaceResponseImpl(
  memberPlaceId: json['memberPlaceId'] as String,
  placeId: json['placeId'] as String,
  savedStatus: json['savedStatus'] as String,
  savedAt: json['savedAt'] as String,
);

Map<String, dynamic> _$$SavePlaceResponseImplToJson(
  _$SavePlaceResponseImpl instance,
) => <String, dynamic>{
  'memberPlaceId': instance.memberPlaceId,
  'placeId': instance.placeId,
  'savedStatus': instance.savedStatus,
  'savedAt': instance.savedAt,
};

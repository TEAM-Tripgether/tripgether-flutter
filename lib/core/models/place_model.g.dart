// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceModelImpl _$$PlaceModelImplFromJson(Map<String, dynamic> json) =>
    _$PlaceModelImpl(
      placeId: json['placeId'] as String,
      position: (json['position'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      country: json['country'] as String? ?? 'KR',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      businessType: json['businessType'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      businessStatus: json['businessStatus'] as String? ?? 'OPERATIONAL',
      iconUrl: json['iconUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: (json['userRatingsTotal'] as num?)?.toInt(),
      photoUrls:
          (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String? ?? 'system',
      updatedBy: json['updatedBy'] as String? ?? 'system',
    );

Map<String, dynamic> _$$PlaceModelImplToJson(_$PlaceModelImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'position': instance.position,
      'name': instance.name,
      'address': instance.address,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'businessType': instance.businessType,
      'phone': instance.phone,
      'description': instance.description,
      'types': instance.types,
      'businessStatus': instance.businessStatus,
      'iconUrl': instance.iconUrl,
      'rating': instance.rating,
      'userRatingsTotal': instance.userRatingsTotal,
      'photoUrls': instance.photoUrls,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

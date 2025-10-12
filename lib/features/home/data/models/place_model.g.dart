// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedPlaceImpl _$$SavedPlaceImplFromJson(Map<String, dynamic> json) =>
    _$SavedPlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$PlaceCategoryEnumMap, json['category']),
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      businessHours: json['businessHours'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      savedAt: DateTime.parse(json['savedAt'] as String),
      isVisited: json['isVisited'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$SavedPlaceImplToJson(_$SavedPlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': _$PlaceCategoryEnumMap[instance.category]!,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'imageUrls': instance.imageUrls,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'businessHours': instance.businessHours,
      'phoneNumber': instance.phoneNumber,
      'savedAt': instance.savedAt.toIso8601String(),
      'isVisited': instance.isVisited,
      'isFavorite': instance.isFavorite,
    };

const _$PlaceCategoryEnumMap = {
  PlaceCategory.restaurant: 'restaurant',
  PlaceCategory.cafe: 'cafe',
  PlaceCategory.attraction: 'attraction',
  PlaceCategory.accommodation: 'accommodation',
  PlaceCategory.shopping: 'shopping',
  PlaceCategory.activity: 'activity',
  PlaceCategory.bar: 'bar',
  PlaceCategory.dessert: 'dessert',
  PlaceCategory.museum: 'museum',
  PlaceCategory.park: 'park',
};

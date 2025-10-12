// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: $enumDecode(_$CourseCategoryEnumMap, json['category']),
  placeCount: (json['placeCount'] as num).toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String,
  authorName: json['authorName'] as String,
  authorProfileUrl: json['authorProfileUrl'] as String?,
  price: (json['price'] as num).toInt(),
  likeCount: (json['likeCount'] as num).toInt(),
  downloadCount: (json['downloadCount'] as num).toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  location: json['location'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isPopular: json['isPopular'] as bool? ?? false,
  isPremium: json['isPremium'] as bool? ?? false,
  distance: (json['distance'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$CourseImplToJson(_$CourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$CourseCategoryEnumMap[instance.category]!,
      'placeCount': instance.placeCount,
      'estimatedMinutes': instance.estimatedMinutes,
      'thumbnailUrl': instance.thumbnailUrl,
      'authorName': instance.authorName,
      'authorProfileUrl': instance.authorProfileUrl,
      'price': instance.price,
      'likeCount': instance.likeCount,
      'downloadCount': instance.downloadCount,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
      'isPopular': instance.isPopular,
      'isPremium': instance.isPremium,
      'distance': instance.distance,
    };

const _$CourseCategoryEnumMap = {
  CourseCategory.date: 'date',
  CourseCategory.walk: 'walk',
  CourseCategory.vintage: 'vintage',
  CourseCategory.food: 'food',
  CourseCategory.cafe: 'cafe',
  CourseCategory.photo: 'photo',
  CourseCategory.culture: 'culture',
  CourseCategory.shopping: 'shopping',
  CourseCategory.night: 'night',
  CourseCategory.nature: 'nature',
};

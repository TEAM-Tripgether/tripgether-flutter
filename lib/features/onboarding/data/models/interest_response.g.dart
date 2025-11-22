// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetAllInterestsResponseImpl _$$GetAllInterestsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GetAllInterestsResponseImpl(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => InterestCategoryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GetAllInterestsResponseImplToJson(
  _$GetAllInterestsResponseImpl instance,
) => <String, dynamic>{'categories': instance.categories};

_$InterestCategoryDtoImpl _$$InterestCategoryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$InterestCategoryDtoImpl(
  category: json['category'] as String,
  displayName: json['displayName'] as String,
  interests: (json['interests'] as List<dynamic>)
      .map((e) => InterestItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$InterestCategoryDtoImplToJson(
  _$InterestCategoryDtoImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'displayName': instance.displayName,
  'interests': instance.interests,
};

_$InterestItemDtoImpl _$$InterestItemDtoImplFromJson(
  Map<String, dynamic> json,
) => _$InterestItemDtoImpl(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$InterestItemDtoImplToJson(
  _$InterestItemDtoImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$GetInterestByIdResponseImpl _$$GetInterestByIdResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GetInterestByIdResponseImpl(
  id: json['id'] as String,
  category: json['category'] as String,
  categoryDisplayName: json['categoryDisplayName'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$GetInterestByIdResponseImplToJson(
  _$GetInterestByIdResponseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'categoryDisplayName': instance.categoryDisplayName,
  'name': instance.name,
};

_$GetInterestsByCategoryResponseImpl
_$$GetInterestsByCategoryResponseImplFromJson(Map<String, dynamic> json) =>
    _$GetInterestsByCategoryResponseImpl(
      interests: (json['interests'] as List<dynamic>)
          .map((e) => InterestItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetInterestsByCategoryResponseImplToJson(
  _$GetInterestsByCategoryResponseImpl instance,
) => <String, dynamic>{'interests': instance.interests};

import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest_response.freezed.dart';
part 'interest_response.g.dart';

/// 전체 관심사 목록 조회 응답
///
/// GET /api/interests
/// 13개 카테고리별로 그룹핑된 전체 관심사 목록
@freezed
class GetAllInterestsResponse with _$GetAllInterestsResponse {
  const factory GetAllInterestsResponse({
    required List<InterestCategoryDto> categories,
  }) = _GetAllInterestsResponse;

  factory GetAllInterestsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllInterestsResponseFromJson(json);
}

/// 관심사 카테고리 DTO
@freezed
class InterestCategoryDto with _$InterestCategoryDto {
  const factory InterestCategoryDto({
    /// 카테고리 코드 (FOOD, CAFE_DESSERT 등)
    required String category,

    /// 카테고리 표시 이름 (맛집/푸드, 카페/디저트 등)
    required String displayName,

    /// 해당 카테고리의 관심사 목록
    required List<InterestItemDto> interests,
  }) = _InterestCategoryDto;

  factory InterestCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$InterestCategoryDtoFromJson(json);
}

/// 관심사 항목 DTO
@freezed
class InterestItemDto with _$InterestItemDto {
  const factory InterestItemDto({
    /// 관심사 ID (UUID)
    required String id,

    /// 관심사 이름
    required String name,
  }) = _InterestItemDto;

  factory InterestItemDto.fromJson(Map<String, dynamic> json) =>
      _$InterestItemDtoFromJson(json);
}

/// 관심사 상세 조회 응답
///
/// GET /api/interests/{interestId}
@freezed
class GetInterestByIdResponse with _$GetInterestByIdResponse {
  const factory GetInterestByIdResponse({
    /// 관심사 ID
    required String id,

    /// 카테고리 코드
    required String category,

    /// 카테고리 표시 이름
    required String categoryDisplayName,

    /// 관심사 이름
    required String name,
  }) = _GetInterestByIdResponse;

  factory GetInterestByIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetInterestByIdResponseFromJson(json);
}

/// 특정 카테고리 관심사 조회 응답
///
/// GET /api/interests/categories/{category}
@freezed
class GetInterestsByCategoryResponse with _$GetInterestsByCategoryResponse {
  const factory GetInterestsByCategoryResponse({
    required List<InterestItemDto> interests,
  }) = _GetInterestsByCategoryResponse;

  factory GetInterestsByCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$GetInterestsByCategoryResponseFromJson(json);
}

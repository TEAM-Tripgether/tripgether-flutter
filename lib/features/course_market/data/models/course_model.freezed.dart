// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Course _$CourseFromJson(Map<String, dynamic> json) {
  return _Course.fromJson(json);
}

/// @nodoc
mixin _$Course {
  /// 코스 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 코스 제목
  String get title => throw _privateConstructorUsedError;

  /// 코스 설명
  String get description => throw _privateConstructorUsedError;

  /// 코스 카테고리 (데이트, 산책, 빈티지 등)
  CourseCategory get category => throw _privateConstructorUsedError;

  /// 코스에 포함된 장소 수
  int get placeCount => throw _privateConstructorUsedError;

  /// 예상 소요 시간 (분 단위)
  int get estimatedMinutes => throw _privateConstructorUsedError;

  /// 코스 썸네일 이미지 URL
  String get thumbnailUrl => throw _privateConstructorUsedError;

  /// 코스 작성자 이름
  String get authorName => throw _privateConstructorUsedError;

  /// 작성자 프로필 이미지 URL
  String? get authorProfileUrl => throw _privateConstructorUsedError;

  /// 코스 가격 (0이면 무료)
  int get price => throw _privateConstructorUsedError;

  /// 좋아요 수
  int get likeCount => throw _privateConstructorUsedError;

  /// 구매/다운로드 수
  int get downloadCount => throw _privateConstructorUsedError;

  /// 평점 (1.0 ~ 5.0)
  double? get rating => throw _privateConstructorUsedError;

  /// 리뷰 개수
  int? get reviewCount => throw _privateConstructorUsedError;

  /// 지역 정보 (예: 서울 강진구)
  String get location => throw _privateConstructorUsedError;

  /// 코스 생성일
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 인기 코스 여부
  bool get isPopular => throw _privateConstructorUsedError;

  /// 프리미엄 코스 여부
  bool get isPremium => throw _privateConstructorUsedError;

  /// 거리 (km)
  double? get distance => throw _privateConstructorUsedError;

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseCopyWith<Course> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseCopyWith<$Res> {
  factory $CourseCopyWith(Course value, $Res Function(Course) then) =
      _$CourseCopyWithImpl<$Res, Course>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    CourseCategory category,
    int placeCount,
    int estimatedMinutes,
    String thumbnailUrl,
    String authorName,
    String? authorProfileUrl,
    int price,
    int likeCount,
    int downloadCount,
    double? rating,
    int? reviewCount,
    String location,
    DateTime createdAt,
    bool isPopular,
    bool isPremium,
    double? distance,
  });
}

/// @nodoc
class _$CourseCopyWithImpl<$Res, $Val extends Course>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? placeCount = null,
    Object? estimatedMinutes = null,
    Object? thumbnailUrl = null,
    Object? authorName = null,
    Object? authorProfileUrl = freezed,
    Object? price = null,
    Object? likeCount = null,
    Object? downloadCount = null,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? location = null,
    Object? createdAt = null,
    Object? isPopular = null,
    Object? isPremium = null,
    Object? distance = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CourseCategory,
            placeCount: null == placeCount
                ? _value.placeCount
                : placeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedMinutes: null == estimatedMinutes
                ? _value.estimatedMinutes
                : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            thumbnailUrl: null == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            authorName: null == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String,
            authorProfileUrl: freezed == authorProfileUrl
                ? _value.authorProfileUrl
                : authorProfileUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            downloadCount: null == downloadCount
                ? _value.downloadCount
                : downloadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            reviewCount: freezed == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isPopular: null == isPopular
                ? _value.isPopular
                : isPopular // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPremium: null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                      as bool,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseImplCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$$CourseImplCopyWith(
    _$CourseImpl value,
    $Res Function(_$CourseImpl) then,
  ) = __$$CourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    CourseCategory category,
    int placeCount,
    int estimatedMinutes,
    String thumbnailUrl,
    String authorName,
    String? authorProfileUrl,
    int price,
    int likeCount,
    int downloadCount,
    double? rating,
    int? reviewCount,
    String location,
    DateTime createdAt,
    bool isPopular,
    bool isPremium,
    double? distance,
  });
}

/// @nodoc
class __$$CourseImplCopyWithImpl<$Res>
    extends _$CourseCopyWithImpl<$Res, _$CourseImpl>
    implements _$$CourseImplCopyWith<$Res> {
  __$$CourseImplCopyWithImpl(
    _$CourseImpl _value,
    $Res Function(_$CourseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? placeCount = null,
    Object? estimatedMinutes = null,
    Object? thumbnailUrl = null,
    Object? authorName = null,
    Object? authorProfileUrl = freezed,
    Object? price = null,
    Object? likeCount = null,
    Object? downloadCount = null,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? location = null,
    Object? createdAt = null,
    Object? isPopular = null,
    Object? isPremium = null,
    Object? distance = freezed,
  }) {
    return _then(
      _$CourseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CourseCategory,
        placeCount: null == placeCount
            ? _value.placeCount
            : placeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedMinutes: null == estimatedMinutes
            ? _value.estimatedMinutes
            : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        thumbnailUrl: null == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        authorName: null == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String,
        authorProfileUrl: freezed == authorProfileUrl
            ? _value.authorProfileUrl
            : authorProfileUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        downloadCount: null == downloadCount
            ? _value.downloadCount
            : downloadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        reviewCount: freezed == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isPopular: null == isPopular
            ? _value.isPopular
            : isPopular // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPremium: null == isPremium
            ? _value.isPremium
            : isPremium // ignore: cast_nullable_to_non_nullable
                  as bool,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseImpl extends _Course {
  const _$CourseImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.placeCount,
    required this.estimatedMinutes,
    required this.thumbnailUrl,
    required this.authorName,
    this.authorProfileUrl,
    required this.price,
    required this.likeCount,
    required this.downloadCount,
    this.rating,
    this.reviewCount,
    required this.location,
    required this.createdAt,
    this.isPopular = false,
    this.isPremium = false,
    this.distance,
  }) : super._();

  factory _$CourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseImplFromJson(json);

  /// 코스 고유 ID
  @override
  final String id;

  /// 코스 제목
  @override
  final String title;

  /// 코스 설명
  @override
  final String description;

  /// 코스 카테고리 (데이트, 산책, 빈티지 등)
  @override
  final CourseCategory category;

  /// 코스에 포함된 장소 수
  @override
  final int placeCount;

  /// 예상 소요 시간 (분 단위)
  @override
  final int estimatedMinutes;

  /// 코스 썸네일 이미지 URL
  @override
  final String thumbnailUrl;

  /// 코스 작성자 이름
  @override
  final String authorName;

  /// 작성자 프로필 이미지 URL
  @override
  final String? authorProfileUrl;

  /// 코스 가격 (0이면 무료)
  @override
  final int price;

  /// 좋아요 수
  @override
  final int likeCount;

  /// 구매/다운로드 수
  @override
  final int downloadCount;

  /// 평점 (1.0 ~ 5.0)
  @override
  final double? rating;

  /// 리뷰 개수
  @override
  final int? reviewCount;

  /// 지역 정보 (예: 서울 강진구)
  @override
  final String location;

  /// 코스 생성일
  @override
  final DateTime createdAt;

  /// 인기 코스 여부
  @override
  @JsonKey()
  final bool isPopular;

  /// 프리미엄 코스 여부
  @override
  @JsonKey()
  final bool isPremium;

  /// 거리 (km)
  @override
  final double? distance;

  @override
  String toString() {
    return 'Course(id: $id, title: $title, description: $description, category: $category, placeCount: $placeCount, estimatedMinutes: $estimatedMinutes, thumbnailUrl: $thumbnailUrl, authorName: $authorName, authorProfileUrl: $authorProfileUrl, price: $price, likeCount: $likeCount, downloadCount: $downloadCount, rating: $rating, reviewCount: $reviewCount, location: $location, createdAt: $createdAt, isPopular: $isPopular, isPremium: $isPremium, distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.placeCount, placeCount) ||
                other.placeCount == placeCount) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorProfileUrl, authorProfileUrl) ||
                other.authorProfileUrl == authorProfileUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.downloadCount, downloadCount) ||
                other.downloadCount == downloadCount) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    category,
    placeCount,
    estimatedMinutes,
    thumbnailUrl,
    authorName,
    authorProfileUrl,
    price,
    likeCount,
    downloadCount,
    rating,
    reviewCount,
    location,
    createdAt,
    isPopular,
    isPremium,
    distance,
  ]);

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      __$$CourseImplCopyWithImpl<_$CourseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseImplToJson(this);
  }
}

abstract class _Course extends Course {
  const factory _Course({
    required final String id,
    required final String title,
    required final String description,
    required final CourseCategory category,
    required final int placeCount,
    required final int estimatedMinutes,
    required final String thumbnailUrl,
    required final String authorName,
    final String? authorProfileUrl,
    required final int price,
    required final int likeCount,
    required final int downloadCount,
    final double? rating,
    final int? reviewCount,
    required final String location,
    required final DateTime createdAt,
    final bool isPopular,
    final bool isPremium,
    final double? distance,
  }) = _$CourseImpl;
  const _Course._() : super._();

  factory _Course.fromJson(Map<String, dynamic> json) = _$CourseImpl.fromJson;

  /// 코스 고유 ID
  @override
  String get id;

  /// 코스 제목
  @override
  String get title;

  /// 코스 설명
  @override
  String get description;

  /// 코스 카테고리 (데이트, 산책, 빈티지 등)
  @override
  CourseCategory get category;

  /// 코스에 포함된 장소 수
  @override
  int get placeCount;

  /// 예상 소요 시간 (분 단위)
  @override
  int get estimatedMinutes;

  /// 코스 썸네일 이미지 URL
  @override
  String get thumbnailUrl;

  /// 코스 작성자 이름
  @override
  String get authorName;

  /// 작성자 프로필 이미지 URL
  @override
  String? get authorProfileUrl;

  /// 코스 가격 (0이면 무료)
  @override
  int get price;

  /// 좋아요 수
  @override
  int get likeCount;

  /// 구매/다운로드 수
  @override
  int get downloadCount;

  /// 평점 (1.0 ~ 5.0)
  @override
  double? get rating;

  /// 리뷰 개수
  @override
  int? get reviewCount;

  /// 지역 정보 (예: 서울 강진구)
  @override
  String get location;

  /// 코스 생성일
  @override
  DateTime get createdAt;

  /// 인기 코스 여부
  @override
  bool get isPopular;

  /// 프리미엄 코스 여부
  @override
  bool get isPremium;

  /// 거리 (km)
  @override
  double? get distance;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

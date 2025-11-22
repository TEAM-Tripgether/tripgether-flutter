// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) {
  return _PlaceModel.fromJson(json);
}

/// @nodoc
mixin _$PlaceModel {
  /// 장소 고유 ID
  String get placeId => throw _privateConstructorUsedError;

  /// 콘텐츠 내에서의 장소 순서 (0부터 시작)
  int get position => throw _privateConstructorUsedError;

  /// 장소명
  String get name => throw _privateConstructorUsedError;

  /// 주소 (전체 주소)
  String get address => throw _privateConstructorUsedError;

  /// 국가 코드 (KR, US 등)
  String get country => throw _privateConstructorUsedError;

  /// 위도
  double get latitude => throw _privateConstructorUsedError;

  /// 경도
  double get longitude => throw _privateConstructorUsedError;

  /// 비즈니스 타입 (restaurant, cafe, beach, tourist_attraction 등)
  String? get businessType => throw _privateConstructorUsedError;

  /// 카테고리 (한국어, 예: "카페", "음식점", "해변")
  String? get category => throw _privateConstructorUsedError;

  /// 전화번호
  String? get phone => throw _privateConstructorUsedError;

  /// 장소 설명
  String? get description => throw _privateConstructorUsedError;

  /// 장소 타입들 (Google Places API types)
  List<String> get types => throw _privateConstructorUsedError;

  /// 영업 상태 (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY)
  String get businessStatus => throw _privateConstructorUsedError;

  /// 아이콘 URL (Google Places 제공)
  String? get iconUrl => throw _privateConstructorUsedError;

  /// 평점 (0.0 ~ 5.0)
  double? get rating => throw _privateConstructorUsedError;

  /// 리뷰 수
  int? get userRatingsTotal => throw _privateConstructorUsedError;

  /// 사진 URL 리스트
  List<String> get photoUrls => throw _privateConstructorUsedError;

  /// 생성 일시
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 수정 일시
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 생성자
  String get createdBy => throw _privateConstructorUsedError;

  /// 수정자
  String get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this PlaceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceModelCopyWith<PlaceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceModelCopyWith<$Res> {
  factory $PlaceModelCopyWith(
    PlaceModel value,
    $Res Function(PlaceModel) then,
  ) = _$PlaceModelCopyWithImpl<$Res, PlaceModel>;
  @useResult
  $Res call({
    String placeId,
    int position,
    String name,
    String address,
    String country,
    double latitude,
    double longitude,
    String? businessType,
    String? category,
    String? phone,
    String? description,
    List<String> types,
    String businessStatus,
    String? iconUrl,
    double? rating,
    int? userRatingsTotal,
    List<String> photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    String createdBy,
    String updatedBy,
  });
}

/// @nodoc
class _$PlaceModelCopyWithImpl<$Res, $Val extends PlaceModel>
    implements $PlaceModelCopyWith<$Res> {
  _$PlaceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? position = null,
    Object? name = null,
    Object? address = null,
    Object? country = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? businessType = freezed,
    Object? category = freezed,
    Object? phone = freezed,
    Object? description = freezed,
    Object? types = null,
    Object? businessStatus = null,
    Object? iconUrl = freezed,
    Object? rating = freezed,
    Object? userRatingsTotal = freezed,
    Object? photoUrls = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = null,
    Object? updatedBy = null,
  }) {
    return _then(
      _value.copyWith(
            placeId: null == placeId
                ? _value.placeId
                : placeId // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            country: null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            businessType: freezed == businessType
                ? _value.businessType
                : businessType // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            types: null == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            businessStatus: null == businessStatus
                ? _value.businessStatus
                : businessStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            userRatingsTotal: freezed == userRatingsTotal
                ? _value.userRatingsTotal
                : userRatingsTotal // ignore: cast_nullable_to_non_nullable
                      as int?,
            photoUrls: null == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedBy: null == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaceModelImplCopyWith<$Res>
    implements $PlaceModelCopyWith<$Res> {
  factory _$$PlaceModelImplCopyWith(
    _$PlaceModelImpl value,
    $Res Function(_$PlaceModelImpl) then,
  ) = __$$PlaceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String placeId,
    int position,
    String name,
    String address,
    String country,
    double latitude,
    double longitude,
    String? businessType,
    String? category,
    String? phone,
    String? description,
    List<String> types,
    String businessStatus,
    String? iconUrl,
    double? rating,
    int? userRatingsTotal,
    List<String> photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    String createdBy,
    String updatedBy,
  });
}

/// @nodoc
class __$$PlaceModelImplCopyWithImpl<$Res>
    extends _$PlaceModelCopyWithImpl<$Res, _$PlaceModelImpl>
    implements _$$PlaceModelImplCopyWith<$Res> {
  __$$PlaceModelImplCopyWithImpl(
    _$PlaceModelImpl _value,
    $Res Function(_$PlaceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? position = null,
    Object? name = null,
    Object? address = null,
    Object? country = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? businessType = freezed,
    Object? category = freezed,
    Object? phone = freezed,
    Object? description = freezed,
    Object? types = null,
    Object? businessStatus = null,
    Object? iconUrl = freezed,
    Object? rating = freezed,
    Object? userRatingsTotal = freezed,
    Object? photoUrls = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = null,
    Object? updatedBy = null,
  }) {
    return _then(
      _$PlaceModelImpl(
        placeId: null == placeId
            ? _value.placeId
            : placeId // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        country: null == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        businessType: freezed == businessType
            ? _value.businessType
            : businessType // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        types: null == types
            ? _value._types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        businessStatus: null == businessStatus
            ? _value.businessStatus
            : businessStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        userRatingsTotal: freezed == userRatingsTotal
            ? _value.userRatingsTotal
            : userRatingsTotal // ignore: cast_nullable_to_non_nullable
                  as int?,
        photoUrls: null == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedBy: null == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceModelImpl implements _PlaceModel {
  const _$PlaceModelImpl({
    required this.placeId,
    required this.position,
    required this.name,
    required this.address,
    this.country = 'KR',
    required this.latitude,
    required this.longitude,
    this.businessType,
    this.category,
    this.phone,
    this.description,
    final List<String> types = const [],
    this.businessStatus = 'OPERATIONAL',
    this.iconUrl,
    this.rating,
    this.userRatingsTotal,
    final List<String> photoUrls = const [],
    this.createdAt,
    this.updatedAt,
    this.createdBy = 'system',
    this.updatedBy = 'system',
  }) : _types = types,
       _photoUrls = photoUrls;

  factory _$PlaceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceModelImplFromJson(json);

  /// 장소 고유 ID
  @override
  final String placeId;

  /// 콘텐츠 내에서의 장소 순서 (0부터 시작)
  @override
  final int position;

  /// 장소명
  @override
  final String name;

  /// 주소 (전체 주소)
  @override
  final String address;

  /// 국가 코드 (KR, US 등)
  @override
  @JsonKey()
  final String country;

  /// 위도
  @override
  final double latitude;

  /// 경도
  @override
  final double longitude;

  /// 비즈니스 타입 (restaurant, cafe, beach, tourist_attraction 등)
  @override
  final String? businessType;

  /// 카테고리 (한국어, 예: "카페", "음식점", "해변")
  @override
  final String? category;

  /// 전화번호
  @override
  final String? phone;

  /// 장소 설명
  @override
  final String? description;

  /// 장소 타입들 (Google Places API types)
  final List<String> _types;

  /// 장소 타입들 (Google Places API types)
  @override
  @JsonKey()
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  /// 영업 상태 (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY)
  @override
  @JsonKey()
  final String businessStatus;

  /// 아이콘 URL (Google Places 제공)
  @override
  final String? iconUrl;

  /// 평점 (0.0 ~ 5.0)
  @override
  final double? rating;

  /// 리뷰 수
  @override
  final int? userRatingsTotal;

  /// 사진 URL 리스트
  final List<String> _photoUrls;

  /// 사진 URL 리스트
  @override
  @JsonKey()
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  /// 생성 일시
  @override
  final DateTime? createdAt;

  /// 수정 일시
  @override
  final DateTime? updatedAt;

  /// 생성자
  @override
  @JsonKey()
  final String createdBy;

  /// 수정자
  @override
  @JsonKey()
  final String updatedBy;

  @override
  String toString() {
    return 'PlaceModel(placeId: $placeId, position: $position, name: $name, address: $address, country: $country, latitude: $latitude, longitude: $longitude, businessType: $businessType, category: $category, phone: $phone, description: $description, types: $types, businessStatus: $businessStatus, iconUrl: $iconUrl, rating: $rating, userRatingsTotal: $userRatingsTotal, photoUrls: $photoUrls, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceModelImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.businessStatus, businessStatus) ||
                other.businessStatus == businessStatus) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.userRatingsTotal, userRatingsTotal) ||
                other.userRatingsTotal == userRatingsTotal) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    placeId,
    position,
    name,
    address,
    country,
    latitude,
    longitude,
    businessType,
    category,
    phone,
    description,
    const DeepCollectionEquality().hash(_types),
    businessStatus,
    iconUrl,
    rating,
    userRatingsTotal,
    const DeepCollectionEquality().hash(_photoUrls),
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ]);

  /// Create a copy of PlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceModelImplCopyWith<_$PlaceModelImpl> get copyWith =>
      __$$PlaceModelImplCopyWithImpl<_$PlaceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceModelImplToJson(this);
  }
}

abstract class _PlaceModel implements PlaceModel {
  const factory _PlaceModel({
    required final String placeId,
    required final int position,
    required final String name,
    required final String address,
    final String country,
    required final double latitude,
    required final double longitude,
    final String? businessType,
    final String? category,
    final String? phone,
    final String? description,
    final List<String> types,
    final String businessStatus,
    final String? iconUrl,
    final double? rating,
    final int? userRatingsTotal,
    final List<String> photoUrls,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String createdBy,
    final String updatedBy,
  }) = _$PlaceModelImpl;

  factory _PlaceModel.fromJson(Map<String, dynamic> json) =
      _$PlaceModelImpl.fromJson;

  /// 장소 고유 ID
  @override
  String get placeId;

  /// 콘텐츠 내에서의 장소 순서 (0부터 시작)
  @override
  int get position;

  /// 장소명
  @override
  String get name;

  /// 주소 (전체 주소)
  @override
  String get address;

  /// 국가 코드 (KR, US 등)
  @override
  String get country;

  /// 위도
  @override
  double get latitude;

  /// 경도
  @override
  double get longitude;

  /// 비즈니스 타입 (restaurant, cafe, beach, tourist_attraction 등)
  @override
  String? get businessType;

  /// 카테고리 (한국어, 예: "카페", "음식점", "해변")
  @override
  String? get category;

  /// 전화번호
  @override
  String? get phone;

  /// 장소 설명
  @override
  String? get description;

  /// 장소 타입들 (Google Places API types)
  @override
  List<String> get types;

  /// 영업 상태 (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY)
  @override
  String get businessStatus;

  /// 아이콘 URL (Google Places 제공)
  @override
  String? get iconUrl;

  /// 평점 (0.0 ~ 5.0)
  @override
  double? get rating;

  /// 리뷰 수
  @override
  int? get userRatingsTotal;

  /// 사진 URL 리스트
  @override
  List<String> get photoUrls;

  /// 생성 일시
  @override
  DateTime? get createdAt;

  /// 수정 일시
  @override
  DateTime? get updatedAt;

  /// 생성자
  @override
  String get createdBy;

  /// 수정자
  @override
  String get updatedBy;

  /// Create a copy of PlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceModelImplCopyWith<_$PlaceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

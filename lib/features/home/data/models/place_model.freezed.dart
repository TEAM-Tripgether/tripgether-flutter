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

SavedPlace _$SavedPlaceFromJson(Map<String, dynamic> json) {
  return _SavedPlace.fromJson(json);
}

/// @nodoc
mixin _$SavedPlace {
  /// 장소 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 장소명
  String get name => throw _privateConstructorUsedError;

  /// 업종/카테고리 (카페, 음식점, 관광지 등)
  PlaceCategory get category => throw _privateConstructorUsedError;

  /// 주소
  String get address => throw _privateConstructorUsedError;

  /// 상세 주소
  String? get detailAddress => throw _privateConstructorUsedError;

  /// 위도
  double get latitude => throw _privateConstructorUsedError;

  /// 경도
  double get longitude => throw _privateConstructorUsedError;

  /// 장소 설명
  String? get description => throw _privateConstructorUsedError;

  /// 장소 이미지 URL 리스트
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// 평점 (1.0 ~ 5.0)
  double? get rating => throw _privateConstructorUsedError;

  /// 리뷰 개수
  int? get reviewCount => throw _privateConstructorUsedError;

  /// 영업 시간
  String? get businessHours => throw _privateConstructorUsedError;

  /// 전화번호
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// 저장 날짜
  DateTime get savedAt => throw _privateConstructorUsedError;

  /// 방문 여부
  bool get isVisited => throw _privateConstructorUsedError;

  /// 즐겨찾기 여부
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Serializes this SavedPlace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedPlaceCopyWith<SavedPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedPlaceCopyWith<$Res> {
  factory $SavedPlaceCopyWith(
    SavedPlace value,
    $Res Function(SavedPlace) then,
  ) = _$SavedPlaceCopyWithImpl<$Res, SavedPlace>;
  @useResult
  $Res call({
    String id,
    String name,
    PlaceCategory category,
    String address,
    String? detailAddress,
    double latitude,
    double longitude,
    String? description,
    List<String> imageUrls,
    double? rating,
    int? reviewCount,
    String? businessHours,
    String? phoneNumber,
    DateTime savedAt,
    bool isVisited,
    bool isFavorite,
  });
}

/// @nodoc
class _$SavedPlaceCopyWithImpl<$Res, $Val extends SavedPlace>
    implements $SavedPlaceCopyWith<$Res> {
  _$SavedPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? address = null,
    Object? detailAddress = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = freezed,
    Object? imageUrls = null,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? businessHours = freezed,
    Object? phoneNumber = freezed,
    Object? savedAt = null,
    Object? isVisited = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as PlaceCategory,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            detailAddress: freezed == detailAddress
                ? _value.detailAddress
                : detailAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            reviewCount: freezed == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            businessHours: freezed == businessHours
                ? _value.businessHours
                : businessHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            savedAt: null == savedAt
                ? _value.savedAt
                : savedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isVisited: null == isVisited
                ? _value.isVisited
                : isVisited // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavedPlaceImplCopyWith<$Res>
    implements $SavedPlaceCopyWith<$Res> {
  factory _$$SavedPlaceImplCopyWith(
    _$SavedPlaceImpl value,
    $Res Function(_$SavedPlaceImpl) then,
  ) = __$$SavedPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    PlaceCategory category,
    String address,
    String? detailAddress,
    double latitude,
    double longitude,
    String? description,
    List<String> imageUrls,
    double? rating,
    int? reviewCount,
    String? businessHours,
    String? phoneNumber,
    DateTime savedAt,
    bool isVisited,
    bool isFavorite,
  });
}

/// @nodoc
class __$$SavedPlaceImplCopyWithImpl<$Res>
    extends _$SavedPlaceCopyWithImpl<$Res, _$SavedPlaceImpl>
    implements _$$SavedPlaceImplCopyWith<$Res> {
  __$$SavedPlaceImplCopyWithImpl(
    _$SavedPlaceImpl _value,
    $Res Function(_$SavedPlaceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? address = null,
    Object? detailAddress = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = freezed,
    Object? imageUrls = null,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? businessHours = freezed,
    Object? phoneNumber = freezed,
    Object? savedAt = null,
    Object? isVisited = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$SavedPlaceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as PlaceCategory,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        detailAddress: freezed == detailAddress
            ? _value.detailAddress
            : detailAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        reviewCount: freezed == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        businessHours: freezed == businessHours
            ? _value.businessHours
            : businessHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        savedAt: null == savedAt
            ? _value.savedAt
            : savedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isVisited: null == isVisited
            ? _value.isVisited
            : isVisited // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedPlaceImpl extends _SavedPlace {
  const _$SavedPlaceImpl({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    this.detailAddress,
    required this.latitude,
    required this.longitude,
    this.description,
    required final List<String> imageUrls,
    this.rating,
    this.reviewCount,
    this.businessHours,
    this.phoneNumber,
    required this.savedAt,
    this.isVisited = false,
    this.isFavorite = false,
  }) : _imageUrls = imageUrls,
       super._();

  factory _$SavedPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedPlaceImplFromJson(json);

  /// 장소 고유 ID
  @override
  final String id;

  /// 장소명
  @override
  final String name;

  /// 업종/카테고리 (카페, 음식점, 관광지 등)
  @override
  final PlaceCategory category;

  /// 주소
  @override
  final String address;

  /// 상세 주소
  @override
  final String? detailAddress;

  /// 위도
  @override
  final double latitude;

  /// 경도
  @override
  final double longitude;

  /// 장소 설명
  @override
  final String? description;

  /// 장소 이미지 URL 리스트
  final List<String> _imageUrls;

  /// 장소 이미지 URL 리스트
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// 평점 (1.0 ~ 5.0)
  @override
  final double? rating;

  /// 리뷰 개수
  @override
  final int? reviewCount;

  /// 영업 시간
  @override
  final String? businessHours;

  /// 전화번호
  @override
  final String? phoneNumber;

  /// 저장 날짜
  @override
  final DateTime savedAt;

  /// 방문 여부
  @override
  @JsonKey()
  final bool isVisited;

  /// 즐겨찾기 여부
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'SavedPlace(id: $id, name: $name, category: $category, address: $address, detailAddress: $detailAddress, latitude: $latitude, longitude: $longitude, description: $description, imageUrls: $imageUrls, rating: $rating, reviewCount: $reviewCount, businessHours: $businessHours, phoneNumber: $phoneNumber, savedAt: $savedAt, isVisited: $isVisited, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedPlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.detailAddress, detailAddress) ||
                other.detailAddress == detailAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.businessHours, businessHours) ||
                other.businessHours == businessHours) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt) &&
            (identical(other.isVisited, isVisited) ||
                other.isVisited == isVisited) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    address,
    detailAddress,
    latitude,
    longitude,
    description,
    const DeepCollectionEquality().hash(_imageUrls),
    rating,
    reviewCount,
    businessHours,
    phoneNumber,
    savedAt,
    isVisited,
    isFavorite,
  );

  /// Create a copy of SavedPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedPlaceImplCopyWith<_$SavedPlaceImpl> get copyWith =>
      __$$SavedPlaceImplCopyWithImpl<_$SavedPlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedPlaceImplToJson(this);
  }
}

abstract class _SavedPlace extends SavedPlace {
  const factory _SavedPlace({
    required final String id,
    required final String name,
    required final PlaceCategory category,
    required final String address,
    final String? detailAddress,
    required final double latitude,
    required final double longitude,
    final String? description,
    required final List<String> imageUrls,
    final double? rating,
    final int? reviewCount,
    final String? businessHours,
    final String? phoneNumber,
    required final DateTime savedAt,
    final bool isVisited,
    final bool isFavorite,
  }) = _$SavedPlaceImpl;
  const _SavedPlace._() : super._();

  factory _SavedPlace.fromJson(Map<String, dynamic> json) =
      _$SavedPlaceImpl.fromJson;

  /// 장소 고유 ID
  @override
  String get id;

  /// 장소명
  @override
  String get name;

  /// 업종/카테고리 (카페, 음식점, 관광지 등)
  @override
  PlaceCategory get category;

  /// 주소
  @override
  String get address;

  /// 상세 주소
  @override
  String? get detailAddress;

  /// 위도
  @override
  double get latitude;

  /// 경도
  @override
  double get longitude;

  /// 장소 설명
  @override
  String? get description;

  /// 장소 이미지 URL 리스트
  @override
  List<String> get imageUrls;

  /// 평점 (1.0 ~ 5.0)
  @override
  double? get rating;

  /// 리뷰 개수
  @override
  int? get reviewCount;

  /// 영업 시간
  @override
  String? get businessHours;

  /// 전화번호
  @override
  String? get phoneNumber;

  /// 저장 날짜
  @override
  DateTime get savedAt;

  /// 방문 여부
  @override
  bool get isVisited;

  /// 즐겨찾기 여부
  @override
  bool get isFavorite;

  /// Create a copy of SavedPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedPlaceImplCopyWith<_$SavedPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

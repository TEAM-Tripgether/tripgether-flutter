// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interest_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GetAllInterestsResponse _$GetAllInterestsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetAllInterestsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetAllInterestsResponse {
  List<InterestCategoryDto> get categories =>
      throw _privateConstructorUsedError;

  /// Serializes this GetAllInterestsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetAllInterestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetAllInterestsResponseCopyWith<GetAllInterestsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetAllInterestsResponseCopyWith<$Res> {
  factory $GetAllInterestsResponseCopyWith(
    GetAllInterestsResponse value,
    $Res Function(GetAllInterestsResponse) then,
  ) = _$GetAllInterestsResponseCopyWithImpl<$Res, GetAllInterestsResponse>;
  @useResult
  $Res call({List<InterestCategoryDto> categories});
}

/// @nodoc
class _$GetAllInterestsResponseCopyWithImpl<
  $Res,
  $Val extends GetAllInterestsResponse
>
    implements $GetAllInterestsResponseCopyWith<$Res> {
  _$GetAllInterestsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetAllInterestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categories = null}) {
    return _then(
      _value.copyWith(
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<InterestCategoryDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetAllInterestsResponseImplCopyWith<$Res>
    implements $GetAllInterestsResponseCopyWith<$Res> {
  factory _$$GetAllInterestsResponseImplCopyWith(
    _$GetAllInterestsResponseImpl value,
    $Res Function(_$GetAllInterestsResponseImpl) then,
  ) = __$$GetAllInterestsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<InterestCategoryDto> categories});
}

/// @nodoc
class __$$GetAllInterestsResponseImplCopyWithImpl<$Res>
    extends
        _$GetAllInterestsResponseCopyWithImpl<
          $Res,
          _$GetAllInterestsResponseImpl
        >
    implements _$$GetAllInterestsResponseImplCopyWith<$Res> {
  __$$GetAllInterestsResponseImplCopyWithImpl(
    _$GetAllInterestsResponseImpl _value,
    $Res Function(_$GetAllInterestsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetAllInterestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categories = null}) {
    return _then(
      _$GetAllInterestsResponseImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<InterestCategoryDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetAllInterestsResponseImpl implements _GetAllInterestsResponse {
  const _$GetAllInterestsResponseImpl({
    required final List<InterestCategoryDto> categories,
  }) : _categories = categories;

  factory _$GetAllInterestsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetAllInterestsResponseImplFromJson(json);

  final List<InterestCategoryDto> _categories;
  @override
  List<InterestCategoryDto> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'GetAllInterestsResponse(categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetAllInterestsResponseImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
  );

  /// Create a copy of GetAllInterestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetAllInterestsResponseImplCopyWith<_$GetAllInterestsResponseImpl>
  get copyWith =>
      __$$GetAllInterestsResponseImplCopyWithImpl<
        _$GetAllInterestsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetAllInterestsResponseImplToJson(this);
  }
}

abstract class _GetAllInterestsResponse implements GetAllInterestsResponse {
  const factory _GetAllInterestsResponse({
    required final List<InterestCategoryDto> categories,
  }) = _$GetAllInterestsResponseImpl;

  factory _GetAllInterestsResponse.fromJson(Map<String, dynamic> json) =
      _$GetAllInterestsResponseImpl.fromJson;

  @override
  List<InterestCategoryDto> get categories;

  /// Create a copy of GetAllInterestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetAllInterestsResponseImplCopyWith<_$GetAllInterestsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InterestCategoryDto _$InterestCategoryDtoFromJson(Map<String, dynamic> json) {
  return _InterestCategoryDto.fromJson(json);
}

/// @nodoc
mixin _$InterestCategoryDto {
  /// 카테고리 코드 (FOOD, CAFE_DESSERT 등)
  String get category => throw _privateConstructorUsedError;

  /// 카테고리 표시 이름 (맛집/푸드, 카페/디저트 등)
  String get displayName => throw _privateConstructorUsedError;

  /// 해당 카테고리의 관심사 목록
  List<InterestItemDto> get interests => throw _privateConstructorUsedError;

  /// Serializes this InterestCategoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InterestCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InterestCategoryDtoCopyWith<InterestCategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestCategoryDtoCopyWith<$Res> {
  factory $InterestCategoryDtoCopyWith(
    InterestCategoryDto value,
    $Res Function(InterestCategoryDto) then,
  ) = _$InterestCategoryDtoCopyWithImpl<$Res, InterestCategoryDto>;
  @useResult
  $Res call({
    String category,
    String displayName,
    List<InterestItemDto> interests,
  });
}

/// @nodoc
class _$InterestCategoryDtoCopyWithImpl<$Res, $Val extends InterestCategoryDto>
    implements $InterestCategoryDtoCopyWith<$Res> {
  _$InterestCategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InterestCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? displayName = null,
    Object? interests = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            interests: null == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<InterestItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InterestCategoryDtoImplCopyWith<$Res>
    implements $InterestCategoryDtoCopyWith<$Res> {
  factory _$$InterestCategoryDtoImplCopyWith(
    _$InterestCategoryDtoImpl value,
    $Res Function(_$InterestCategoryDtoImpl) then,
  ) = __$$InterestCategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String category,
    String displayName,
    List<InterestItemDto> interests,
  });
}

/// @nodoc
class __$$InterestCategoryDtoImplCopyWithImpl<$Res>
    extends _$InterestCategoryDtoCopyWithImpl<$Res, _$InterestCategoryDtoImpl>
    implements _$$InterestCategoryDtoImplCopyWith<$Res> {
  __$$InterestCategoryDtoImplCopyWithImpl(
    _$InterestCategoryDtoImpl _value,
    $Res Function(_$InterestCategoryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterestCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? displayName = null,
    Object? interests = null,
  }) {
    return _then(
      _$InterestCategoryDtoImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        interests: null == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<InterestItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InterestCategoryDtoImpl implements _InterestCategoryDto {
  const _$InterestCategoryDtoImpl({
    required this.category,
    required this.displayName,
    required final List<InterestItemDto> interests,
  }) : _interests = interests;

  factory _$InterestCategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterestCategoryDtoImplFromJson(json);

  /// 카테고리 코드 (FOOD, CAFE_DESSERT 등)
  @override
  final String category;

  /// 카테고리 표시 이름 (맛집/푸드, 카페/디저트 등)
  @override
  final String displayName;

  /// 해당 카테고리의 관심사 목록
  final List<InterestItemDto> _interests;

  /// 해당 카테고리의 관심사 목록
  @override
  List<InterestItemDto> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  String toString() {
    return 'InterestCategoryDto(category: $category, displayName: $displayName, interests: $interests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestCategoryDtoImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    displayName,
    const DeepCollectionEquality().hash(_interests),
  );

  /// Create a copy of InterestCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestCategoryDtoImplCopyWith<_$InterestCategoryDtoImpl> get copyWith =>
      __$$InterestCategoryDtoImplCopyWithImpl<_$InterestCategoryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InterestCategoryDtoImplToJson(this);
  }
}

abstract class _InterestCategoryDto implements InterestCategoryDto {
  const factory _InterestCategoryDto({
    required final String category,
    required final String displayName,
    required final List<InterestItemDto> interests,
  }) = _$InterestCategoryDtoImpl;

  factory _InterestCategoryDto.fromJson(Map<String, dynamic> json) =
      _$InterestCategoryDtoImpl.fromJson;

  /// 카테고리 코드 (FOOD, CAFE_DESSERT 등)
  @override
  String get category;

  /// 카테고리 표시 이름 (맛집/푸드, 카페/디저트 등)
  @override
  String get displayName;

  /// 해당 카테고리의 관심사 목록
  @override
  List<InterestItemDto> get interests;

  /// Create a copy of InterestCategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InterestCategoryDtoImplCopyWith<_$InterestCategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InterestItemDto _$InterestItemDtoFromJson(Map<String, dynamic> json) {
  return _InterestItemDto.fromJson(json);
}

/// @nodoc
mixin _$InterestItemDto {
  /// 관심사 ID (UUID)
  String get id => throw _privateConstructorUsedError;

  /// 관심사 이름
  String get name => throw _privateConstructorUsedError;

  /// Serializes this InterestItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InterestItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InterestItemDtoCopyWith<InterestItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestItemDtoCopyWith<$Res> {
  factory $InterestItemDtoCopyWith(
    InterestItemDto value,
    $Res Function(InterestItemDto) then,
  ) = _$InterestItemDtoCopyWithImpl<$Res, InterestItemDto>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$InterestItemDtoCopyWithImpl<$Res, $Val extends InterestItemDto>
    implements $InterestItemDtoCopyWith<$Res> {
  _$InterestItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InterestItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InterestItemDtoImplCopyWith<$Res>
    implements $InterestItemDtoCopyWith<$Res> {
  factory _$$InterestItemDtoImplCopyWith(
    _$InterestItemDtoImpl value,
    $Res Function(_$InterestItemDtoImpl) then,
  ) = __$$InterestItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$InterestItemDtoImplCopyWithImpl<$Res>
    extends _$InterestItemDtoCopyWithImpl<$Res, _$InterestItemDtoImpl>
    implements _$$InterestItemDtoImplCopyWith<$Res> {
  __$$InterestItemDtoImplCopyWithImpl(
    _$InterestItemDtoImpl _value,
    $Res Function(_$InterestItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterestItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$InterestItemDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InterestItemDtoImpl implements _InterestItemDto {
  const _$InterestItemDtoImpl({required this.id, required this.name});

  factory _$InterestItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterestItemDtoImplFromJson(json);

  /// 관심사 ID (UUID)
  @override
  final String id;

  /// 관심사 이름
  @override
  final String name;

  @override
  String toString() {
    return 'InterestItemDto(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of InterestItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestItemDtoImplCopyWith<_$InterestItemDtoImpl> get copyWith =>
      __$$InterestItemDtoImplCopyWithImpl<_$InterestItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InterestItemDtoImplToJson(this);
  }
}

abstract class _InterestItemDto implements InterestItemDto {
  const factory _InterestItemDto({
    required final String id,
    required final String name,
  }) = _$InterestItemDtoImpl;

  factory _InterestItemDto.fromJson(Map<String, dynamic> json) =
      _$InterestItemDtoImpl.fromJson;

  /// 관심사 ID (UUID)
  @override
  String get id;

  /// 관심사 이름
  @override
  String get name;

  /// Create a copy of InterestItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InterestItemDtoImplCopyWith<_$InterestItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GetInterestByIdResponse _$GetInterestByIdResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetInterestByIdResponse.fromJson(json);
}

/// @nodoc
mixin _$GetInterestByIdResponse {
  /// 관심사 ID
  String get id => throw _privateConstructorUsedError;

  /// 카테고리 코드
  String get category => throw _privateConstructorUsedError;

  /// 카테고리 표시 이름
  String get categoryDisplayName => throw _privateConstructorUsedError;

  /// 관심사 이름
  String get name => throw _privateConstructorUsedError;

  /// Serializes this GetInterestByIdResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetInterestByIdResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetInterestByIdResponseCopyWith<GetInterestByIdResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetInterestByIdResponseCopyWith<$Res> {
  factory $GetInterestByIdResponseCopyWith(
    GetInterestByIdResponse value,
    $Res Function(GetInterestByIdResponse) then,
  ) = _$GetInterestByIdResponseCopyWithImpl<$Res, GetInterestByIdResponse>;
  @useResult
  $Res call({
    String id,
    String category,
    String categoryDisplayName,
    String name,
  });
}

/// @nodoc
class _$GetInterestByIdResponseCopyWithImpl<
  $Res,
  $Val extends GetInterestByIdResponse
>
    implements $GetInterestByIdResponseCopyWith<$Res> {
  _$GetInterestByIdResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetInterestByIdResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? categoryDisplayName = null,
    Object? name = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryDisplayName: null == categoryDisplayName
                ? _value.categoryDisplayName
                : categoryDisplayName // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetInterestByIdResponseImplCopyWith<$Res>
    implements $GetInterestByIdResponseCopyWith<$Res> {
  factory _$$GetInterestByIdResponseImplCopyWith(
    _$GetInterestByIdResponseImpl value,
    $Res Function(_$GetInterestByIdResponseImpl) then,
  ) = __$$GetInterestByIdResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String category,
    String categoryDisplayName,
    String name,
  });
}

/// @nodoc
class __$$GetInterestByIdResponseImplCopyWithImpl<$Res>
    extends
        _$GetInterestByIdResponseCopyWithImpl<
          $Res,
          _$GetInterestByIdResponseImpl
        >
    implements _$$GetInterestByIdResponseImplCopyWith<$Res> {
  __$$GetInterestByIdResponseImplCopyWithImpl(
    _$GetInterestByIdResponseImpl _value,
    $Res Function(_$GetInterestByIdResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetInterestByIdResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? categoryDisplayName = null,
    Object? name = null,
  }) {
    return _then(
      _$GetInterestByIdResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryDisplayName: null == categoryDisplayName
            ? _value.categoryDisplayName
            : categoryDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetInterestByIdResponseImpl implements _GetInterestByIdResponse {
  const _$GetInterestByIdResponseImpl({
    required this.id,
    required this.category,
    required this.categoryDisplayName,
    required this.name,
  });

  factory _$GetInterestByIdResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetInterestByIdResponseImplFromJson(json);

  /// 관심사 ID
  @override
  final String id;

  /// 카테고리 코드
  @override
  final String category;

  /// 카테고리 표시 이름
  @override
  final String categoryDisplayName;

  /// 관심사 이름
  @override
  final String name;

  @override
  String toString() {
    return 'GetInterestByIdResponse(id: $id, category: $category, categoryDisplayName: $categoryDisplayName, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetInterestByIdResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryDisplayName, categoryDisplayName) ||
                other.categoryDisplayName == categoryDisplayName) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, category, categoryDisplayName, name);

  /// Create a copy of GetInterestByIdResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetInterestByIdResponseImplCopyWith<_$GetInterestByIdResponseImpl>
  get copyWith =>
      __$$GetInterestByIdResponseImplCopyWithImpl<
        _$GetInterestByIdResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetInterestByIdResponseImplToJson(this);
  }
}

abstract class _GetInterestByIdResponse implements GetInterestByIdResponse {
  const factory _GetInterestByIdResponse({
    required final String id,
    required final String category,
    required final String categoryDisplayName,
    required final String name,
  }) = _$GetInterestByIdResponseImpl;

  factory _GetInterestByIdResponse.fromJson(Map<String, dynamic> json) =
      _$GetInterestByIdResponseImpl.fromJson;

  /// 관심사 ID
  @override
  String get id;

  /// 카테고리 코드
  @override
  String get category;

  /// 카테고리 표시 이름
  @override
  String get categoryDisplayName;

  /// 관심사 이름
  @override
  String get name;

  /// Create a copy of GetInterestByIdResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetInterestByIdResponseImplCopyWith<_$GetInterestByIdResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

GetInterestsByCategoryResponse _$GetInterestsByCategoryResponseFromJson(
  Map<String, dynamic> json,
) {
  return _GetInterestsByCategoryResponse.fromJson(json);
}

/// @nodoc
mixin _$GetInterestsByCategoryResponse {
  List<InterestItemDto> get interests => throw _privateConstructorUsedError;

  /// Serializes this GetInterestsByCategoryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetInterestsByCategoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetInterestsByCategoryResponseCopyWith<GetInterestsByCategoryResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetInterestsByCategoryResponseCopyWith<$Res> {
  factory $GetInterestsByCategoryResponseCopyWith(
    GetInterestsByCategoryResponse value,
    $Res Function(GetInterestsByCategoryResponse) then,
  ) =
      _$GetInterestsByCategoryResponseCopyWithImpl<
        $Res,
        GetInterestsByCategoryResponse
      >;
  @useResult
  $Res call({List<InterestItemDto> interests});
}

/// @nodoc
class _$GetInterestsByCategoryResponseCopyWithImpl<
  $Res,
  $Val extends GetInterestsByCategoryResponse
>
    implements $GetInterestsByCategoryResponseCopyWith<$Res> {
  _$GetInterestsByCategoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetInterestsByCategoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? interests = null}) {
    return _then(
      _value.copyWith(
            interests: null == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<InterestItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GetInterestsByCategoryResponseImplCopyWith<$Res>
    implements $GetInterestsByCategoryResponseCopyWith<$Res> {
  factory _$$GetInterestsByCategoryResponseImplCopyWith(
    _$GetInterestsByCategoryResponseImpl value,
    $Res Function(_$GetInterestsByCategoryResponseImpl) then,
  ) = __$$GetInterestsByCategoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<InterestItemDto> interests});
}

/// @nodoc
class __$$GetInterestsByCategoryResponseImplCopyWithImpl<$Res>
    extends
        _$GetInterestsByCategoryResponseCopyWithImpl<
          $Res,
          _$GetInterestsByCategoryResponseImpl
        >
    implements _$$GetInterestsByCategoryResponseImplCopyWith<$Res> {
  __$$GetInterestsByCategoryResponseImplCopyWithImpl(
    _$GetInterestsByCategoryResponseImpl _value,
    $Res Function(_$GetInterestsByCategoryResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GetInterestsByCategoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? interests = null}) {
    return _then(
      _$GetInterestsByCategoryResponseImpl(
        interests: null == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<InterestItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GetInterestsByCategoryResponseImpl
    implements _GetInterestsByCategoryResponse {
  const _$GetInterestsByCategoryResponseImpl({
    required final List<InterestItemDto> interests,
  }) : _interests = interests;

  factory _$GetInterestsByCategoryResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$GetInterestsByCategoryResponseImplFromJson(json);

  final List<InterestItemDto> _interests;
  @override
  List<InterestItemDto> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  String toString() {
    return 'GetInterestsByCategoryResponse(interests: $interests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetInterestsByCategoryResponseImpl &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_interests));

  /// Create a copy of GetInterestsByCategoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetInterestsByCategoryResponseImplCopyWith<
    _$GetInterestsByCategoryResponseImpl
  >
  get copyWith =>
      __$$GetInterestsByCategoryResponseImplCopyWithImpl<
        _$GetInterestsByCategoryResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetInterestsByCategoryResponseImplToJson(this);
  }
}

abstract class _GetInterestsByCategoryResponse
    implements GetInterestsByCategoryResponse {
  const factory _GetInterestsByCategoryResponse({
    required final List<InterestItemDto> interests,
  }) = _$GetInterestsByCategoryResponseImpl;

  factory _GetInterestsByCategoryResponse.fromJson(Map<String, dynamic> json) =
      _$GetInterestsByCategoryResponseImpl.fromJson;

  @override
  List<InterestItemDto> get interests;

  /// Create a copy of GetInterestsByCategoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetInterestsByCategoryResponseImplCopyWith<
    _$GetInterestsByCategoryResponseImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

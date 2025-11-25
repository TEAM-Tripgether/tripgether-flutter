// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContentModel _$ContentModelFromJson(Map<String, dynamic> json) {
  return _ContentModel.fromJson(json);
}

/// @nodoc
mixin _$ContentModel {
  /// 콘텐츠 고유 ID
  /// - POST /api/content/analyze: "contentId" 필드 사용
  /// - 일부 API: "id" 필드 사용
  /// readValue로 "contentId" 또는 "id" 둘 다 처리
  @JsonKey(readValue: _readContentId)
  String get contentId => throw _privateConstructorUsedError;

  /// 회원 ID (백엔드 응답용, 프론트엔드에서는 미사용)
  /// POST /api/content/analyze PENDING 응답: "memberId": null
  String? get memberId => throw _privateConstructorUsedError;

  /// 플랫폼 (INSTAGRAM, YOUTUBE, TIKTOK 등)
  /// POST /api/content/analyze PENDING 응답에는 포함되지 않음
  String? get platform => throw _privateConstructorUsedError;

  /// 처리 상태 (PENDING: 분석 중, COMPLETED: 분석 완료, FAILED: 실패)
  String get status => throw _privateConstructorUsedError;

  /// 플랫폼 업로더 (Instagram 계정명, YouTube 채널명 등)
  String? get platformUploader => throw _privateConstructorUsedError;

  /// 콘텐츠 캡션/설명
  String? get caption => throw _privateConstructorUsedError;

  /// 썸네일 이미지 URL
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// 원본 콘텐츠 URL
  String? get originalUrl => throw _privateConstructorUsedError;

  /// 콘텐츠 제목 (백엔드에서 생성)
  String? get title => throw _privateConstructorUsedError;

  /// 콘텐츠 요약 (백엔드에서 생성)
  String? get summary => throw _privateConstructorUsedError;

  /// 마지막 확인 시각
  DateTime? get lastCheckedAt => throw _privateConstructorUsedError;

  /// 생성 일시
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 수정 일시
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 생성자
  String get createdBy => throw _privateConstructorUsedError;

  /// 수정자
  String get updatedBy => throw _privateConstructorUsedError;

  /// 추출된 장소 목록
  List<PlaceModel> get places => throw _privateConstructorUsedError;

  /// 추가 메타데이터 (확장용)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ContentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentModelCopyWith<ContentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentModelCopyWith<$Res> {
  factory $ContentModelCopyWith(
    ContentModel value,
    $Res Function(ContentModel) then,
  ) = _$ContentModelCopyWithImpl<$Res, ContentModel>;
  @useResult
  $Res call({
    @JsonKey(readValue: _readContentId) String contentId,
    String? memberId,
    String? platform,
    String status,
    String? platformUploader,
    String? caption,
    String? thumbnailUrl,
    String? originalUrl,
    String? title,
    String? summary,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String createdBy,
    String updatedBy,
    List<PlaceModel> places,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$ContentModelCopyWithImpl<$Res, $Val extends ContentModel>
    implements $ContentModelCopyWith<$Res> {
  _$ContentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? memberId = freezed,
    Object? platform = freezed,
    Object? status = null,
    Object? platformUploader = freezed,
    Object? caption = freezed,
    Object? thumbnailUrl = freezed,
    Object? originalUrl = freezed,
    Object? title = freezed,
    Object? summary = freezed,
    Object? lastCheckedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = null,
    Object? updatedBy = null,
    Object? places = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            contentId: null == contentId
                ? _value.contentId
                : contentId // ignore: cast_nullable_to_non_nullable
                      as String,
            memberId: freezed == memberId
                ? _value.memberId
                : memberId // ignore: cast_nullable_to_non_nullable
                      as String?,
            platform: freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            platformUploader: freezed == platformUploader
                ? _value.platformUploader
                : platformUploader // ignore: cast_nullable_to_non_nullable
                      as String?,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalUrl: freezed == originalUrl
                ? _value.originalUrl
                : originalUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastCheckedAt: freezed == lastCheckedAt
                ? _value.lastCheckedAt
                : lastCheckedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
            places: null == places
                ? _value.places
                : places // ignore: cast_nullable_to_non_nullable
                      as List<PlaceModel>,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContentModelImplCopyWith<$Res>
    implements $ContentModelCopyWith<$Res> {
  factory _$$ContentModelImplCopyWith(
    _$ContentModelImpl value,
    $Res Function(_$ContentModelImpl) then,
  ) = __$$ContentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(readValue: _readContentId) String contentId,
    String? memberId,
    String? platform,
    String status,
    String? platformUploader,
    String? caption,
    String? thumbnailUrl,
    String? originalUrl,
    String? title,
    String? summary,
    DateTime? lastCheckedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String createdBy,
    String updatedBy,
    List<PlaceModel> places,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$ContentModelImplCopyWithImpl<$Res>
    extends _$ContentModelCopyWithImpl<$Res, _$ContentModelImpl>
    implements _$$ContentModelImplCopyWith<$Res> {
  __$$ContentModelImplCopyWithImpl(
    _$ContentModelImpl _value,
    $Res Function(_$ContentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? memberId = freezed,
    Object? platform = freezed,
    Object? status = null,
    Object? platformUploader = freezed,
    Object? caption = freezed,
    Object? thumbnailUrl = freezed,
    Object? originalUrl = freezed,
    Object? title = freezed,
    Object? summary = freezed,
    Object? lastCheckedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = null,
    Object? updatedBy = null,
    Object? places = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$ContentModelImpl(
        contentId: null == contentId
            ? _value.contentId
            : contentId // ignore: cast_nullable_to_non_nullable
                  as String,
        memberId: freezed == memberId
            ? _value.memberId
            : memberId // ignore: cast_nullable_to_non_nullable
                  as String?,
        platform: freezed == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        platformUploader: freezed == platformUploader
            ? _value.platformUploader
            : platformUploader // ignore: cast_nullable_to_non_nullable
                  as String?,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalUrl: freezed == originalUrl
            ? _value.originalUrl
            : originalUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastCheckedAt: freezed == lastCheckedAt
            ? _value.lastCheckedAt
            : lastCheckedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
        places: null == places
            ? _value._places
            : places // ignore: cast_nullable_to_non_nullable
                  as List<PlaceModel>,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentModelImpl implements _ContentModel {
  const _$ContentModelImpl({
    @JsonKey(readValue: _readContentId) required this.contentId,
    this.memberId,
    this.platform,
    this.status = 'PENDING',
    this.platformUploader,
    this.caption,
    this.thumbnailUrl,
    this.originalUrl,
    this.title,
    this.summary,
    this.lastCheckedAt,
    this.createdAt,
    this.updatedAt,
    this.createdBy = 'system',
    this.updatedBy = 'system',
    final List<PlaceModel> places = const [],
    final Map<String, dynamic>? metadata,
  }) : _places = places,
       _metadata = metadata;

  factory _$ContentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentModelImplFromJson(json);

  /// 콘텐츠 고유 ID
  /// - POST /api/content/analyze: "contentId" 필드 사용
  /// - 일부 API: "id" 필드 사용
  /// readValue로 "contentId" 또는 "id" 둘 다 처리
  @override
  @JsonKey(readValue: _readContentId)
  final String contentId;

  /// 회원 ID (백엔드 응답용, 프론트엔드에서는 미사용)
  /// POST /api/content/analyze PENDING 응답: "memberId": null
  @override
  final String? memberId;

  /// 플랫폼 (INSTAGRAM, YOUTUBE, TIKTOK 등)
  /// POST /api/content/analyze PENDING 응답에는 포함되지 않음
  @override
  final String? platform;

  /// 처리 상태 (PENDING: 분석 중, COMPLETED: 분석 완료, FAILED: 실패)
  @override
  @JsonKey()
  final String status;

  /// 플랫폼 업로더 (Instagram 계정명, YouTube 채널명 등)
  @override
  final String? platformUploader;

  /// 콘텐츠 캡션/설명
  @override
  final String? caption;

  /// 썸네일 이미지 URL
  @override
  final String? thumbnailUrl;

  /// 원본 콘텐츠 URL
  @override
  final String? originalUrl;

  /// 콘텐츠 제목 (백엔드에서 생성)
  @override
  final String? title;

  /// 콘텐츠 요약 (백엔드에서 생성)
  @override
  final String? summary;

  /// 마지막 확인 시각
  @override
  final DateTime? lastCheckedAt;

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

  /// 추출된 장소 목록
  final List<PlaceModel> _places;

  /// 추출된 장소 목록
  @override
  @JsonKey()
  List<PlaceModel> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  /// 추가 메타데이터 (확장용)
  final Map<String, dynamic>? _metadata;

  /// 추가 메타데이터 (확장용)
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ContentModel(contentId: $contentId, memberId: $memberId, platform: $platform, status: $status, platformUploader: $platformUploader, caption: $caption, thumbnailUrl: $thumbnailUrl, originalUrl: $originalUrl, title: $title, summary: $summary, lastCheckedAt: $lastCheckedAt, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, places: $places, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentModelImpl &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.platformUploader, platformUploader) ||
                other.platformUploader == platformUploader) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.originalUrl, originalUrl) ||
                other.originalUrl == originalUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.lastCheckedAt, lastCheckedAt) ||
                other.lastCheckedAt == lastCheckedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    contentId,
    memberId,
    platform,
    status,
    platformUploader,
    caption,
    thumbnailUrl,
    originalUrl,
    title,
    summary,
    lastCheckedAt,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
    const DeepCollectionEquality().hash(_places),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentModelImplCopyWith<_$ContentModelImpl> get copyWith =>
      __$$ContentModelImplCopyWithImpl<_$ContentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentModelImplToJson(this);
  }
}

abstract class _ContentModel implements ContentModel {
  const factory _ContentModel({
    @JsonKey(readValue: _readContentId) required final String contentId,
    final String? memberId,
    final String? platform,
    final String status,
    final String? platformUploader,
    final String? caption,
    final String? thumbnailUrl,
    final String? originalUrl,
    final String? title,
    final String? summary,
    final DateTime? lastCheckedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String createdBy,
    final String updatedBy,
    final List<PlaceModel> places,
    final Map<String, dynamic>? metadata,
  }) = _$ContentModelImpl;

  factory _ContentModel.fromJson(Map<String, dynamic> json) =
      _$ContentModelImpl.fromJson;

  /// 콘텐츠 고유 ID
  /// - POST /api/content/analyze: "contentId" 필드 사용
  /// - 일부 API: "id" 필드 사용
  /// readValue로 "contentId" 또는 "id" 둘 다 처리
  @override
  @JsonKey(readValue: _readContentId)
  String get contentId;

  /// 회원 ID (백엔드 응답용, 프론트엔드에서는 미사용)
  /// POST /api/content/analyze PENDING 응답: "memberId": null
  @override
  String? get memberId;

  /// 플랫폼 (INSTAGRAM, YOUTUBE, TIKTOK 등)
  /// POST /api/content/analyze PENDING 응답에는 포함되지 않음
  @override
  String? get platform;

  /// 처리 상태 (PENDING: 분석 중, COMPLETED: 분석 완료, FAILED: 실패)
  @override
  String get status;

  /// 플랫폼 업로더 (Instagram 계정명, YouTube 채널명 등)
  @override
  String? get platformUploader;

  /// 콘텐츠 캡션/설명
  @override
  String? get caption;

  /// 썸네일 이미지 URL
  @override
  String? get thumbnailUrl;

  /// 원본 콘텐츠 URL
  @override
  String? get originalUrl;

  /// 콘텐츠 제목 (백엔드에서 생성)
  @override
  String? get title;

  /// 콘텐츠 요약 (백엔드에서 생성)
  @override
  String? get summary;

  /// 마지막 확인 시각
  @override
  DateTime? get lastCheckedAt;

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

  /// 추출된 장소 목록
  @override
  List<PlaceModel> get places;

  /// 추가 메타데이터 (확장용)
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentModelImplCopyWith<_$ContentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

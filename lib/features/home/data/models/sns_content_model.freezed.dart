// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sns_content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SnsContent _$SnsContentFromJson(Map<String, dynamic> json) {
  return _SnsContent.fromJson(json);
}

/// @nodoc
mixin _$SnsContent {
  /// 콘텐츠 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 콘텐츠 제목
  String get title => throw _privateConstructorUsedError;

  /// 썸네일 이미지 URL
  String get thumbnailUrl => throw _privateConstructorUsedError;

  /// 콘텐츠 출처 (YouTube, Instagram 등)
  SnsSource get source => throw _privateConstructorUsedError;

  /// 원본 콘텐츠 URL
  String get contentUrl => throw _privateConstructorUsedError;

  /// 생성자 이름 (예: 채널명, 인스타그램 사용자명)
  String get creatorName => throw _privateConstructorUsedError;

  /// 조회수 (YouTube) 또는 좋아요 수 (Instagram)
  int get viewCount => throw _privateConstructorUsedError;

  /// 콘텐츠 생성 날짜
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 콘텐츠 타입 (비디오, 이미지, 릴스 등)
  ContentType get type => throw _privateConstructorUsedError;

  /// Serializes this SnsContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SnsContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnsContentCopyWith<SnsContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnsContentCopyWith<$Res> {
  factory $SnsContentCopyWith(
    SnsContent value,
    $Res Function(SnsContent) then,
  ) = _$SnsContentCopyWithImpl<$Res, SnsContent>;
  @useResult
  $Res call({
    String id,
    String title,
    String thumbnailUrl,
    SnsSource source,
    String contentUrl,
    String creatorName,
    int viewCount,
    DateTime createdAt,
    ContentType type,
  });
}

/// @nodoc
class _$SnsContentCopyWithImpl<$Res, $Val extends SnsContent>
    implements $SnsContentCopyWith<$Res> {
  _$SnsContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SnsContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? thumbnailUrl = null,
    Object? source = null,
    Object? contentUrl = null,
    Object? creatorName = null,
    Object? viewCount = null,
    Object? createdAt = null,
    Object? type = null,
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
            thumbnailUrl: null == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as SnsSource,
            contentUrl: null == contentUrl
                ? _value.contentUrl
                : contentUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            creatorName: null == creatorName
                ? _value.creatorName
                : creatorName // ignore: cast_nullable_to_non_nullable
                      as String,
            viewCount: null == viewCount
                ? _value.viewCount
                : viewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ContentType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SnsContentImplCopyWith<$Res>
    implements $SnsContentCopyWith<$Res> {
  factory _$$SnsContentImplCopyWith(
    _$SnsContentImpl value,
    $Res Function(_$SnsContentImpl) then,
  ) = __$$SnsContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String thumbnailUrl,
    SnsSource source,
    String contentUrl,
    String creatorName,
    int viewCount,
    DateTime createdAt,
    ContentType type,
  });
}

/// @nodoc
class __$$SnsContentImplCopyWithImpl<$Res>
    extends _$SnsContentCopyWithImpl<$Res, _$SnsContentImpl>
    implements _$$SnsContentImplCopyWith<$Res> {
  __$$SnsContentImplCopyWithImpl(
    _$SnsContentImpl _value,
    $Res Function(_$SnsContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SnsContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? thumbnailUrl = null,
    Object? source = null,
    Object? contentUrl = null,
    Object? creatorName = null,
    Object? viewCount = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      _$SnsContentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: null == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as SnsSource,
        contentUrl: null == contentUrl
            ? _value.contentUrl
            : contentUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        creatorName: null == creatorName
            ? _value.creatorName
            : creatorName // ignore: cast_nullable_to_non_nullable
                  as String,
        viewCount: null == viewCount
            ? _value.viewCount
            : viewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ContentType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SnsContentImpl extends _SnsContent {
  const _$SnsContentImpl({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.source,
    required this.contentUrl,
    required this.creatorName,
    required this.viewCount,
    required this.createdAt,
    required this.type,
  }) : super._();

  factory _$SnsContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnsContentImplFromJson(json);

  /// 콘텐츠 고유 ID
  @override
  final String id;

  /// 콘텐츠 제목
  @override
  final String title;

  /// 썸네일 이미지 URL
  @override
  final String thumbnailUrl;

  /// 콘텐츠 출처 (YouTube, Instagram 등)
  @override
  final SnsSource source;

  /// 원본 콘텐츠 URL
  @override
  final String contentUrl;

  /// 생성자 이름 (예: 채널명, 인스타그램 사용자명)
  @override
  final String creatorName;

  /// 조회수 (YouTube) 또는 좋아요 수 (Instagram)
  @override
  final int viewCount;

  /// 콘텐츠 생성 날짜
  @override
  final DateTime createdAt;

  /// 콘텐츠 타입 (비디오, 이미지, 릴스 등)
  @override
  final ContentType type;

  @override
  String toString() {
    return 'SnsContent(id: $id, title: $title, thumbnailUrl: $thumbnailUrl, source: $source, contentUrl: $contentUrl, creatorName: $creatorName, viewCount: $viewCount, createdAt: $createdAt, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnsContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.contentUrl, contentUrl) ||
                other.contentUrl == contentUrl) &&
            (identical(other.creatorName, creatorName) ||
                other.creatorName == creatorName) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    thumbnailUrl,
    source,
    contentUrl,
    creatorName,
    viewCount,
    createdAt,
    type,
  );

  /// Create a copy of SnsContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnsContentImplCopyWith<_$SnsContentImpl> get copyWith =>
      __$$SnsContentImplCopyWithImpl<_$SnsContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnsContentImplToJson(this);
  }
}

abstract class _SnsContent extends SnsContent {
  const factory _SnsContent({
    required final String id,
    required final String title,
    required final String thumbnailUrl,
    required final SnsSource source,
    required final String contentUrl,
    required final String creatorName,
    required final int viewCount,
    required final DateTime createdAt,
    required final ContentType type,
  }) = _$SnsContentImpl;
  const _SnsContent._() : super._();

  factory _SnsContent.fromJson(Map<String, dynamic> json) =
      _$SnsContentImpl.fromJson;

  /// 콘텐츠 고유 ID
  @override
  String get id;

  /// 콘텐츠 제목
  @override
  String get title;

  /// 썸네일 이미지 URL
  @override
  String get thumbnailUrl;

  /// 콘텐츠 출처 (YouTube, Instagram 등)
  @override
  SnsSource get source;

  /// 원본 콘텐츠 URL
  @override
  String get contentUrl;

  /// 생성자 이름 (예: 채널명, 인스타그램 사용자명)
  @override
  String get creatorName;

  /// 조회수 (YouTube) 또는 좋아요 수 (Instagram)
  @override
  int get viewCount;

  /// 콘텐츠 생성 날짜
  @override
  DateTime get createdAt;

  /// 콘텐츠 타입 (비디오, 이미지, 릴스 등)
  @override
  ContentType get type;

  /// Create a copy of SnsContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnsContentImplCopyWith<_$SnsContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PolicyModel _$PolicyModelFromJson(Map<String, dynamic> json) {
  return _PolicyModel.fromJson(json);
}

/// @nodoc
mixin _$PolicyModel {
  /// 약관 제목 (예: "서비스 이용약관")
  String get title => throw _privateConstructorUsedError;

  /// 약관 버전 (예: "1.0")
  String get version => throw _privateConstructorUsedError;

  /// 최종 수정일 (예: "2024-01-01")
  String get lastUpdated => throw _privateConstructorUsedError;

  /// 약관 섹션 목록
  List<PolicySection> get sections => throw _privateConstructorUsedError;

  /// Serializes this PolicyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PolicyModelCopyWith<PolicyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyModelCopyWith<$Res> {
  factory $PolicyModelCopyWith(
    PolicyModel value,
    $Res Function(PolicyModel) then,
  ) = _$PolicyModelCopyWithImpl<$Res, PolicyModel>;
  @useResult
  $Res call({
    String title,
    String version,
    String lastUpdated,
    List<PolicySection> sections,
  });
}

/// @nodoc
class _$PolicyModelCopyWithImpl<$Res, $Val extends PolicyModel>
    implements $PolicyModelCopyWith<$Res> {
  _$PolicyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? version = null,
    Object? lastUpdated = null,
    Object? sections = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as String,
            sections: null == sections
                ? _value.sections
                : sections // ignore: cast_nullable_to_non_nullable
                      as List<PolicySection>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PolicyModelImplCopyWith<$Res>
    implements $PolicyModelCopyWith<$Res> {
  factory _$$PolicyModelImplCopyWith(
    _$PolicyModelImpl value,
    $Res Function(_$PolicyModelImpl) then,
  ) = __$$PolicyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String version,
    String lastUpdated,
    List<PolicySection> sections,
  });
}

/// @nodoc
class __$$PolicyModelImplCopyWithImpl<$Res>
    extends _$PolicyModelCopyWithImpl<$Res, _$PolicyModelImpl>
    implements _$$PolicyModelImplCopyWith<$Res> {
  __$$PolicyModelImplCopyWithImpl(
    _$PolicyModelImpl _value,
    $Res Function(_$PolicyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? version = null,
    Object? lastUpdated = null,
    Object? sections = null,
  }) {
    return _then(
      _$PolicyModelImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as String,
        sections: null == sections
            ? _value._sections
            : sections // ignore: cast_nullable_to_non_nullable
                  as List<PolicySection>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicyModelImpl implements _PolicyModel {
  const _$PolicyModelImpl({
    required this.title,
    required this.version,
    required this.lastUpdated,
    required final List<PolicySection> sections,
  }) : _sections = sections;

  factory _$PolicyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicyModelImplFromJson(json);

  /// 약관 제목 (예: "서비스 이용약관")
  @override
  final String title;

  /// 약관 버전 (예: "1.0")
  @override
  final String version;

  /// 최종 수정일 (예: "2024-01-01")
  @override
  final String lastUpdated;

  /// 약관 섹션 목록
  final List<PolicySection> _sections;

  /// 약관 섹션 목록
  @override
  List<PolicySection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  String toString() {
    return 'PolicyModel(title: $title, version: $version, lastUpdated: $lastUpdated, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicyModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    version,
    lastUpdated,
    const DeepCollectionEquality().hash(_sections),
  );

  /// Create a copy of PolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PolicyModelImplCopyWith<_$PolicyModelImpl> get copyWith =>
      __$$PolicyModelImplCopyWithImpl<_$PolicyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicyModelImplToJson(this);
  }
}

abstract class _PolicyModel implements PolicyModel {
  const factory _PolicyModel({
    required final String title,
    required final String version,
    required final String lastUpdated,
    required final List<PolicySection> sections,
  }) = _$PolicyModelImpl;

  factory _PolicyModel.fromJson(Map<String, dynamic> json) =
      _$PolicyModelImpl.fromJson;

  /// 약관 제목 (예: "서비스 이용약관")
  @override
  String get title;

  /// 약관 버전 (예: "1.0")
  @override
  String get version;

  /// 최종 수정일 (예: "2024-01-01")
  @override
  String get lastUpdated;

  /// 약관 섹션 목록
  @override
  List<PolicySection> get sections;

  /// Create a copy of PolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicyModelImplCopyWith<_$PolicyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PolicySection _$PolicySectionFromJson(Map<String, dynamic> json) {
  return _PolicySection.fromJson(json);
}

/// @nodoc
mixin _$PolicySection {
  /// 섹션 제목 (예: "제1조 (목적)")
  String get heading => throw _privateConstructorUsedError;

  /// 섹션 내용
  String get content => throw _privateConstructorUsedError;

  /// Serializes this PolicySection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PolicySection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PolicySectionCopyWith<PolicySection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicySectionCopyWith<$Res> {
  factory $PolicySectionCopyWith(
    PolicySection value,
    $Res Function(PolicySection) then,
  ) = _$PolicySectionCopyWithImpl<$Res, PolicySection>;
  @useResult
  $Res call({String heading, String content});
}

/// @nodoc
class _$PolicySectionCopyWithImpl<$Res, $Val extends PolicySection>
    implements $PolicySectionCopyWith<$Res> {
  _$PolicySectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PolicySection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? heading = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            heading: null == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PolicySectionImplCopyWith<$Res>
    implements $PolicySectionCopyWith<$Res> {
  factory _$$PolicySectionImplCopyWith(
    _$PolicySectionImpl value,
    $Res Function(_$PolicySectionImpl) then,
  ) = __$$PolicySectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String heading, String content});
}

/// @nodoc
class __$$PolicySectionImplCopyWithImpl<$Res>
    extends _$PolicySectionCopyWithImpl<$Res, _$PolicySectionImpl>
    implements _$$PolicySectionImplCopyWith<$Res> {
  __$$PolicySectionImplCopyWithImpl(
    _$PolicySectionImpl _value,
    $Res Function(_$PolicySectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PolicySection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? heading = null, Object? content = null}) {
    return _then(
      _$PolicySectionImpl(
        heading: null == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PolicySectionImpl implements _PolicySection {
  const _$PolicySectionImpl({required this.heading, required this.content});

  factory _$PolicySectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PolicySectionImplFromJson(json);

  /// 섹션 제목 (예: "제1조 (목적)")
  @override
  final String heading;

  /// 섹션 내용
  @override
  final String content;

  @override
  String toString() {
    return 'PolicySection(heading: $heading, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolicySectionImpl &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heading, content);

  /// Create a copy of PolicySection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PolicySectionImplCopyWith<_$PolicySectionImpl> get copyWith =>
      __$$PolicySectionImplCopyWithImpl<_$PolicySectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PolicySectionImplToJson(this);
  }
}

abstract class _PolicySection implements PolicySection {
  const factory _PolicySection({
    required final String heading,
    required final String content,
  }) = _$PolicySectionImpl;

  factory _PolicySection.fromJson(Map<String, dynamic> json) =
      _$PolicySectionImpl.fromJson;

  /// 섹션 제목 (예: "제1조 (목적)")
  @override
  String get heading;

  /// 섹션 내용
  @override
  String get content;

  /// Create a copy of PolicySection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolicySectionImplCopyWith<_$PolicySectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

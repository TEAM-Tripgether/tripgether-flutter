import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

/// 온보딩 전용 텍스트 입력 필드
///
/// 특징:
/// - 배경 투명
/// - 하단 언더라인만 표시 (연한 색상)
/// - 포커스 시 언더라인 색상 진하게
/// - 가운데 정렬 텍스트
/// - 깔끔하고 미니멀한 디자인
///
/// 사용 예시:
/// ```dart
/// OnboardingTextField(
///   controller: _controller,
///   hintText: '닉네임을 입력하세요',
///   maxLength: 10,
/// )
/// ```
class OnboardingTextField extends StatelessWidget {
  /// 텍스트 입력 컨트롤러
  final TextEditingController? controller;

  /// 포커스 노드
  final FocusNode? focusNode;

  /// 힌트 텍스트
  final String? hintText;

  /// 최대 입력 길이 (null이면 무제한)
  final int? maxLength;

  /// 텍스트 정렬 (기본값: 가운데)
  final TextAlign textAlign;

  /// 키보드 타입
  final TextInputType? keyboardType;

  /// 텍스트 스타일
  final TextStyle? style;

  /// 입력 포맷터 (예: 숫자만 입력)
  final List<TextInputFormatter>? inputFormatters;

  /// 값 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 제출 콜백 (엔터 키)
  final VoidCallback? onSubmitted;

  /// 너비 (null이면 부모 크기에 맞춤)
  final double? width;

  /// 활성화 여부
  final bool enabled;

  /// 읽기 전용 여부
  final bool readOnly;

  const OnboardingTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.maxLength,
    this.textAlign = TextAlign.center,
    this.keyboardType,
    this.style,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.width,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // 기본 텍스트 스타일 (사용자 지정이 없으면)
    final defaultStyle =
        style ??
        textTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        );

    Widget textField = TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      maxLength: maxLength,
      textAlign: textAlign,
      keyboardType: keyboardType,
      style: defaultStyle,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        counterText: '', // 글자 수 카운터 숨김
        filled: false, // 배경 투명
        contentPadding: EdgeInsets.only(bottom: 8.h),
        // 기본 상태 (활성화) - 사용자가 입력 필드를 쉽게 찾을 수 있도록 적절한 명암비
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outline, // 적절히 보이는 색상
            width: 1.5.w,
          ),
        ),
        // 포커스 상태
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.6), // Primary 색상 사용
            width: 2.w,
          ),
        ),
        // 비활성화 상태
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.1),
            width: 1.w,
          ),
        ),
        // 에러 상태 (향후 확장 가능)
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error.withValues(alpha: 0.5),
            width: 1.5.w,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2.w),
        ),
      ),
    );

    // 너비가 지정된 경우 SizedBox로 감싸기
    if (width != null) {
      return SizedBox(width: width, child: textField);
    }

    return textField;
  }
}

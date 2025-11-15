import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Tripgether 앱의 공용 다이얼로그 컴포넌트
///
/// **디자인 스펙**:
/// - 크기: 콘텐츠 + 패딩 기반 자동 조정
/// - 마진: 좌우/상하 40px (insetPadding, huge)
/// - 패딩: top 24, left/right/bottom 16
/// - Radius: 8px (medium)
/// - 배경: 흰색
///
/// **콘텐츠 구조**:
/// - 제목 (titleSemiBold18)
/// - ↓ 24px 간격
/// - 설명 (medium14)
/// - ↓ 8px 간격
/// - 서브 설명 (medium12, subColor2) - 선택 사항
/// - ↓ 24px 간격
/// - 버튼 행 (왼쪽: 취소, 오른쪽: 액션)
///
/// **사용 예시**:
/// ```dart
/// // 삭제 확인 다이얼로그
/// showDialog(
///   context: context,
///   builder: (context) => CommonDialog.forDelete(
///     title: '장소를 삭제하시겠습니까?',
///     description: '삭제된 장소는 복구할 수 없습니다.',
///     onConfirm: () => _deletePlace(),
///   ),
/// );
///
/// // 오류 제보 다이얼로그
/// showDialog(
///   context: context,
///   builder: (context) => CommonDialog.forError(
///     title: '오류가 발생했습니다',
///     description: '네트워크 연결을 확인해주세요.',
///     subtitle: '오류 코드: 500',
///   ),
/// );
///
/// // 확인 다이얼로그
/// showDialog(
///   context: context,
///   builder: (context) => CommonDialog.forConfirm(
///     title: '변경사항을 저장하시겠습니까?',
///     description: '저장하지 않으면 변경사항이 사라집니다.',
///     onConfirm: () => _saveChanges(),
///   ),
/// );
/// ```
class CommonDialog extends StatelessWidget {
  /// 다이얼로그 제목 (필수)
  final String title;

  /// 메인 설명 텍스트 (필수)
  final String description;

  /// 부가 설명 텍스트 (선택 사항)
  /// 예: 오류 코드, 추가 안내 등
  final String? subtitle;

  /// 왼쪽 버튼 텍스트
  /// null이면 버튼 숨김
  final String? leftButtonText;

  /// 오른쪽 버튼 텍스트
  /// null이면 버튼 숨김
  final String? rightButtonText;

  /// 왼쪽 버튼 눌렀을 때 콜백
  final VoidCallback? onLeftPressed;

  /// 오른쪽 버튼 눌렀을 때 콜백
  final VoidCallback? onRightPressed;

  /// 오른쪽 버튼 배경색
  /// 기본값: AppColors.redAccent (삭제 작업)
  final Color? rightButtonColor;

  /// 오른쪽 버튼 텍스트 색상
  /// 기본값: AppColors.white
  final Color? rightButtonTextColor;

  /// 왼쪽 버튼 배경색
  /// 기본값: AppColors.subColor2
  final Color? leftButtonColor;

  /// 왼쪽 버튼 텍스트 색상
  /// 기본값: AppColors.textColor1
  final Color? leftButtonTextColor;

  /// 다이얼로그를 자동으로 닫을지 여부
  /// true면 버튼 누를 때 자동으로 Navigator.pop 호출
  /// 기본값: true
  final bool autoDismiss;

  const CommonDialog({
    super.key,
    required this.title,
    required this.description,
    this.subtitle,
    this.leftButtonText,
    this.rightButtonText,
    this.onLeftPressed,
    this.onRightPressed,
    this.rightButtonColor,
    this.rightButtonTextColor,
    this.leftButtonColor,
    this.leftButtonTextColor,
    this.autoDismiss = true,
  });

  /// 삭제 확인 다이얼로그 생성
  ///
  /// **특징**:
  /// - 오른쪽 버튼: 빨간색 (redAccent) "삭제" 버튼
  /// - 왼쪽 버튼: 회색 (subColor2) "취소" 버튼
  ///
  /// **사용 예시**:
  /// ```dart
  /// showDialog(
  ///   context: context,
  ///   builder: (context) => CommonDialog.forDelete(
  ///     title: '장소를 삭제하시겠습니까?',
  ///     description: '삭제된 장소는 복구할 수 없습니다.',
  ///     subtitle: '연관된 코스도 함께 삭제됩니다.',
  ///     onConfirm: () => _deletePlace(),
  ///   ),
  /// );
  /// ```
  factory CommonDialog.forDelete({
    required String title,
    required String description,
    String? subtitle,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = '삭제',
    String cancelText = '취소',
    bool autoDismiss = true,
  }) {
    return CommonDialog(
      title: title,
      description: description,
      subtitle: subtitle,
      leftButtonText: cancelText,
      rightButtonText: confirmText,
      onLeftPressed: onCancel,
      onRightPressed: onConfirm,
      rightButtonColor: AppColors.redAccent,
      rightButtonTextColor: AppColors.white,
      autoDismiss: autoDismiss,
    );
  }

  /// 오류 제보 다이얼로그 생성
  ///
  /// **특징**:
  /// - 단일 "확인" 버튼만 표시
  /// - 오류 코드나 추가 정보를 subtitle로 표시
  ///
  /// **사용 예시**:
  /// ```dart
  /// showDialog(
  ///   context: context,
  ///   builder: (context) => CommonDialog.forError(
  ///     title: '오류가 발생했습니다',
  ///     description: '네트워크 연결을 확인해주세요.',
  ///     subtitle: '오류 코드: 500',
  ///   ),
  /// );
  /// ```
  factory CommonDialog.forError({
    required String title,
    required String description,
    String? subtitle,
    VoidCallback? onConfirm,
    String confirmText = '확인',
    Color? confirmButtonColor,
    bool autoDismiss = true,
  }) {
    return CommonDialog(
      title: title,
      description: description,
      subtitle: subtitle,
      leftButtonText: null, // 왼쪽 버튼 숨김
      rightButtonText: confirmText,
      onRightPressed: onConfirm,
      rightButtonColor: confirmButtonColor ?? AppColors.mainColor,
      rightButtonTextColor: AppColors.white,
      autoDismiss: autoDismiss,
    );
  }

  /// 일반 확인 다이얼로그 생성
  ///
  /// **특징**:
  /// - 오른쪽 버튼: 메인 컬러 "확인" 버튼
  /// - 왼쪽 버튼: 회색 "취소" 버튼
  ///
  /// **사용 예시**:
  /// ```dart
  /// showDialog(
  ///   context: context,
  ///   builder: (context) => CommonDialog.forConfirm(
  ///     title: '변경사항을 저장하시겠습니까?',
  ///     description: '저장하지 않으면 변경사항이 사라집니다.',
  ///     onConfirm: () => _saveChanges(),
  ///   ),
  /// );
  /// ```
  factory CommonDialog.forConfirm({
    required String title,
    required String description,
    String? subtitle,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = '확인',
    String cancelText = '취소',
    bool autoDismiss = true,
  }) {
    return CommonDialog(
      title: title,
      description: description,
      subtitle: subtitle,
      leftButtonText: cancelText,
      rightButtonText: confirmText,
      onLeftPressed: onCancel,
      onRightPressed: onConfirm,
      rightButtonColor: AppColors.mainColor,
      rightButtonTextColor: AppColors.white,
      autoDismiss: autoDismiss,
    );
  }

  /// 성공 알림 다이얼로그 생성
  ///
  /// **특징**:
  /// - 단일 "확인" 버튼만 표시
  /// - 성공 색상 (success) 사용
  ///
  /// **사용 예시**:
  /// ```dart
  /// showDialog(
  ///   context: context,
  ///   builder: (context) => CommonDialog.forSuccess(
  ///     title: '저장 완료',
  ///     description: '변경사항이 성공적으로 저장되었습니다.',
  ///   ),
  /// );
  /// ```
  factory CommonDialog.forSuccess({
    required String title,
    required String description,
    String? subtitle,
    VoidCallback? onConfirm,
    String confirmText = '확인',
    bool autoDismiss = true,
  }) {
    return CommonDialog(
      title: title,
      description: description,
      subtitle: subtitle,
      leftButtonText: null, // 왼쪽 버튼 숨김
      rightButtonText: confirmText,
      onRightPressed: onConfirm,
      rightButtonColor: AppColors.success,
      rightButtonTextColor: AppColors.white,
      autoDismiss: autoDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMedium, // 8px
      ),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.huge, // 40
        vertical: AppSpacing.huge, // 40
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: AppSpacing.xxl,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 제목
            Text(
              title,
              style: AppTextStyles.titleSemiBold18,
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceXXL, // 24px
            // 메인 설명
            Text(
              description,
              style: AppTextStyles.bodyMedium14,
              textAlign: TextAlign.center,
            ),

            // 서브 설명 (선택 사항)
            if (subtitle != null) ...[
              AppSpacing.verticalSpaceSM, // 8px
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium12.copyWith(
                  color: AppColors.subColor2,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            AppSpacing.verticalSpaceXXL, // 24px
            // 버튼 행
            _buildButtonRow(context),
          ],
        ),
      ),
    );
  }

  /// 버튼 행 빌드
  Widget _buildButtonRow(BuildContext context) {
    // 왼쪽 버튼만 있는 경우
    if (leftButtonText != null && rightButtonText == null) {
      return _buildButton(
        context: context,
        text: leftButtonText!,
        backgroundColor:
            leftButtonColor ?? AppColors.subColor2.withValues(alpha: 0.2),
        textColor: leftButtonTextColor ?? AppColors.textColor1,
        onPressed: onLeftPressed,
        isExpanded: true,
      );
    }

    // 오른쪽 버튼만 있는 경우
    if (rightButtonText != null && leftButtonText == null) {
      return _buildButton(
        context: context,
        text: rightButtonText!,
        backgroundColor: rightButtonColor ?? AppColors.redAccent,
        textColor: rightButtonTextColor ?? AppColors.white,
        onPressed: onRightPressed,
        isExpanded: true,
      );
    }

    // 양쪽 버튼 모두 있는 경우
    if (leftButtonText != null && rightButtonText != null) {
      return Row(
        children: [
          // 왼쪽 버튼 (취소)
          Expanded(
            child: _buildButton(
              context: context,
              text: leftButtonText!,
              backgroundColor:
                  leftButtonColor ?? AppColors.subColor2.withValues(alpha: 0.2),
              textColor: leftButtonTextColor ?? AppColors.textColor1,
              onPressed: onLeftPressed,
            ),
          ),

          AppSpacing.horizontalSpaceSM, // 8px
          // 오른쪽 버튼 (액션)
          Expanded(
            child: _buildButton(
              context: context,
              text: rightButtonText!,
              backgroundColor: rightButtonColor ?? AppColors.redAccent,
              textColor: rightButtonTextColor ?? AppColors.white,
              onPressed: onRightPressed,
            ),
          ),
        ],
      );
    }

    // 버튼이 하나도 없는 경우 (빈 Container)
    return const SizedBox.shrink();
  }

  /// 개별 버튼 빌드
  Widget _buildButton({
    required BuildContext context,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback? onPressed,
    bool isExpanded = false,
  }) {
    final button = ElevatedButton(
      onPressed: () {
        // 콜백 실행
        onPressed?.call();

        // 자동으로 다이얼로그 닫기
        if (autoDismiss) {
          Navigator.of(context).pop();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allMedium, // 8px
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium16.copyWith(color: textColor),
      ),
    );

    return isExpanded ? button : Expanded(child: button);
  }
}

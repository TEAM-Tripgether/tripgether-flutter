import 'package:flutter/cupertino.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';

/// 토글 스위치가 있는 마이페이지 메뉴 아이템 위젯
///
/// **디자인 스펙**:
/// - 텍스트: textColor1 (#130537), bodyMedium16
/// - 토글: CupertinoSwitch (iOS 스타일)
///
/// **사용 예시**:
/// ```dart
/// ToggleMenuItem(
///   title: '푸시 알림',
///   value: _isPushEnabled,
///   onChanged: (value) => setState(() => _isPushEnabled = value),
/// )
/// ```
class ToggleMenuItem extends StatelessWidget {
  const ToggleMenuItem({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  /// 메뉴 항목 제목
  final String title;

  /// 토글 상태 (true: 켜짐, false: 꺼짐)
  final bool value;

  /// 토글 상태 변경 콜백
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 메뉴 제목 (textColor1, bodyMedium16)
          Text(
            title,
            style: AppTextStyles.bodyMedium16.copyWith(
              color: AppColors.textColor1,
            ),
          ),

          // iOS 스타일 토글 스위치
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.mainColor,
            inactiveTrackColor: AppColors.subColor2.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

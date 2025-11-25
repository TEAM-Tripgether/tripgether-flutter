import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 저장 폴더 선택 다이얼로그
///
/// 장소를 저장할 폴더를 선택하는 다이얼로그입니다.
/// "전체 저장하기" 옵션이 기본 선택되어 있으며,
/// 사용자가 특정 폴더를 선택하거나 새 폴더를 생성할 수 있습니다.
///
/// **사용 예시**:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => FolderSelectionDialog(
///     onSave: (folderId) {
///       // folderId가 null이면 "전체 저장하기"
///       _savePlace(folderId);
///     },
///     onCreateFolder: () {
///       // 새 폴더 생성 화면으로 이동
///     },
///   ),
/// );
/// ```
class FolderSelectionDialog extends StatefulWidget {
  /// 저장 버튼 클릭 시 콜백
  /// [folderId]가 null이면 "전체 저장하기" 선택
  final void Function(String? folderId) onSave;

  /// 새 폴더 만들기 클릭 시 콜백
  final VoidCallback? onCreateFolder;

  const FolderSelectionDialog({
    super.key,
    required this.onSave,
    this.onCreateFolder,
  });

  @override
  State<FolderSelectionDialog> createState() => _FolderSelectionDialogState();
}

class _FolderSelectionDialogState extends State<FolderSelectionDialog> {
  /// 선택된 폴더 ID (null이면 "전체 저장하기")
  /// 현재는 폴더 API가 없으므로 항상 null (전체 저장하기만 선택 가능)
  String? _selectedFolderId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMedium,
      ),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.huge,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm),
              child: Text(
                '저장 폴더 선택',
                style: AppTextStyles.titleBold24,
              ),
            ),

            AppSpacing.verticalSpaceXXL,

            // "전체 저장하기" 옵션
            _buildRadioOption(
              id: null,
              title: '전체 저장하기',
              subtitle: null,
            ),

            AppSpacing.verticalSpaceMD,

            // 구분선
            Divider(
              thickness: AppSizes.borderThin,
              height: AppSizes.borderThin,
              color: AppColors.subColor2.withValues(alpha: 0.3),
            ),

            AppSpacing.verticalSpaceLG,

            // TODO: 폴더 API 연동 후 폴더 리스트 추가 예정
            // 현재는 "전체 저장하기"만 선택 가능

            AppSpacing.verticalSpaceLG,

            // 버튼 행
            _buildButtonRow(context),
          ],
        ),
      ),
    );
  }

  /// 라디오 옵션 빌드
  Widget _buildRadioOption({
    required String? id,
    required String title,
    required String? subtitle,
  }) {
    final isSelected = _selectedFolderId == id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFolderId = id;
        });
      },
      borderRadius: AppRadius.allSmall,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // 폴더명 + 부제목
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSemiBold16,
                  ),
                  if (subtitle != null) ...[
                    AppSpacing.horizontalSpaceMD,
                    Expanded(
                      child: Text(
                        subtitle,
                        style: AppTextStyles.bodyRegular14.copyWith(
                          color: AppColors.subColor2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 라디오 버튼
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.mainColor : AppColors.subColor2,
                  width: isSelected ? 6.w : 2.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 버튼 행 빌드
  Widget _buildButtonRow(BuildContext context) {
    return Row(
      children: [
        // 닫기 버튼
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.subColor2.withValues(alpha: 0.2),
              foregroundColor: AppColors.textColor1,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allSmall,
              ),
            ),
            child: Text(
              '닫기',
              style: AppTextStyles.bodyMedium16.copyWith(
                color: AppColors.textColor1,
              ),
            ),
          ),
        ),

        AppSpacing.horizontalSpaceSM,

        // 저장하기 버튼
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onSave(_selectedFolderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              foregroundColor: AppColors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allSmall,
              ),
            ),
            child: Text(
              '저장하기',
              style: AppTextStyles.bodyMedium16.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
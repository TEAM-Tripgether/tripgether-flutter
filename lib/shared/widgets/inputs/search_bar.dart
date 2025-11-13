import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

/// 홈 화면 검색창 위젯
///
/// 키워드, 도시, 장소를 검색할 수 있는 검색창
/// 클릭 시 검색 화면으로 이동하거나 직접 검색 가능
/// 텍스트 입력 시 X 아이콘이 나타나 입력 내용을 지울 수 있음
class TripSearchBar extends StatefulWidget {
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;

  const TripSearchBar({
    super.key,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.hintText = '키워드·도시·장소를 검색해 보세요',
    this.readOnly = false,
    this.autofocus = false,
    this.controller,
  });

  @override
  State<TripSearchBar> createState() => _TripSearchBarState();
}

class _TripSearchBarState extends State<TripSearchBar> {
  late TextEditingController _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _clearText() {
    _effectiveController.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      builder: (context, value, child) {
        final hasText = value.text.isNotEmpty;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.circle),
            border: Border.all(
              color: AppColors.subColor2,
              width: AppSizes.borderThin,
            ),
          ),
          child: Row(
            children: [
              // 검색 아이콘 (공간 유지하며 투명도 조절)
              Opacity(
                opacity: hasText ? 0.0 : 1.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search,
                      size: AppSizes.iconMedium,
                      color: AppColors.subColor2,
                    ),
                    SizedBox(width: AppSpacing.md),
                  ],
                ),
              ),

              // 텍스트 입력 필드
              Expanded(
                child: TextField(
                  controller: _effectiveController,
                  readOnly: widget.readOnly,
                  autofocus: widget.autofocus,
                  onTap: widget.onTap,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.metaMedium12,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.metaMedium12.copyWith(
                      color: AppColors.subColor2,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.search,
                ),
              ),

              // 지우기 버튼 (텍스트 있을 때만)
              if (hasText) ...[
                SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: _clearText,
                  child: Icon(
                    Icons.clear,
                    size: AppSizes.iconSmall,
                    color: AppColors.subColor2,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

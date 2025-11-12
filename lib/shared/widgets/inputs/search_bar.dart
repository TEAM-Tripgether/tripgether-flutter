import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);

    return Container(
      height: AppSizes.fabSmallSize,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.circular(24),
        border: Border.all(
          color: AppColors.subColor2,
          width: AppSizes.borderThin,
        ),
      ),
      child: TextField(
        controller: _effectiveController,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textAlign: TextAlign.left,
        style: AppTextStyles.metaMedium12,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.metaMedium12.copyWith(
            color: AppColors.subColor2,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: AppSizes.iconMedium,
            color: AppColors.subColor2,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _effectiveController,
            builder: (context, value, child) {
              return value.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: AppSizes.iconSmall,
                        color: AppColors.subColor2,
                      ),
                      onPressed: _clearText,
                      tooltip: l10n.clearInput,
                    )
                  : const SizedBox.shrink();
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md.h,
          ),
          filled: false,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

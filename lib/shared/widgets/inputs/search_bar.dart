import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

/// 홈 화면 검색창 위젯
///
/// 키워드, 도시, 장소를 검색할 수 있는 검색창
/// 클릭 시 검색 화면으로 이동하거나 직접 검색 가능
/// 텍스트 입력 시 X 아이콘이 나타나 입력 내용을 지울 수 있음
class TripSearchBar extends StatefulWidget {
  /// 검색창 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 검색 텍스트 변경 시 콜백
  final ValueChanged<String>? onChanged;

  /// 검색 제출 시 콜백
  final ValueChanged<String>? onSubmitted;

  /// 검색창 힌트 텍스트
  final String hintText;

  /// 읽기 전용 모드 (true면 탭만 가능)
  final bool readOnly;

  /// 자동 포커스 여부
  final bool autofocus;

  /// 텍스트 컨트롤러 (외부에서 관리하는 경우)
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
  /// 내부 텍스트 컨트롤러 (외부에서 제공하지 않은 경우)
  late TextEditingController _internalController;

  /// 실제 사용할 컨트롤러 (외부 또는 내부)
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  /// 텍스트가 있는지 여부 (X 아이콘 표시 제어)
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    // 외부에서 컨트롤러를 제공하지 않은 경우 내부 컨트롤러 생성
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    // 텍스트 변경 리스너 추가
    _effectiveController.addListener(_onTextChanged);
    // 초기 텍스트 상태 확인
    _hasText = _effectiveController.text.isNotEmpty;
  }

  @override
  void dispose() {
    // 리스너 제거
    _effectiveController.removeListener(_onTextChanged);
    // 내부 컨트롤러만 dispose (외부 컨트롤러는 외부에서 관리)
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  /// 텍스트 변경 시 X 아이콘 표시 여부 업데이트
  void _onTextChanged() {
    final hasText = _effectiveController.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  /// X 아이콘 클릭 시 텍스트 지우기
  void _clearText() {
    _effectiveController.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: AppRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!, width: AppSizes.borderThin),
      ),
      child: TextField(
        controller: _effectiveController,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(Icons.search, size: AppSizes.iconMedium, color: Colors.grey[600]),
          // 텍스트가 있을 때만 X 아이콘 표시 (동적으로 업데이트, 국제화 적용)
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(Icons.clear, size: AppSizes.iconSmall, color: Colors.grey[600]),
                  onPressed: _clearText,
                  tooltip: l10n.clearInput,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md.h,
          ),
          // 기본 InputDecoration 테마 오버라이드
          filled: false,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

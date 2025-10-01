import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 홈 화면 검색창 위젯
///
/// 키워드, 도시, 장소를 검색할 수 있는 검색창
/// 클릭 시 검색 화면으로 이동하거나 직접 검색 가능
class TripSearchBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        autofocus: autofocus,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20.w,
            color: Colors.grey[600],
          ),
          // 검색 내용이 있을 때만 clear 버튼 표시
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 18.w,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    controller!.clear();
                    onChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
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
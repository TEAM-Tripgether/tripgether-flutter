import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 섹션 구분선 위젯
///
/// 두 가지 스타일의 구분선을 제공:
/// 1. 얇은 라인 구분선 (thin)
/// 2. 두꺼운 배경 영역 구분선 (thick)
class SectionDivider extends StatelessWidget {
  /// 구분선 타입
  final SectionDividerType type;

  /// 좌우 패딩 (thin 타입에만 적용)
  final double? horizontalPadding;

  /// 높이 (thick 타입에만 적용)
  final double? height;

  /// 색상 (커스텀 색상 지정 시)
  final Color? color;

  const SectionDivider({
    super.key,
    this.type = SectionDividerType.thin,
    this.horizontalPadding,
    this.height,
    this.color,
  });

  /// 얇은 라인 구분선 생성자
  const SectionDivider.thin({super.key, this.horizontalPadding, this.color})
    : type = SectionDividerType.thin,
      height = null;

  /// 두꺼운 배경 구분선 생성자
  const SectionDivider.thick({super.key, this.height, this.color})
    : type = SectionDividerType.thick,
      horizontalPadding = null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SectionDividerType.thin:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16.w),
          child: Divider(
            thickness: 1,
            height: 1,
            color: color ?? Colors.grey[300],
          ),
        );

      case SectionDividerType.thick:
        return Container(
          height: height ?? 8.h,
          color: color ?? Colors.grey[100],
        );
    }
  }
}

/// 섹션 구분선 타입
enum SectionDividerType {
  /// 얇은 라인 구분선
  thin,

  /// 두꺼운 배경 영역 구분선
  thick,
}

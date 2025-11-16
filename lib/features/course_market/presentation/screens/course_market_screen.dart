import 'package:flutter/material.dart';
import 'package:tripgether/core/theme/app_colors.dart';

/// 코스마켓 화면
///
/// TODO: 실제 코스마켓 기능 구현 예정
class CourseMarketScreen extends StatelessWidget {
  const CourseMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: const Center(child: Text('코스마켓 화면')),
    );
  }
}

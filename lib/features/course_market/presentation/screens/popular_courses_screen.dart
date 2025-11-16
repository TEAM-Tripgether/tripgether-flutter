import 'package:flutter/material.dart';
import 'package:tripgether/core/theme/app_colors.dart';

/// 인기 코스 화면
class PopularCoursesScreen extends StatelessWidget {
  const PopularCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('인기 코스')),
      body: const Center(child: Text('인기 코스 화면')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tripgether/core/theme/app_colors.dart';

/// 코스 검색 화면
class CourseSearchScreen extends StatelessWidget {
  const CourseSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('코스 검색')),
      body: const Center(
        child: Text('코스 검색 화면'),
      ),
    );
  }
}

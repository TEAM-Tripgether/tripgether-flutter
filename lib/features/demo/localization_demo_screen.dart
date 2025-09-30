import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_strings.dart';

/// 국제화 기능을 테스트하고 데모하는 화면
///
/// 이 화면은 앱의 국제화 설정이 올바르게 작동하는지 확인하고,
/// 개발자들이 국제화 기능을 어떻게 사용하는지 예시를 보여줍니다.
class LocalizationDemoScreen extends StatelessWidget {
  const LocalizationDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 언어 정보 가져오기
    final currentLanguage = AppStrings.getCurrentLanguageCode(context);
    final isKorean = AppStrings.isKorean(context);
    final isEnglish = AppStrings.isEnglish(context);

    return Scaffold(
      appBar: AppBar(
        // 국제화된 앱 제목 사용
        title: Text(AppStrings.of(context).appTitle),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // 언어 정보 섹션
            // ============================
            _buildLanguageInfoCard(context, currentLanguage, isKorean, isEnglish),

            SizedBox(height: 24.h),

            // ============================
            // 네비게이션 라벨 섹션
            // ============================
            _buildNavigationLabelsCard(context),

            SizedBox(height: 24.h),

            // ============================
            // 공통 버튼 섹션
            // ============================
            _buildCommonButtonsCard(context),

            SizedBox(height: 24.h),

            // ============================
            // 상태 메시지 섹션
            // ============================
            _buildStatusMessagesCard(context),

            SizedBox(height: 24.h),

            // ============================
            // 여행 관련 섹션
            // ============================
            _buildTripRelatedCard(context),

            SizedBox(height: 24.h),

            // ============================
            // 날짜/시간 포맷 섹션
            // ============================
            _buildDateTimeFormatsCard(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 언어 변경 다이얼로그 표시 (실제 구현은 추후)
          _showLanguageChangeDialog(context);
        },
        child: const Icon(Icons.language),
        tooltip: isKorean ? '언어 변경' : 'Change Language',
      ),
    );
  }

  /// 언어 정보를 표시하는 카드 위젯
  Widget _buildLanguageInfoCard(BuildContext context, String currentLanguage,
      bool isKorean, bool isEnglish) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isKorean ? '🌍 현재 언어 정보' : '🌍 Current Language Info',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow('Language Code', currentLanguage),
            _buildInfoRow('Is Korean', isKorean.toString()),
            _buildInfoRow('Is English', isEnglish.toString()),
            _buildInfoRow('Date Format', AppStrings.getDateFormat(context)),
            _buildInfoRow('Time Format', AppStrings.getTimeFormat(context)),
          ],
        ),
      ),
    );
  }

  /// 네비게이션 라벨들을 표시하는 카드 위젯
  Widget _buildNavigationLabelsCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.isKorean(context) ? '🧭 네비게이션 라벨' : '🧭 Navigation Labels',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildLabelChip(context, AppStrings.of(context).navHome),
                _buildLabelChip(context, AppStrings.of(context).navMap),
                _buildLabelChip(context, AppStrings.of(context).navSchedule),
                _buildLabelChip(context, AppStrings.of(context).navCourseMarket),
                _buildLabelChip(context, AppStrings.of(context).navMyPage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 공통 버튼들을 표시하는 카드 위젯
  Widget _buildCommonButtonsCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.isKorean(context) ? '🔘 공통 버튼' : '🔘 Common Buttons',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppStrings.of(context).btnConfirm),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppStrings.of(context).btnCancel),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppStrings.of(context).btnSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 상태 메시지들을 표시하는 카드 위젯
  Widget _buildStatusMessagesCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.isKorean(context) ? '📢 상태 메시지' : '📢 Status Messages',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            _buildStatusRow(context, '💫', AppStrings.of(context).loading),
            _buildStatusRow(context, '📊', AppStrings.of(context).loadingData),
            _buildStatusRow(context, '📭', AppStrings.of(context).noData),
            _buildStatusRow(context, '🌐', AppStrings.of(context).networkError),
          ],
        ),
      ),
    );
  }

  /// 여행 관련 용어들을 표시하는 카드 위젯
  Widget _buildTripRelatedCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.isKorean(context) ? '✈️ 여행 관련' : '✈️ Trip Related',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow('Trip (Single)', AppStrings.of(context).trip),
            _buildInfoRow('Trips (Plural)', AppStrings.of(context).trips),
            _buildInfoRow('My Trips', AppStrings.of(context).myTrips),
            _buildInfoRow('Create Trip', AppStrings.of(context).createTrip),
            _buildInfoRow('Schedule', AppStrings.of(context).schedule),
            _buildInfoRow('Add Schedule', AppStrings.of(context).addSchedule),
          ],
        ),
      ),
    );
  }

  /// 날짜/시간 포맷을 표시하는 카드 위젯
  Widget _buildDateTimeFormatsCard(BuildContext context) {
    final now = DateTime.now();

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.isKorean(context) ? '📅 날짜/시간 포맷' : '📅 Date/Time Formats',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow('Date Format Pattern', AppStrings.getDateFormat(context)),
            _buildInfoRow('Time Format Pattern', AppStrings.getTimeFormat(context)),
            _buildInfoRow('Current Date Example',
              AppStrings.isKorean(context)
                ? '${now.year}년 ${now.month}월 ${now.day}일'
                : '${_getMonthName(now.month)} ${now.day}, ${now.year}'
            ),
            _buildInfoRow('Current Time Example',
              AppStrings.isKorean(context)
                ? '${now.hour > 12 ? '오후' : '오전'} ${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')}'
                : '${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}'
            ),
          ],
        ),
      ),
    );
  }

  /// 정보 행을 생성하는 헬퍼 메서드
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 상태 메시지 행을 생성하는 헬퍼 메서드
  Widget _buildStatusRow(BuildContext context, String icon, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 라벨 칩을 생성하는 헬퍼 메서드
  Widget _buildLabelChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Pretendard',
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      side: BorderSide(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
      ),
    );
  }

  /// 언어 변경 다이얼로그 표시 (향후 구현 예정)
  void _showLanguageChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppStrings.isKorean(context) ? '언어 변경' : 'Change Language',
          style: TextStyle(fontFamily: 'Pretendard'),
        ),
        content: Text(
          AppStrings.isKorean(context)
            ? '언어 변경 기능은 추후 구현될 예정입니다.\n현재는 시스템 언어 설정을 따릅니다.'
            : 'Language change feature will be implemented later.\nCurrently follows system language settings.',
          style: TextStyle(fontFamily: 'Pretendard'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.of(context).btnConfirm,
              style: TextStyle(fontFamily: 'Pretendard'),
            ),
          ),
        ],
      ),
    );
  }

  /// 월 이름을 반환하는 헬퍼 메서드
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
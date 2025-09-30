import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 마이페이지 화면 - PRD.md 구조에 따른 features/mypage/presentation/screens 위치
///
/// 사용자 프로필, 내 코스, 설정 등 개인 정보 관리를 제공하는 메인 화면
class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: 설정 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('설정 화면으로 이동')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 프로필 헤더
            _buildProfileHeader(context),
            SizedBox(height: 24.h),

            // 내 통계
            _buildMyStats(context),
            SizedBox(height: 24.h),

            // 메뉴 리스트
            _buildMenuList(context),
          ],
        ),
      ),
    );
  }

  /// 프로필 헤더 구성
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
            Theme.of(context).primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 40.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40.w,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 12.h),

          // 사용자 이름
          Text(
            '여행러버',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Pretendard',
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),

          // 사용자 이메일
          Text(
            'traveler@example.com',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Pretendard',
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 16.h),

          // 프로필 편집 버튼
          ElevatedButton(
            onPressed: () {
              // TODO: 프로필 편집 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프로필 편집 화면으로 이동')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              '프로필 편집',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 내 통계 구성
  Widget _buildMyStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.place,
            title: '저장한 장소',
            count: '24',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.route,
            title: '구매한 코스',
            count: '7',
            color: Colors.green,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.event,
            title: '완료한 여행',
            count: '12',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  /// 통계 카드
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(height: 8.h),
          Text(
            count,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Pretendard',
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 메뉴 리스트 구성
  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuSection(
          context,
          title: '내 저장소',
          items: [
            MenuItemData(
              icon: Icons.bookmark,
              title: '저장한 장소',
              subtitle: '내가 저장한 모든 장소',
              onTap: () => _showFeatureComingSoon(context, '저장한 장소'),
            ),
            MenuItemData(
              icon: Icons.shopping_bag,
              title: '구매한 코스',
              subtitle: '구매한 여행 코스 목록',
              onTap: () => _showFeatureComingSoon(context, '구매한 코스'),
            ),
            MenuItemData(
              icon: Icons.history,
              title: '여행 기록',
              subtitle: '완료된 여행의 추억들',
              onTap: () => _showFeatureComingSoon(context, '여행 기록'),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _buildMenuSection(
          context,
          title: '앱 설정',
          items: [
            MenuItemData(
              icon: Icons.notifications,
              title: '알림 설정',
              subtitle: '푸시 알림 및 이메일 설정',
              onTap: () => _showFeatureComingSoon(context, '알림 설정'),
            ),
            MenuItemData(
              icon: Icons.language,
              title: '언어 설정',
              subtitle: '앱 언어 변경',
              onTap: () => _showFeatureComingSoon(context, '언어 설정'),
            ),
            MenuItemData(
              icon: Icons.dark_mode,
              title: '테마 설정',
              subtitle: '라이트/다크 모드 설정',
              onTap: () => _showFeatureComingSoon(context, '테마 설정'),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _buildMenuSection(
          context,
          title: '지원',
          items: [
            MenuItemData(
              icon: Icons.help_outline,
              title: '도움말',
              subtitle: '앱 사용법 및 FAQ',
              onTap: () => _showFeatureComingSoon(context, '도움말'),
            ),
            MenuItemData(
              icon: Icons.feedback,
              title: '문의하기',
              subtitle: '개선사항 및 버그 신고',
              onTap: () => _showFeatureComingSoon(context, '문의하기'),
            ),
            MenuItemData(
              icon: Icons.info_outline,
              title: '앱 정보',
              subtitle: '버전 정보 및 라이선스',
              onTap: () => _showFeatureComingSoon(context, '앱 정보'),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _buildLogoutButton(context),
      ],
    );
  }

  /// 메뉴 섹션
  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<MenuItemData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  _buildMenuItem(context, item),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                      indent: 56.w,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 개별 메뉴 아이템
  Widget _buildMenuItem(BuildContext context, MenuItemData item) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          item.icon,
          color: Theme.of(context).primaryColor,
          size: 20.w,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Pretendard',
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 20.w,
      ),
      onTap: item.onTap,
    );
  }

  /// 로그아웃 버튼
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _showLogoutDialog(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  /// 기능 준비 중 메시지 표시
  void _showFeatureComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature 기능은 곧 출시될 예정입니다!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// 로그아웃 확인 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '로그아웃',
            style: TextStyle(fontFamily: 'Pretendard'),
          ),
          content: Text(
            '정말 로그아웃하시겠어요?',
            style: TextStyle(fontFamily: 'Pretendard'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃되었습니다')),
                );
              },
              child: Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 메뉴 아이템 데이터 클래스
class MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
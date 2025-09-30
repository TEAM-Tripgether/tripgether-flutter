import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import '../../../../core/services/sharing_service.dart';

/// 홈 화면 - PRD.md 구조에 따른 features/home/presentation/screens 위치
///
/// 최근 저장된 장소와 추천 코스를 표시하는 메인 화면
/// 기존 공유 서비스 기능이 포함되어 있습니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  SharedData? _currentSharedData;
  bool _isInitialized = false;
  StreamSubscription<SharedData>? _sharingSubscription;

  @override
  void initState() {
    super.initState();
    debugPrint('[HomeScreen] initState 시작');

    // 앱 라이프사이클 관찰자 등록
    WidgetsBinding.instance.addObserver(this);

    _initializeSharing();
  }

  /// 공유 서비스 초기화 및 스트림 구독
  Future<void> _initializeSharing() async {
    try {
      debugPrint('[HomeScreen] 공유 서비스 초기화 시작');

      // SharingService 초기화
      await SharingService.instance.initialize();

      // 공유 데이터 스트림 구독
      _sharingSubscription = SharingService.instance.dataStream.listen(
        (SharedData data) {
          debugPrint('[HomeScreen] 공유 데이터 수신됨: ${data.toString()}');

          if (mounted) {
            setState(() {
              _currentSharedData = data;
            });

            // 공유 데이터 수신 시 사용자에게 알림 표시
            _showSharedDataNotification(data);
          }
        },
        onError: (error) {
          debugPrint('[HomeScreen] 공유 스트림 오류: $error');
        },
      );

      setState(() {
        _isInitialized = true;
      });
      debugPrint('[HomeScreen] 공유 서비스 초기화 완료');
    } catch (error) {
      debugPrint('[HomeScreen] 공유 서비스 초기화 오류: $error');
    }
  }

  @override
  void dispose() {
    debugPrint('[HomeScreen] dispose 호출');

    // 앱 라이프사이클 관찰자 해제
    WidgetsBinding.instance.removeObserver(this);

    _sharingSubscription?.cancel();
    SharingService.instance.dispose();
    super.dispose();
  }

  /// 앱 라이프사이클 상태 변화 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('[HomeScreen] 앱 라이프사이클 변경: $state');

    // 앱이 백그라운드에서 포그라운드로 돌아올 때 데이터 확인
    if (state == AppLifecycleState.resumed) {
      debugPrint('[HomeScreen] 앱이 포그라운드로 복귀 - 공유 데이터 확인');
      _checkForNewData();
    }
  }

  /// 새로운 공유 데이터 확인
  Future<void> _checkForNewData() async {
    try {
      await SharingService.instance.checkForData();
    } catch (error) {
      debugPrint('[HomeScreen] 데이터 확인 오류: $error');
    }
  }

  /// 공유 데이터 수신 시 사용자 알림 표시
  void _showSharedDataNotification(SharedData data) {
    if (!mounted) return;

    String message = _getSharedDataMessage(data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 공유된 데이터 타입에 따른 메시지 생성
  String _getSharedDataMessage(SharedData data) {
    if (data.hasTextData && data.hasMediaData) {
      return '텍스트 ${data.sharedTexts.length}개와 파일 ${data.sharedFiles.length}개가 공유되었습니다!';
    } else if (data.hasTextData) {
      return data.sharedTexts.length == 1 ? '텍스트가 공유되었습니다!' : '텍스트 ${data.sharedTexts.length}개가 공유되었습니다!';
    } else if (data.hasMediaData) {
      return data.sharedFiles.length == 1 ? '파일이 공유되었습니다!' : '파일 ${data.sharedFiles.length}개가 공유되었습니다!';
    }
    return '컨텐츠가 공유되었습니다!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TripTogether',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  /// 메인 화면 구성
  Widget _buildBody() {
    // 초기화 중일 때 로딩 표시
    if (!_isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              '서비스 초기화 중...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _checkForNewData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공유 데이터 섹션 (있는 경우에만 표시)
            if (_currentSharedData != null && _currentSharedData!.hasData) ...[
              _buildSharedDataSection(),
              SizedBox(height: 24.h),
            ],

            // 홈 메인 섹션들
            _buildWelcomeSection(),
            SizedBox(height: 24.h),

            _buildRecentPlacesSection(),
            SizedBox(height: 24.h),

            _buildRecommendedCoursesSection(),
            SizedBox(height: 24.h),

            _buildQuickActionsSection(),
          ],
        ),
      ),
    );
  }

  /// 공유 데이터 섹션
  Widget _buildSharedDataSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.share, color: Colors.blue, size: 20.w),
                SizedBox(width: 8.w),
                Text(
                  '공유된 콘텐츠',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              '새로운 콘텐츠가 공유되었습니다. 여행 계획에 추가하시겠어요?',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 여행 계획에 추가 로직
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('여행 계획에 추가됨')),
                      );
                    },
                    child: Text('추가하기'),
                  ),
                ),
                SizedBox(width: 8.w),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentSharedData = null;
                    });
                  },
                  child: Text('나중에'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 환영 섹션
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안녕하세요! 👋',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '오늘은 어떤 여행을 계획해볼까요?',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
            fontFamily: 'Pretendard',
          ),
        ),
      ],
    );
  }

  /// 최근 저장된 장소 섹션
  Widget _buildRecentPlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 저장한 장소',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // 임시 개수
            itemBuilder: (context, index) {
              return Container(
                width: 200.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '장소 ${index + 1}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 추천 코스 섹션
  Widget _buildRecommendedCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 추천 코스',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3, // 임시 개수
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '추천 코스 ${index + 1}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '코스 설명이 들어갑니다.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// 빠른 액션 섹션
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 실행',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.map,
                label: '지도 보기',
                onTap: () {
                  // TODO: 지도 탭으로 이동
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.schedule,
                label: '일정 추가',
                onTap: () {
                  // TODO: 일정 탭으로 이동
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 빠른 액션 버튼
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.w,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
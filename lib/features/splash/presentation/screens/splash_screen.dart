import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';

/// 스플래시 화면 위젯
///
/// 브랜드 로고와 함께 복잡한 텍스트 애니메이션을 표시하는 스플래시 화면입니다.
/// 애니메이션 시퀀스:
/// 1. "Trip"이 왼쪽에서 등장
/// 2. "Together"가 오른쪽에서 등장
/// 3. "Together"가 "Trip" 아래로 이동하면서 "To"만 남김
/// 4. 최종적으로 "Tripgether" 완성
/// 5. 로고와 슬로건 이미지가 페이드 인
/// 6. 3초 후 홈 화면으로 자동 이동
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// 애니메이션 컨트롤러들
  late AnimationController _mainController;
  late AnimationController _logoController;

  /// 애니메이션 객체들
  late Animation<Offset> _tripSlideAnimation;
  late Animation<Offset> _togetherSlideAnimation;
  late Animation<Offset> _togetherMoveDownAnimation;
  late Animation<double> _tripOpacityAnimation;
  late Animation<double> _togetherPartialOpacityAnimation;
  late Animation<double> _finalTextOpacityAnimation;
  late Animation<double> _logoOpacityAnimation;

  /// 애니메이션 상태 관리
  bool _showFinalText = false;
  bool _showImages = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  /// 애니메이션 컨트롤러와 애니메이션 객체들 초기화
  void _initializeAnimations() {
    // 메인 텍스트 애니메이션용 컨트롤러 (3초 동안)
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // 로고/슬로건 애니메이션용 컨트롤러 (1초 동안)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 1. "Trip" 왼쪽에서 슬라이드 인 (0-800ms)
    _tripSlideAnimation =
        Tween<Offset>(
          begin: const Offset(-2.0, 0.0), // 화면 왼쪽 바깥에서 시작
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.27, curve: Curves.easeOutCubic),
          ),
        );

    // 2. "Together" 오른쪽에서 슬라이드 인 (400-1200ms)
    _togetherSlideAnimation =
        Tween<Offset>(
          begin: const Offset(2.0, 0.0), // 화면 오른쪽 바깥에서 시작
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.13, 0.4, curve: Curves.easeOutCubic),
          ),
        );

    // 3. "Together" 아래로 이동 (1200-2000ms)
    _togetherMoveDownAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, 1.2), // 아래로 이동
        ).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.4, 0.67, curve: Curves.easeInOutCubic),
          ),
        );

    // 4. "Trip" 텍스트 페이드 아웃 (1800-2200ms)
    _tripOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.73, curve: Curves.easeInOut),
      ),
    );

    // 5. "Together"에서 "gether" 부분 페이드 아웃 (1800-2200ms)
    _togetherPartialOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.6, 0.73, curve: Curves.easeInOut),
          ),
        );

    // 6. 최종 "Tripgether" 텍스트 페이드 인 (2200-2800ms)
    _finalTextOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.73, 0.93, curve: Curves.easeInOut),
      ),
    );

    // 7. 로고와 슬로건 페이드 인
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  /// 애니메이션 시퀀스 시작
  void _startAnimationSequence() async {
    // 메인 텍스트 애니메이션 시작
    _mainController.forward();

    // 2.2초 후 최종 텍스트 표시
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      setState(() {
        _showFinalText = true;
      });
    }

    // 2.8초 후 이미지들 표시 및 로고 애니메이션 시작
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _showImages = true;
      });
      _logoController.forward();
    }

    // 총 5초 후 홈 화면으로 이동
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO(human): 배경색을 #664BAE로, 텍스트를 흰색으로 변경
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 상단 여백
              SizedBox(height: 100.h),

              // 로고 이미지 (조건부 표시)
              if (_showImages)
                FadeTransition(
                  opacity: _logoOpacityAnimation,
                  child: Image.asset(
                    'assets/logo_center.png',
                    height: 120.h,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48.w,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                )
              else
                SizedBox(height: 120.h), // 로고 공간 예약

              SizedBox(height: 40.h),

              // 텍스트 애니메이션 영역
              SizedBox(
                height: 120.h, // 텍스트 애니메이션을 위한 충분한 높이
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 최종 "Tripgether" 텍스트 (조건부 표시)
                    if (_showFinalText)
                      FadeTransition(
                        opacity: _finalTextOpacityAnimation,
                        child: Text(
                          'Tripgether',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2196F3),
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),

                    // 애니메이션 중인 "Trip" 텍스트
                    if (!_showFinalText)
                      SlideTransition(
                        position: _tripSlideAnimation,
                        child: FadeTransition(
                          opacity: _tripOpacityAnimation,
                          child: Text(
                            'Trip',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 42.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2196F3),
                              letterSpacing: -1.0,
                            ),
                          ),
                        ),
                      ),

                    // 애니메이션 중인 "Together" 텍스트
                    if (!_showFinalText)
                      SlideTransition(
                        position: _togetherSlideAnimation,
                        child: SlideTransition(
                          position: _togetherMoveDownAnimation,
                          child: Stack(
                            children: [
                              // 전체 "Together" 텍스트
                              Text(
                                'Together',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 42.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2196F3),
                                  letterSpacing: -1.0,
                                ),
                              ),
                              // "gether" 부분만 페이드 아웃되는 오버레이
                              FadeTransition(
                                opacity: _togetherPartialOpacityAnimation,
                                child: Text(
                                  'Together',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 42.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // 슬로건 이미지 (조건부 표시)
              if (_showImages)
                FadeTransition(
                  opacity: _logoOpacityAnimation,
                  child: Image.asset(
                    'assets/slogun.png',
                    height: 60.h,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 60.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            '슬로건',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                SizedBox(height: 60.h), // 슬로건 공간 예약
              // 하단 여백
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

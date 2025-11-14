import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/routes.dart';
import '../../../auth/providers/user_provider.dart';

/// Tripgether 앱의 스플래시 화면
///
/// **주요 기능**:
/// 1. 브랜드 로고 애니메이션 표시
/// 2. **세션 복원**: Secure Storage에서 저장된 사용자 정보를 자동으로 로드
/// 3. **자동 네비게이션**: 세션 상태에 따라 홈 또는 로그인 화면으로 자동 이동
///
/// **애니메이션 구성** (최적화됨 - 총 2.5초):
/// 1. 0-800ms: Trip(왼쪽)과 Together(오른쪽)가 천천히 중앙으로 이동하여 명확하게 합쳐짐
/// 2. 700-2200ms: Tripgether 로고와 텍스트가 부드럽게 페이드인 (합체 완료 직전부터 시작)
/// 3. 2500ms 후: 세션 상태에 따라 홈 또는 로그인 화면으로 자동 이동
///
/// **세션 복원 흐름**:
/// 1. UserNotifier.build() 자동 호출 (watch 트리거)
/// 2. Secure Storage에서 user_info, access_token, refresh_token 읽기
/// 3. AsyncValue 상태 변화:
///    - loading: 애니메이션 표시
///    - data(User): 홈 화면으로 자동 이동
///    - data(null): 로그인 화면으로 자동 이동
///    - error: 로그인 화면으로 자동 이동
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// 애니메이션 컨트롤러
  late AnimationController _controller;

  /// 애니메이션 시작 여부를 관리하는 플래그
  bool _isAnimationStarted = false;

  /// 네비게이션 완료 여부 (중복 네비게이션 방지)
  bool _navigationCompleted = false;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화 (총 1000ms 지속)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 화면이 빌드된 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 애니메이션을 시작하는 메서드
  ///
  /// 안드로이드 12+에서는 시스템 스플래시가 먼저 표시되므로
  /// 애니메이션 시작을 약간 지연시켜 자연스러운 전환을 만듭니다
  void _startAnimation() async {
    // 안드로이드 플랫폼에서만 지연 적용
    // 안드로이드 12+의 시스템 스플래시가 끝날 때까지 대기
    if (!kIsWeb && Platform.isAndroid) {
      // 500ms 지연: 시스템 스플래시가 표시되는 동안 대기
      await Future.delayed(const Duration(milliseconds: 500));
    }
    // iOS와 웹은 지연 없이 즉시 애니메이션 시작

    // 위젯이 아직 마운트되어 있는지 확인
    if (!mounted) return;

    // 애니메이션 시작
    setState(() {
      _isAnimationStarted = true;
    });
  }

  /// 세션 복원 완료 후 자동 네비게이션
  ///
  /// UserNotifier의 상태에 따라 적절한 화면으로 이동합니다.
  ///
  /// [hasUser] true: 사용자가 로그인되어 있음 (홈으로 이동)
  ///          false: 로그인 안 됨 (로그인 화면으로 이동)
  void _navigateAfterSessionRestore(bool hasUser) async {
    // 이미 네비게이션 완료되었으면 중복 실행 방지
    if (_navigationCompleted) return;

    // 애니메이션이 충분히 보이도록 최소 2.5초 대기
    // (애니메이션 총 시간: 700ms delay + 1500ms fadeIn = 2200ms)
    await Future.delayed(const Duration(milliseconds: 2500));

    // 위젯이 아직 마운트되어 있는지 확인
    if (!mounted) return;

    // 네비게이션 완료 플래그 설정 (중복 방지)
    _navigationCompleted = true;

    // 사용자 로그인 여부에 따라 자동 이동
    if (hasUser) {
      debugPrint('[SplashScreen] ✅ 세션 복원 완료 → 홈 화면으로 이동');
      context.go(AppRoutes.home);
    } else {
      debugPrint('[SplashScreen] ℹ️ 저장된 세션 없음 → 로그인 화면으로 이동');
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserNotifier를 watch하여 세션 복원 트리거 및 상태 감지
    final userState = ref.watch(userNotifierProvider);

    // 세션 복원 완료 시 자동 네비게이션
    // AsyncValue.when을 사용하여 상태별 처리
    userState.when(
      // 로딩 중: 아무 작업도 하지 않음 (애니메이션만 표시)
      loading: () {
        debugPrint('[SplashScreen] 🔄 세션 복원 중...');
      },
      // 데이터 로드 완료: 사용자 로그인 여부에 따라 자동 네비게이션
      data: (user) {
        // user가 null이 아니면 로그인된 상태
        final hasUser = user != null;

        // 애니메이션 완료 후 네비게이션 (중복 실행 방지)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateAfterSessionRestore(hasUser);
        });
      },
      // 에러 발생: 로그인 화면으로 이동
      error: (error, stack) {
        debugPrint('[SplashScreen] ❌ 세션 복원 실패: $error');

        // 에러 발생 시에도 로그인 화면으로 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateAfterSessionRestore(false);
        });
      },
    );

    return Scaffold(
      // 배경색: AppColors.mainColor (664BAE)
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Together 텍스트 (오른쪽에서 시작하여 절반 겹침 위치로 이동) - 맨 아래 레이어
              _buildTogetherText(),

              // Trip 텍스트 (왼쪽에서 시작) - Together 위에 그려져서 겹칠 때 Trip이 보임
              _buildTripText(),

              // 최종 로고, Tripgether 텍스트, 슬로건 (중앙, 처음엔 숨김) - 최상위
              _buildFinalLogo(),
            ],
          ),
        ),
      ),
    );
  }

  /// Trip 텍스트 위젯을 생성하는 메서드
  Widget _buildTripText() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child:
            Transform.translate(
                  // 왼쪽에서 시작하는 초기 위치
                  offset: Offset(-150.w, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainColor, // 스플래시 배경색과 동일하여 Together를 자연스럽게 가림
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text('Trip', style: AppTextStyles.splashLogoBold48),
                  ),
                )
                .animate(target: _isAnimationStarted ? 1 : 0)
                // 0-800ms: Trip이 왼쪽에서 중앙으로 이동 (천천히 명확하게)
                .moveX(
                  begin: 0,
                  end: 70.w, // 왼쪽에서 중앙으로 70.w만큼 이동
                  duration: 800.ms,
                  curve: Curves.easeOut,
                ),
      ),
    );
  }

  /// Together 텍스트 위젯을 생성하는 메서드
  Widget _buildTogetherText() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child:
            Transform.translate(
                  // 오른쪽에서 시작하는 초기 위치
                  offset: Offset(150.w, 0),
                  child: Text(
                    'Together',
                    style: AppTextStyles.splashLogoBold48,
                  ),
                )
                .animate(target: _isAnimationStarted ? 1 : 0)
                // 0-800ms: Together가 오른쪽에서 Trip과 절반 겹침 위치로 이동 (천천히 명확하게)
                .moveX(
                  begin: 0,
                  end: -130.w, // Trip과 절반 정도 겹치는 위치로 이동
                  duration: 800.ms,
                  curve: Curves.easeOut,
                ),
      ),
    );
  }

  /// 최종 로고, 텍스트, 슬로건을 함께 표시하는 위젯
  Widget _buildFinalLogo() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child:
          Stack(
                children: [
                  // 로고 이미지 (Tripgether 텍스트 위쪽에 배치)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, -80.h), // Tripgether 기준 위쪽으로
                        child: Image.asset(
                          'assets/splash/logo_center.png',
                          width: 120.w,
                          height: 120.h,
                        ),
                      ),
                    ),
                  ),
                  // Tripgether 텍스트 (정확히 화면 중앙)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        'Tripgether',
                        style: AppTextStyles.splashLogoBold48,
                      ),
                    ),
                  ),
                  // 슬로건 텍스트 (Tripgether 텍스트 아래쪽에 배치)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, 40.h), // Tripgether 기준 아래쪽으로
                        child: Text(
                          'More than tours. Real local moments',
                          style: AppTextStyles.splashSloganRegular12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate(target: _isAnimationStarted ? 1 : 0)
              // 700-2200ms: 로고, 텍스트, 슬로건 모두 함께 서서히 페이드인 (합체 후 자연스럽게)
              .fadeIn(
                delay: 700.ms,
                duration: 1500.ms,
                curve: Curves.easeInOut,
              ),
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/routes.dart';

/// Tripgether 앱의 스플래시 화면
///
/// Trip과 Together가 합쳐져서 Tripgether가 되는 브랜드 로고 애니메이션을 보여줍니다.
/// 4단계 애니메이션으로 구성:
/// 1. 초기 상태: Trip(위), Together(아래) 표시
/// 2. 접근 단계: Together가 위로 슬라이드하여 Trip 근처로 이동
/// 3. 합체 단계: Trip+Together 페이드아웃, Tripgether 페이드인
/// 4. 완성 단계: Tripgether 스케일 효과로 최종 정착
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// 애니메이션 컨트롤러
  late AnimationController _controller;

  /// 애니메이션 시작 여부를 관리하는 플래그
  bool _isAnimationStarted = false;

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
      // 700ms 지연: 시스템 스플래시가 표시되는 동안 대기
      await Future.delayed(const Duration(milliseconds: 500));
    }
    // iOS와 웹은 지연 없이 즉시 애니메이션 시작

    // 위젯이 아직 마운트되어 있는지 확인
    if (!mounted) return;

    // 애니메이션 시작
    setState(() {
      _isAnimationStarted = true;
    });

    // 애니메이션 완료 후 로그인 화면으로 자동 이동
    // 애니메이션 총 시간 2000ms + 여유 시간 800ms = 2800ms 후 이동
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        // 위젯이 아직 화면에 마운트되어 있는지 확인
        // 애니메이션 없이 즉시 로그인 화면으로 전환
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경색: AppColors.primary (664BAE)
      backgroundColor: AppColors.primary,
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
                      color: AppColors
                          .primary, // 스플래시 배경색과 동일하여 Together를 자연스럽게 가림
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Trip',
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                )
                .animate(target: _isAnimationStarted ? 1 : 0)
                // 0-800ms: Trip이 왼쪽에서 중앙으로 이동 (적당한 속도로)
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
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                      letterSpacing: 2.0,
                    ),
                  ),
                )
                .animate(target: _isAnimationStarted ? 1 : 0)
                // 0-800ms: Together가 오른쪽에서 Trip과 절반 겹침 위치로 이동 (적당한 속도로)
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
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                          letterSpacing: 2.0,
                        ),
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
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onPrimary.withValues(alpha: 0.8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate(target: _isAnimationStarted ? 1 : 0)
              // 800-2000ms: 로고, 텍스트, 슬로건 모두 함께 서서히 페이드인 (더욱 길고 부드럽게)
              .fadeIn(
                delay: 700.ms,
                duration: 1800.ms,
                curve: Curves.easeInOut,
              ),
    );
  }
}

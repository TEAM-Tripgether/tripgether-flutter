import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/errors/refresh_token_exception.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/token_error_handler.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cards/place_detail_card.dart';
import '../../../../shared/widgets/layout/section_header.dart';
import '../providers/content_provider.dart';

/// 최근 저장한 장소 섹션 위젯
///
/// 홈 화면에서 사용자가 최근에 저장한 장소를 표시하는 섹션입니다.
/// USE_MOCK_API 플래그에 따라 Mock 또는 실제 API 데이터를 자동으로 사용합니다.
class RecentSavedPlacesSection extends ConsumerWidget {
  const RecentSavedPlacesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final placesAsync = ref.watch(recentSavedPlacesProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 타이틀
          SectionHeader(
            title: l10n.recentSavedPlaces,
            onMoreTap: () {
              // 저장한 장소 전체 리스트 화면으로 이동
              context.push(AppRoutes.savedPlacesList);
            },
          ),

          AppSpacing.verticalSpaceXS,

          // 저장한 장소 리스트 (Riverpod AsyncValue 패턴)
          placesAsync.when(
            data: (places) {
              if (places.isEmpty) {
                return SizedBox(
                  height: 150.h,
                  child: Center(
                    child: Text(
                      l10n.noSavedPlacesYet,
                      style: AppTextStyles.titleSemiBold14.copyWith(
                        color: AppColors.subColor2,
                      ),
                    ),
                  ),
                );
              }

              // 홈 화면에서는 최대 3개만 표시
              final displayPlaces = places.take(3).toList();

              return Column(
                children: displayPlaces.map((place) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: PlaceDetailCard(
                      category: place.category ?? '장소',
                      placeName: place.name,
                      address: place.address,
                      rating: place.rating ?? 0.0,
                      reviewCount: place.userRatingsTotal ?? 0,
                      imageUrls: place.photoUrls,
                      backgroundColor: AppColors.backgroundLight,
                      onTap: () {
                        // 장소 상세 화면으로 이동
                        context.push(
                          AppRoutes.placeDetail.replaceAll(
                            ':placeId',
                            place.placeId,
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => SizedBox(
              height: 150.h,
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) {
              debugPrint('장소 데이터 로드 실패: $error');

              // RefreshTokenException (TOKEN_BLACKLISTED 포함) 처리
              if (error is RefreshTokenException) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await handleTokenError(context, ref, error);
                });
                // 에러 처리 중이므로 빈 Container 반환
                return const SizedBox.shrink();
              }

              // 일반 에러 표시
              return SizedBox(
                height: 150.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: AppSizes.iconLarge,
                      ),
                      AppSpacing.verticalSpaceXS,
                      Text(
                        '데이터를 불러올 수 없습니다',
                        style: AppTextStyles.caption12.copyWith(
                          color: AppColors.textColor1.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

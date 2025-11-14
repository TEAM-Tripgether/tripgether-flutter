import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
        right: AppSpacing.md,
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
              debugPrint('최근 저장한 장소 리스트 화면으로 이동');
            },
          ),

          AppSpacing.verticalSpaceMD,

          // 저장한 장소 리스트 (Riverpod AsyncValue 패턴)
          placesAsync.when(
            data: (places) {
              if (places.isEmpty) {
                return SizedBox(
                  height: 150.h,
                  child: Center(
                    child: Text(
                      l10n.noSavedPlacesYet,
                      style: AppTextStyles.contentTitle.copyWith(
                        color: AppColors.subColor2,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: places.map((place) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: PlaceDetailCard(
                      category: place.category ?? '장소',
                      placeName: place.name,
                      address: place.address,
                      rating: place.rating ?? 0.0,
                      reviewCount: place.userRatingsTotal ?? 0,
                      imageUrls: place.photoUrls,
                      onTap: () {
                        debugPrint('장소 상세 화면으로 이동: ${place.placeId}');
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

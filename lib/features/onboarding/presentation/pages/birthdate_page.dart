import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/inputs/onboarding_text_field.dart';
import '../../../../shared/utils/date_input_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/onboarding_layout.dart';

/// 생년월일 입력 페이지 (STEP 3/5)
///
/// **개선된 입력 방식**:
/// - 단일 TextField로 YYYY / MM / DD 형식 자동 포맷팅
/// - DateInputFormatter를 사용하여 자연스러운 입력 경험 제공
/// - 만 14세 이상만 사용 가능
///
/// **편의 기능**:
/// - 페이지 진입 시 자동 포커스
/// - 숫자만 입력 가능 (슬래시는 자동 추가)
/// - 연속 입력 가능 (포커스 이동 불필요)
/// - 백스페이스 자연스럽게 동작
///
/// **Provider 연동**:
/// - onboardingProvider에 생년월일 저장 (YYYY-MM-DD 형식)
class BirthdatePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const BirthdatePage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  ConsumerState<BirthdatePage> createState() => _BirthdatePageState();
}

class _BirthdatePageState extends ConsumerState<BirthdatePage> {
  /// 생년월일 입력을 위한 단일 컨트롤러
  /// 내부적으로는 "19980215" 형식으로 저장되지만, 화면에는 "1998 / 02 / 15"로 표시
  final TextEditingController _birthdateController = TextEditingController();

  /// 입력 필드 포커스 관리
  final FocusNode _focusNode = FocusNode();

  /// 검증 결과 캐싱 (성능 최적화)
  /// setState()가 호출될 때마다 _isValidDate()가 실행되는데,
  /// 동일한 텍스트에 대해 반복 검증하는 것을 방지
  String _lastValidatedText = '';
  bool _cachedValidation = false;

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 자동 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _birthdateController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 생년월일 유효성 검사
  ///
  /// YYYY / MM / DD 형식의 입력을 검증하고, 만 14세 이상인지 확인합니다.
  ///
  /// **성능 최적화**: 동일한 텍스트에 대해 캐시된 결과 반환
  ///
  /// Returns: 유효한 날짜이고 만 14세 이상이면 true, 아니면 false
  bool _isValidDate() {
    final currentText = _birthdateController.text;

    // 캐시된 결과 재사용 (동일한 텍스트면 검증 생략)
    if (currentText == _lastValidatedText) {
      return _cachedValidation;
    }

    // 새로운 검증 수행
    _lastValidatedText = currentText;

    try {
      // 1. 포맷팅된 텍스트에서 숫자만 추출 (슬래시와 공백 제거)
      final digits = currentText.replaceAll(' / ', '');

      // 2. 8자리가 아니면 불완전한 입력
      if (digits.length != 8) {
        _cachedValidation = false;
        return false;
      }

      // 3. 연도, 월, 일 파싱
      final year = int.parse(digits.substring(0, 4));
      final month = int.parse(digits.substring(4, 6));
      final day = int.parse(digits.substring(6, 8));

      // 4. 기본 범위 검증
      if (month < 1 || month > 12) {
        _cachedValidation = false;
        return false;
      }
      if (day < 1 || day > 31) {
        _cachedValidation = false;
        return false;
      }

      // 5. DateTime 생성 시도 (존재하지 않는 날짜는 예외 발생)
      final birthDate = DateTime(year, month, day);

      // 6. DateTime이 자동으로 조정한 경우 감지 (예: 2월 30일 → 3월 2일)
      if (birthDate.year != year ||
          birthDate.month != month ||
          birthDate.day != day) {
        _cachedValidation = false;
        return false;
      }

      // 7. 미래 날짜 방지
      if (birthDate.isAfter(DateTime.now())) {
        _cachedValidation = false;
        return false;
      }

      // 8. 만 14세 이상 확인 (생일이 지났는지 고려)
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      final hasHadBirthdayThisYear =
          now.month > birthDate.month ||
          (now.month == birthDate.month && now.day >= birthDate.day);

      final actualAge = hasHadBirthdayThisYear ? age : age - 1;

      _cachedValidation = actualAge >= 14;
      return _cachedValidation;
    } catch (e) {
      _cachedValidation = false;
      return false;
    }
  }

  /// 다음 버튼 클릭 핸들러
  void _handleNext() {
    if (_isValidDate()) {
      // 키보드 내리기
      FocusScope.of(context).unfocus();

      // 숫자만 추출하여 YYYY-MM-DD 형식으로 변환
      // 최적화: replaceAll(' / ', '')이 정규식보다 빠름
      final digits = _birthdateController.text.replaceAll(' / ', '');
      final birthdate = DateInputFormatter.toIsoFormat(digits);

      // onboardingProvider에 생년월일 저장
      ref.read(onboardingProvider.notifier).updateBirthdate(birthdate);

      // 다음 페이지로 이동
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isValid = _isValidDate();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 빈 공간 클릭 시 키보드 포커스 해제
        FocusScope.of(context).unfocus();
      },
      child: OnboardingLayout(
        stepNumber: 3,
        title: l10n.onboardingBirthdatePrompt,
        showRequiredMark: false,
        description: l10n.onboardingBirthdateDescription,
        content: Column(
          children: [
            // 설명과 입력 필드 사이 간격 (닉네임 페이지와 동일)
            AppSpacing.verticalSpace72,

            // YYYY / MM / DD 입력 (단일 TextField)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
              child: OnboardingTextField(
                controller: _birthdateController,
                focusNode: _focusNode,
                hintText: '2001 / 01 / 01', // 입력 형식 안내
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 14, // "YYYY / MM / DD" = 14자
                style: AppTextStyles.greetingSemiBold20.copyWith(
                  color: AppColors.textColor1,
                  letterSpacing: 2.0, // 가독성을 위한 자간 조정
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                  DateInputFormatter(), // 자동 포맷팅 (YYYY / MM / DD)
                ],
                onChanged: (value) {
                  // 검증 상태 업데이트를 위한 setState
                  setState(() {});
                },
              ),
            ),

            const Spacer(),

            // 만 14세 이상 안내 문구
            Text(
              l10n.onboardingBirthdateAgeLimit,
              style: AppTextStyles.metaMedium12.copyWith(
                color: AppColors.subColor2,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceLG,
          ],
        ),
        button: PrimaryButton(
          text: l10n.btnContinue,
          onPressed: isValid ? _handleNext : null,
          isFullWidth: true,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/inputs/onboarding_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';

/// 생년월일 입력 페이지 (페이지 2/5)
///
/// YYYY / MM / DD 형식으로 8개의 개별 TextField를 사용합니다.
/// 만 14세 이상만 사용 가능합니다.
///
/// 편의 기능:
/// - 페이지 진입 시 첫 번째 필드 자동 포커스
/// - Backspace 개선: 빈 칸에서 이전 칸 내용까지 삭제
/// - 중간 값 수정 시: 기존 값들을 뒤로 밀어내기 (값 보존)
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
  /// YYYY/MM/DD 형식이므로 총 8개의 TextField 필요
  final List<TextEditingController> _controllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  /// 물리 키보드 감지를 위한 FocusNode (KeyboardListener용)
  final List<FocusNode> _keyboardFocusNodes = List.generate(
    8,
    (_) => FocusNode(),
  );

  /// 모바일 키보드 Backspace 감지를 위한 이전 값 추적
  final List<String> _previousValues = List.generate(8, (_) => '');

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 첫 번째 필드에 자동 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final node in _keyboardFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// 생년월일 유효성 검사
  ///
  /// YYYY/MM/DD 형식의 입력을 검증하고, 만 14세 이상인지 확인합니다.
  ///
  /// Returns: 유효한 날짜이고 만 14세 이상이면 true, 아니면 false
  bool _isValidDate() {
    try {
      // 1. 모든 필드가 입력되었는지 확인
      if (_controllers.any((controller) => controller.text.isEmpty)) {
        return false;
      }

      // 2. 연도, 월, 일 파싱
      final year = int.parse(
        _controllers[0].text +
            _controllers[1].text +
            _controllers[2].text +
            _controllers[3].text,
      );
      final month = int.parse(_controllers[4].text + _controllers[5].text);
      final day = int.parse(_controllers[6].text + _controllers[7].text);

      // 3. 기본 범위 검증
      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;

      // 4. DateTime 생성 시도 (존재하지 않는 날짜는 예외 발생)
      final birthDate = DateTime(year, month, day);

      // 5. DateTime이 자동으로 조정한 경우 감지 (예: 2월 30일 → 3월 2일)
      if (birthDate.year != year ||
          birthDate.month != month ||
          birthDate.day != day) {
        return false;
      }

      // 6. 미래 날짜 방지
      if (birthDate.isAfter(DateTime.now())) {
        return false;
      }

      // 7. 만 14세 이상 확인 (생일이 지났는지 고려)
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      final hasHadBirthdayThisYear =
          now.month > birthDate.month ||
          (now.month == birthDate.month && now.day >= birthDate.day);

      final actualAge = hasHadBirthdayThisYear ? age : age - 1;

      return actualAge >= 14;
    } catch (e) {
      return false;
    }
  }

  void _handleNext() {
    if (_isValidDate()) {
      // 키보드 내리기
      FocusScope.of(context).unfocus();

      // YYYY-MM-DD 형식으로 변환
      final year =
          _controllers[0].text +
          _controllers[1].text +
          _controllers[2].text +
          _controllers[3].text;
      final month = _controllers[4].text + _controllers[5].text;
      final day = _controllers[6].text + _controllers[7].text;
      final birthdate = '$year-$month-$day';

      // onboardingProvider에 생년월일 저장
      ref.read(onboardingProvider.notifier).updateBirthdate(birthdate);

      // 다음 페이지로 이동
      widget.onNext();
    }
  }

  /// 날짜 입력 필드 생성
  ///
  /// OnboardingTextField를 사용하여 일관된 스타일 적용
  /// Backspace 개선: 빈 칸에서 Backspace → 이전 칸 내용 삭제 + 포커스 이동
  /// 모바일 키보드와 물리 키보드 모두 지원
  ///
  /// [index] TextField의 인덱스 (0~7)
  Widget _buildDateInputField(int index) {
    return KeyboardListener(
      focusNode: _keyboardFocusNodes[index],
      onKeyEvent: (event) {
        // 물리 키보드 Backspace 감지
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          // 현재 필드가 비어있고 첫 번째 필드가 아닌 경우
          if (_controllers[index].text.isEmpty && index > 0) {
            // 이전 필드 내용 삭제
            _controllers[index - 1].clear();
            _previousValues[index - 1] = '';
            // 이전 필드로 포커스 이동
            _focusNodes[index - 1].requestFocus();
            setState(() {});
          }
        }
      },
      child: OnboardingTextField(
        width: 32.w,
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: AppTextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          // 모바일 키보드 Backspace 감지
          // 먼저 이전 값을 저장 (백스페이스 감지를 위해 필요)
          final previousValue = _previousValues[index];

          // 현재 값으로 업데이트 (항상 먼저 실행!)
          _previousValues[index] = value;

          // 백스페이스 감지: 현재 비어있고, 이전에 값이 있었고, 첫 번째 필드가 아닌 경우
          if (value.isEmpty && previousValue.isNotEmpty && index > 0) {
            // 이전 필드 내용 삭제
            _controllers[index - 1].clear();
            _previousValues[index - 1] = '';
            // 이전 필드로 포커스 이동
            _focusNodes[index - 1].requestFocus();
            setState(() {});
          } else if (value.isNotEmpty) {
            // 중간 값 수정 시: 기존 값들을 뒤로 밀어내기
            // 예: 1998 12 02 에서 12의 1을 1로 수정하면
            // → 1998 1(새값) 2(기존 12의 2) 0(기존 02의 0) 2(기존 02의 2)

            // 1. 현재 인덱스 이후의 값들을 임시로 저장
            final List<String> remainingValues = [];
            for (int i = index + 1; i < 8; i++) {
              if (_controllers[i].text.isNotEmpty) {
                remainingValues.add(_controllers[i].text);
              }
            }

            // 2. 저장된 값들을 다음 칸부터 순서대로 재배치
            for (
              int i = 0;
              i < remainingValues.length && (index + 1 + i) < 8;
              i++
            ) {
              _controllers[index + 1 + i].text = remainingValues[i];
              _previousValues[index + 1 + i] = remainingValues[i];
            }

            // 3. 남은 칸들은 비우기
            for (int i = index + 1 + remainingValues.length; i < 8; i++) {
              _controllers[i].clear();
              _previousValues[i] = '';
            }

            // 4. 자동 포커스 이동
            if (index < 7) {
              _focusNodes[index + 1].requestFocus();
            }

            setState(() {}); // 검증 상태 업데이트
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isValid = _isValidDate();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 여백 (위로 올림)
          AppSpacing.verticalSpaceHuge,

          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingBirthdatePrompt,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gradientMiddle, // #5325CB - 선명한 보라색
                ),
              ),
              AppSpacing.horizontalSpace(4),
              Text(
                '*',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          // 제목-설명 간격
          AppSpacing.verticalSpaceSM,

          // 설명 (제목 바로 아래, 국제화 적용)
          Text(
            l10n.onboardingBirthdateDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onboardingDescription, // #130537 - 진한 남보라
            ),
            textAlign: TextAlign.center,
          ),

          // 입력 필드를 중앙에 배치하기 위한 여백
          const Spacer(),

          // YYYY / MM / DD 입력
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // YYYY (4자리)
              _buildDateInputField(0),
              AppSpacing.horizontalSpace(2),
              _buildDateInputField(1),
              AppSpacing.horizontalSpace(2),
              _buildDateInputField(2),
              AppSpacing.horizontalSpace(2),
              _buildDateInputField(3),

              // 구분자: /
              AppSpacing.horizontalSpaceSM,
              Text(
                '/',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.horizontalSpaceSM,

              // MM (2자리)
              _buildDateInputField(4),
              AppSpacing.horizontalSpace(2),
              _buildDateInputField(5),

              // 구분자: /
              AppSpacing.horizontalSpaceSM,
              Text(
                '/',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.horizontalSpaceSM,

              // DD (2자리)
              _buildDateInputField(6),
              AppSpacing.horizontalSpace(2),
              _buildDateInputField(7),
            ],
          ),

          // 입력-버튼 간격
          const Spacer(),

          // 만 14세 이상 안내 문구
          Text(
            l10n.onboardingBirthdateAgeLimit,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          AppSpacing.verticalSpaceMD,

          // 계속하기 버튼 (국제화 적용)
          PrimaryButton(
            text: l10n.btnContinue,
            onPressed: isValid ? _handleNext : null,
            isFullWidth: true,
            // 소셜 로그인 버튼과 동일한 완전한 pill 모양 적용
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.circle),
                ),
              ),
            ),
          ),

          // 하단 여백 (버튼을 조금 위로)
          AppSpacing.verticalSpace60,
        ],
      ),
    );
  }
}

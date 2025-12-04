import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/features/auth/data/models/user_model.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';
import 'package:tripgether/features/mypage/presentation/providers/profile_edit_provider.dart';
import 'package:tripgether/features/mypage/presentation/widgets/menu_section.dart';
import 'package:tripgether/features/mypage/presentation/widgets/menu_item.dart';
import 'package:tripgether/features/onboarding/providers/interest_provider.dart';
import 'package:tripgether/features/onboarding/data/models/interest_response.dart';
import 'package:tripgether/features/onboarding/presentation/widgets/interest_chip.dart';
import 'package:tripgether/features/onboarding/presentation/widgets/category_dropdown_button.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/shared/widgets/common/common_app_bar.dart';
import 'package:tripgether/shared/widgets/common/profile_avatar.dart';
import 'package:tripgether/shared/widgets/buttons/common_button.dart';
import 'package:tripgether/shared/widgets/dialogs/common_dialog.dart';
import 'package:tripgether/shared/widgets/common/app_snackbar.dart';

/// 프로필 편집 화면
///
/// **기능**:
/// - 닉네임 수정
/// - 성별 수정
/// - 생년월일 수정
/// - 관심사 수정 (바텀시트)
/// - 로그아웃
/// - 회원 탈퇴
///
/// **API**:
/// - POST /api/members/profile (프로필 저장)
/// - GET /api/interests (관심사 목록)
/// - GET /api/members/{memberId}/interests (사용자 관심사)
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  /// 닉네임 입력 컨트롤러
  late TextEditingController _nicknameController;

  /// 선택된 성별 (MALE, FEMALE, NOT_SELECTED)
  String? _selectedGender;

  /// 선택된 생년월일
  DateTime? _selectedBirthDate;

  /// 선택된 관심사 ID 목록
  Set<String> _selectedInterestIds = {};

  /// 저장 중 상태
  bool _isSaving = false;

  /// 변경 여부 추적
  bool _hasChanges = false;

  /// 원래 닉네임 (초기값 저장용)
  String _originalNickname = '';

  /// 닉네임 중복확인 상태
  /// - null: 확인 전 또는 닉네임 변경됨
  /// - true: 사용 가능
  /// - false: 이미 사용 중
  bool? _isNicknameAvailable;

  /// 닉네임 중복확인 중 상태
  bool _isCheckingNickname = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();

    // 현재 사용자 정보로 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromUser();
    });
  }

  /// 현재 사용자 정보로 폼 초기화
  void _initializeFromUser() {
    final userAsync = ref.read(userNotifierProvider);
    userAsync.whenData((user) {
      if (user != null) {
        _nicknameController.text = user.nickname;
        setState(() {
          _originalNickname = user.nickname;
          _selectedGender = user.gender;
          if (user.birthDate != null) {
            _selectedBirthDate = DateTime.tryParse(user.birthDate!);
          }
        });

        // 사용자 관심사 로드
        _loadUserInterests(user.userId);
      }
    });
  }

  /// 사용자 관심사 로드
  ///
  /// GET /api/members/{memberId}/interests
  Future<void> _loadUserInterests(String? userId) async {
    if (userId == null) return;

    try {
      final interests = await ref
          .read(profileEditNotifierProvider.notifier)
          .getUserInterests(userId);

      if (mounted && interests != null) {
        setState(() {
          _selectedInterestIds = interests
              .map((i) => i['id'] as String)
              .toSet();
        });
      }
    } catch (e) {
      debugPrint('[ProfileEditScreen] ⚠️ 관심사 로드 실패: $e');
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(userNotifierProvider);

    // 저장 버튼 활성화 조건:
    // 1. 변경사항이 있어야 함
    // 2. 저장 중이 아니어야 함
    // 3. 닉네임이 원래와 같으면 중복확인 불필요, 다르면 중복확인 완료 필요
    final nicknameChanged =
        _nicknameController.text.trim() != _originalNickname;
    final canSave =
        _hasChanges &&
        !_isSaving &&
        (!nicknameChanged || _isNicknameAvailable == true);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar.forSettings(
        context: context,
        title: '프로필 편집',
        onSavePressed: canSave ? _handleSave : null,
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('프로필을 불러올 수 없습니다', style: AppTextStyles.bodyMedium16),
        ),
        data: (user) {
          if (user == null) {
            return Center(
              child: Text('로그인이 필요합니다', style: AppTextStyles.bodyMedium16),
            );
          }
          return _buildContent(context, user, l10n);
        },
      ),
    );
  }

  /// 프로필 편집 내용 빌드
  Widget _buildContent(BuildContext context, User user, AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 아바타 (중앙 정렬)
          _buildProfileHeader(user),

          AppSpacing.verticalSpaceLG,

          // 기본 정보 섹션
          _buildBasicInfoSection(),

          AppSpacing.verticalSpaceMD,

          // 관심사 섹션
          _buildInterestsSection(),

          AppSpacing.verticalSpaceMD,

          // 계정 관리 섹션
          _buildAccountSection(context),

          AppSpacing.verticalSpaceXXL,
        ],
      ),
    );
  }

  /// 프로필 헤더 (아바타 + 이메일)
  Widget _buildProfileHeader(User user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          ProfileAvatar(
            imageUrl: user.profileImageUrl,
            size: ProfileAvatarSize.xLarge,
            showBorder: true,
          ),
          AppSpacing.verticalSpaceMD,
          Text(
            user.email,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.subColor2,
            ),
          ),
        ],
      ),
    );
  }

  /// 기본 정보 섹션 (닉네임, 성별, 생년월일)
  Widget _buildBasicInfoSection() {
    return MenuSection(
      tag: '기본 정보',
      children: [
        // 닉네임 입력
        _buildNicknameField(),

        AppSpacing.verticalSpaceMD,

        // 성별 선택
        _buildGenderField(),

        AppSpacing.verticalSpaceMD,

        // 생년월일 선택
        _buildBirthDateField(),
      ],
    );
  }

  /// 닉네임 입력 필드
  Widget _buildNicknameField() {
    final nickname = _nicknameController.text.trim();
    final nicknameChanged = nickname != _originalNickname;
    final isValidLength = nickname.length >= 2 && nickname.length <= 50;

    // 중복확인 버튼 활성화 조건
    final canCheck = isValidLength && nicknameChanged && !_isCheckingNickname;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: AppTextStyles.titleSemiBold14.copyWith(
            color: AppColors.subColor2,
          ),
        ),
        SizedBox(height: 8.h),

        // 입력 필드 + 중복확인 버튼
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 닉네임 입력 필드
            Expanded(
              child: TextField(
                controller: _nicknameController,
                style: AppTextStyles.bodyMedium16,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력하세요 (2-50자)',
                  hintStyle: AppTextStyles.bodyMedium16.copyWith(
                    color: AppColors.subColor2,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppColors.subColor2.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppColors.subColor2.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppColors.mainColor,
                      width: 1.5.w,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _hasChanges = true;
                    // 닉네임 변경 시 중복확인 상태 초기화
                    _isNicknameAvailable = null;
                  });
                },
              ),
            ),

            SizedBox(width: AppSpacing.sm),

            // 중복확인 버튼
            SizedBox(
              height: 48.h,
              child: ElevatedButton(
                onPressed: canCheck ? _handleCheckNickname : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canCheck
                      ? AppColors.mainColor
                      : AppColors.subColor2.withValues(alpha: 0.3),
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: _isCheckingNickname
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        '중복확인',
                        style: AppTextStyles.buttonMediumMedium14.copyWith(
                          color: canCheck
                              ? AppColors.white
                              : AppColors.subColor2,
                        ),
                      ),
              ),
            ),
          ],
        ),

        // 중복확인 결과 메시지
        if (nicknameChanged && _isNicknameAvailable != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                _isNicknameAvailable! ? Icons.check_circle : Icons.cancel,
                size: 16.w,
                color: _isNicknameAvailable!
                    ? AppColors.success
                    : AppColors.error,
              ),
              SizedBox(width: 4.w),
              Text(
                _isNicknameAvailable! ? '사용 가능한 닉네임입니다' : '이미 사용 중인 닉네임입니다',
                style: AppTextStyles.metaMedium12.copyWith(
                  color: _isNicknameAvailable!
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 닉네임 중복확인 처리
  Future<void> _handleCheckNickname() async {
    final nickname = _nicknameController.text.trim();

    if (nickname.length < 2 || nickname.length > 50) {
      return;
    }

    setState(() {
      _isCheckingNickname = true;
    });

    try {
      final isAvailable = await ref
          .read(profileEditNotifierProvider.notifier)
          .checkNickname(nickname);

      if (mounted) {
        setState(() {
          _isNicknameAvailable = isAvailable;
          _isCheckingNickname = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isNicknameAvailable = false;
          _isCheckingNickname = false;
        });
        // AppSnackBar로 에러 메시지 표시 (백엔드 에러 메시지 통일)
        AppSnackBar.showError(context, '닉네임 확인에 실패했습니다');
      }
    }
  }

  /// 성별 선택 필드
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성별',
          style: AppTextStyles.titleSemiBold14.copyWith(
            color: AppColors.subColor2,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _buildGenderChip('남성', 'MALE')),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: _buildGenderChip('여성', 'FEMALE')),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: _buildGenderChip('선택 안함', 'NOT_SELECTED')),
          ],
        ),
      ],
    );
  }

  /// 성별 선택 칩
  Widget _buildGenderChip(String label, String value) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
          _hasChanges = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor : AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.mainColor
                : AppColors.subColor2.withValues(alpha: 0.3),
            width: 1.5.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium16.copyWith(
              color: isSelected ? AppColors.white : AppColors.textColor1,
            ),
          ),
        ),
      ),
    );
  }

  /// 생년월일 선택 필드
  Widget _buildBirthDateField() {
    final displayText = _selectedBirthDate != null
        ? '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일'
        : '생년월일을 선택하세요';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '생년월일',
          style: AppTextStyles.titleSemiBold14.copyWith(
            color: AppColors.subColor2,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.subColor2.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayText,
                  style: AppTextStyles.bodyMedium16.copyWith(
                    color: _selectedBirthDate != null
                        ? AppColors.textColor1
                        : AppColors.subColor2,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.subColor2,
                  size: AppSizes.iconDefault,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 관심사 섹션
  Widget _buildInterestsSection() {
    return MenuSection(
      tag: '관심사 (${_selectedInterestIds.length}/10)',
      children: [
        // 선택된 관심사 칩들 표시
        if (_selectedInterestIds.isNotEmpty) ...[
          _buildSelectedInterestsChips(),
          AppSpacing.verticalSpaceMD,
        ],

        // 관심사 수정 버튼
        MenuItem(
          title: '관심사 수정',
          onTap: () => _showInterestsBottomSheet(context),
        ),
      ],
    );
  }

  /// 선택된 관심사 칩들 표시
  Widget _buildSelectedInterestsChips() {
    final interestsAsync = ref.watch(interestsProvider);

    return interestsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (response) {
        // 선택된 관심사 이름들 추출
        final selectedNames = <String>[];
        for (var category in response.categories) {
          for (var interest in category.interests) {
            if (_selectedInterestIds.contains(interest.id)) {
              selectedNames.add(interest.name);
            }
          }
        }

        if (selectedNames.isEmpty) return const SizedBox.shrink();

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: selectedNames.map((name) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                name,
                style: AppTextStyles.bodyRegular14.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// 계정 관리 섹션 (로그아웃, 회원 탈퇴)
  Widget _buildAccountSection(BuildContext context) {
    return MenuSection(
      tag: '계정 관리',
      children: [
        // 로그아웃
        MenuItem(title: '로그아웃', onTap: () => _showLogoutDialog(context)),

        // 회원 탈퇴 (위험 액션: 빨간색 텍스트)
        MenuItem(
          title: '회원 탈퇴',
          titleColor: Colors.redAccent,
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.redAccent,
            size: AppSizes.iconDefault,
          ),
          onTap: () => _showWithdrawDialog(context),
        ),
      ],
    );
  }

  /// 관심사 선택 바텀시트 표시
  void _showInterestsBottomSheet(BuildContext context) {
    // 현재 선택된 관심사를 복사 (취소 시 복원용)
    final originalInterests = Set<String>.from(_selectedInterestIds);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => _InterestsBottomSheet(
        selectedInterestIds: _selectedInterestIds,
        onConfirm: (selectedIds) {
          setState(() {
            _selectedInterestIds = selectedIds;
            _hasChanges = true;
          });
        },
        onCancel: () {
          setState(() {
            _selectedInterestIds = originalInterests;
          });
        },
      ),
    );
  }

  /// 날짜 선택기 표시
  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _selectedBirthDate ?? DateTime(now.year - 20, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 14, now.month, now.day),
      locale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.mainColor,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textColor1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _hasChanges = true;
      });
    }
  }

  /// 저장 처리
  ///
  /// **API**: POST /api/members/profile
  /// 닉네임, 성별, 생년월일, 관심사 모두 한 번에 저장
  Future<void> _handleSave() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.length < 2 || nickname.length > 50) {
      AppSnackBar.showError(context, '닉네임은 2자 이상 50자 이하로 입력해주세요.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // 프로필 업데이트 API 호출 (관심사 포함)
      await ref
          .read(profileEditNotifierProvider.notifier)
          .updateProfile(
            name: nickname,
            gender: _selectedGender,
            birthDate: _selectedBirthDate,
            interestIds: _selectedInterestIds.toList(),
          );

      if (mounted) {
        setState(() {
          _isSaving = false;
          _hasChanges = false;
        });

        // AppSnackBar로 성공 메시지 표시
        AppSnackBar.showSuccess(context, '프로필이 저장되었습니다');

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        // AppSnackBar로 에러 메시지 표시
        AppSnackBar.showError(context, '프로필 저장에 실패했습니다');
      }
    }
  }

  /// 로그아웃 확인 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog.forConfirm(
        title: '로그아웃',
        description: '정말 로그아웃 하시겠습니까?',
        confirmText: '로그아웃',
        cancelText: '취소',
        // CommonDialog의 autoDismiss가 자동으로 pop 처리함
        // 콜백에서 중복 pop 하면 스택 에러 발생
        onConfirm: () async {
          await _handleLogout();
        },
        // onCancel: null이면 autoDismiss로 다이얼로그만 닫힘
      ),
    );
  }

  /// 로그아웃 처리
  Future<void> _handleLogout() async {
    try {
      await ref.read(userNotifierProvider.notifier).clearUser();

      if (mounted) {
        context.go('/auth/login');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, '로그아웃에 실패했습니다');
      }
    }
  }

  /// 회원 탈퇴 확인 다이얼로그
  ///
  /// **2중 안전 장치**:
  /// 1. 이메일 입력 검증 (현재 로그인된 이메일과 일치해야 함)
  /// 2. 이메일 일치 시에만 탈퇴 버튼 활성화
  ///
  /// **구현 방식**:
  /// - CommonDialog의 customContent 파라미터 활용
  /// - StatefulBuilder로 다이얼로그 내부 상태 관리
  void _showWithdrawDialog(BuildContext context) {
    // 현재 사용자 이메일 가져오기
    final currentUser = ref.read(userNotifierProvider).valueOrNull;
    final userEmail = currentUser?.email ?? '';
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          // 이메일 일치 여부 계산
          final inputEmail = emailController.text.trim().toLowerCase();
          final isEmailMatch =
              inputEmail.isNotEmpty && inputEmail == userEmail.toLowerCase();

          return CommonDialog(
            title: '회원 탈퇴',
            description:
                '정말 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.',
            subtitle: '탈퇴를 확인하려면 이메일을 입력하세요',
            leftButtonText: '취소',
            rightButtonText: '탈퇴',
            rightButtonColor:
                isEmailMatch ? AppColors.error : AppColors.error.withValues(alpha: 0.3),
            rightButtonTextColor:
                isEmailMatch ? AppColors.white : AppColors.white.withValues(alpha: 0.5),
            // 취소 버튼: 항상 다이얼로그 닫기
            onLeftPressed: () => Navigator.of(context).pop(),
            // 탈퇴 버튼: 이메일 일치할 때만 실행
            onRightPressed: isEmailMatch
                ? () async {
                    Navigator.of(context).pop(); // 먼저 다이얼로그 닫기
                    await _handleWithdraw();
                  }
                : null,
            autoDismiss: false, // 수동으로 닫기 제어
            customContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.md),

                // 현재 이메일 표시
                Text(
                  '현재 이메일: $userEmail',
                  style: AppTextStyles.caption12.copyWith(
                    color: AppColors.subColor2,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                // 이메일 입력 TextField
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onChanged: (_) => setDialogState(() {}), // 입력 변경 시 상태 갱신
                  decoration: InputDecoration(
                    hintText: '이메일을 입력하세요',
                    hintStyle: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.subColor2,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.allMedium,
                      borderSide: BorderSide(color: AppColors.subColor2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.allMedium,
                      borderSide: BorderSide(color: AppColors.subColor2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.allMedium,
                      borderSide: BorderSide(
                        color: isEmailMatch ? AppColors.success : AppColors.mainColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    // 일치 여부 아이콘 표시
                    suffixIcon: emailController.text.isNotEmpty
                        ? Icon(
                            isEmailMatch ? Icons.check_circle : Icons.cancel,
                            color: isEmailMatch ? AppColors.success : AppColors.error,
                            size: 20.w,
                          )
                        : null,
                  ),
                  style: AppTextStyles.bodyRegular14,
                ),

                // 일치 여부 메시지
                if (emailController.text.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    isEmailMatch ? '이메일이 일치합니다' : '이메일이 일치하지 않습니다',
                    style: AppTextStyles.metaMedium12.copyWith(
                      color: isEmailMatch ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    ).then((_) => emailController.dispose()); // 컨트롤러 정리
  }

  /// 회원 탈퇴 처리
  Future<void> _handleWithdraw() async {
    try {
      await ref.read(profileEditNotifierProvider.notifier).withdrawMember();

      if (!mounted) return;

      await ref.read(userNotifierProvider.notifier).clearUser();

      if (!mounted) return;

      context.go('/auth/login');
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, '회원 탈퇴에 실패했습니다');
      }
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// 관심사 선택 바텀시트
// ════════════════════════════════════════════════════════════════════════════

/// 관심사 선택 바텀시트
///
/// 온보딩의 InterestsPage와 유사한 UI를 제공합니다.
/// 최소 3개, 최대 10개의 관심사를 선택할 수 있습니다.
class _InterestsBottomSheet extends ConsumerStatefulWidget {
  final Set<String> selectedInterestIds;
  final void Function(Set<String> selectedIds) onConfirm;
  final VoidCallback onCancel;

  const _InterestsBottomSheet({
    required this.selectedInterestIds,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  ConsumerState<_InterestsBottomSheet> createState() =>
      _InterestsBottomSheetState();
}

class _InterestsBottomSheetState extends ConsumerState<_InterestsBottomSheet> {
  /// 선택된 관심사 ID 목록 (로컬 상태)
  late Set<String> _localSelectedIds;

  /// 현재 열려있는 카테고리 코드 (한 번에 하나만 열림)
  String? _expandedCategoryCode;

  /// 각 카테고리 버튼의 GlobalKey (위치 추적용)
  final Map<String, GlobalKey> _buttonKeys = {};

  /// Overlay Entry (드롭다운 컨테이너)
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _localSelectedIds = Set<String>.from(widget.selectedInterestIds);
  }

  @override
  void dispose() {
    // Overlay 정리
    _removeOverlay();
    super.dispose();
  }

  /// Overlay 제거 함수
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 관심사 항목 탭 핸들러
  void _handleInterestTap(String interestId) {
    setState(() {
      if (_localSelectedIds.contains(interestId)) {
        _localSelectedIds.remove(interestId);
      } else {
        if (_localSelectedIds.length < 10) {
          _localSelectedIds.add(interestId);
        }
      }
    });
  }

  /// 카테고리 드롭다운 토글 핸들러 (Overlay 방식)
  ///
  /// 같은 카테고리를 다시 탭하면 닫히고, 다른 카테고리를 탭하면 기존 것은 닫히고 새로운 것이 열립니다.
  /// interests_page.dart의 _toggleCategory 로직과 동일
  void _toggleCategory(String categoryCode, InterestCategoryDto category) {
    // 이미 열려있는 경우 닫기
    if (_expandedCategoryCode == categoryCode) {
      setState(() {
        _expandedCategoryCode = null;
      });
      _removeOverlay();
      return;
    }

    // 기존 Overlay 제거
    _removeOverlay();

    // 새로운 카테고리 열기
    setState(() {
      _expandedCategoryCode = categoryCode;
    });

    // 버튼 위치 계산
    final buttonKey = _buttonKeys[categoryCode]!;
    final renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    // Overlay 생성 및 표시
    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, overlaySetState) => Stack(
          children: [
            // 배경 영역 (탭 시 드롭다운 닫기)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedCategoryCode = null;
                  });
                  _removeOverlay();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),

            // 드롭다운 컨테이너
            Positioned(
              top: buttonPosition.dy + buttonSize.height + AppSpacing.sm,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Material(
                elevation: 4,
                borderRadius: AppRadius.allLarge,
                color: AppColors.surface,
                child: Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.allLarge,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: category.interests.map((item) {
                      final isSelected = _localSelectedIds.contains(item.id);
                      return InterestChip(
                        label: item.name,
                        isSelected: isSelected,
                        onTap: () {
                          // 부모 위젯 상태 업데이트 (selectedCount 및 버튼 표시)
                          _handleInterestTap(item.id);
                          // Overlay 내부만 재빌드 (칩 선택 상태 시각적 업데이트)
                          overlaySetState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(interestsProvider);
    final selectedCount = _localSelectedIds.length;
    final isValid = selectedCount >= 3 && selectedCount <= 10;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return categoriesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          ),
          error: (error, _) => Center(
            child: Text('관심사를 불러올 수 없습니다', style: AppTextStyles.bodyMedium16),
          ),
          data: (response) {
            final categories = response.categories.toList()
              ..sort(
                (a, b) => b.interests.length.compareTo(a.interests.length),
              );

            // GlobalKey 초기화 (처음 한 번만)
            if (_buttonKeys.isEmpty) {
              for (var category in categories) {
                _buttonKeys[category.category] = GlobalKey();
              }
            }

            return Column(
              children: [
                // 헤더
                _buildHeader(selectedCount),

                // 카테고리 목록
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.all(AppSpacing.lg),
                    children: [
                      // 카테고리 드롭다운 버튼들 (Wrap 레이아웃)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((category) {
                          final isExpanded =
                              _expandedCategoryCode == category.category;

                          // 이 카테고리에서 선택된 관심사 개수 계산
                          final selectedInCategory = category.interests
                              .where(
                                (item) => _localSelectedIds.contains(item.id),
                              )
                              .length;

                          return Container(
                            key: _buttonKeys[category.category],
                            child: CategoryDropdownButton(
                              categoryName: category.displayName,
                              isExpanded: isExpanded,
                              selectedCount: selectedInCategory,
                              onTap: () =>
                                  _toggleCategory(category.category, category),
                            ),
                          );
                        }).toList(),
                      ),

                      // 하단 여백 (스크롤용)
                      AppSpacing.verticalSpaceLG,
                    ],
                  ),
                ),

                // 하단 버튼
                _buildFooter(isValid, l10n),
              ],
            );
          },
        );
      },
    );
  }

  /// 선택 초기화 핸들러
  void _handleReset() {
    // Overlay가 열려있으면 닫기
    _removeOverlay();
    setState(() {
      _expandedCategoryCode = null;
      _localSelectedIds.clear();
    });
  }

  /// 바텀시트 헤더
  Widget _buildHeader(int selectedCount) {
    // 선택된 항목이 있을 때만 초기화 버튼 활성화
    final canReset = selectedCount > 0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.subColor2.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 제목
          Text('관심사 수정', style: AppTextStyles.titleSemiBold16),

          // 오른쪽: 초기화 버튼 + 선택 개수
          Row(
            children: [
              // 초기화 버튼
              GestureDetector(
                onTap: canReset ? _handleReset : null,
                child: Text(
                  '초기화',
                  style: AppTextStyles.bodyRegular14.copyWith(
                    color: canReset ? AppColors.subColor2 : AppColors.subColor2.withValues(alpha: 0.4),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // 선택 개수 (최소 3개 미만이면 빨간색 표시)
              Text(
                '$selectedCount/10 선택',
                style: AppTextStyles.titleSemiBold14.copyWith(
                  color: selectedCount < 3 ? AppColors.error : AppColors.mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 하단 버튼 영역
  ///
  /// [selectedCount]를 받아서 최소 3개 미만일 때 안내 메시지 표시
  Widget _buildFooter(bool isValid, AppLocalizations l10n) {
    final selectedCount = _localSelectedIds.length;
    final needsMore = selectedCount < 3;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.subColor2.withValues(alpha: 0.2)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 최소 3개 미만일 때 안내 메시지
            if (needsMore) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14.w,
                    color: AppColors.error,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '최소 3개 이상 선택해주세요 (${3 - selectedCount}개 더 필요)',
                    style: AppTextStyles.metaMedium12.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
            ],

            // 버튼 영역
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: SecondaryButton(
                    text: '취소',
                    onPressed: () {
                      _removeOverlay(); // Overlay 정리
                      widget.onCancel();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                // 확인 버튼
                Expanded(
                  child: PrimaryButton(
                    text: '확인',
                    onPressed: isValid
                        ? () {
                            _removeOverlay(); // Overlay 정리
                            widget.onConfirm(_localSelectedIds);
                            Navigator.pop(context);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

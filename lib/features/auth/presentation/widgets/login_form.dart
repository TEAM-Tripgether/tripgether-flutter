import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/common_button.dart';

/// 로그인 입력 폼 위젯
///
/// 이메일, 비밀번호 입력 필드와 자동로그인 체크박스,
/// 아이디/비밀번호 찾기 링크를 포함하는 로그인 폼입니다.
class LoginForm extends StatefulWidget {
  /// 로그인 버튼 탭 시 호출되는 콜백
  /// 이메일과 비밀번호를 파라미터로 전달합니다
  final Function(String email, String password) onLogin;

  /// 아이디 찾기 버튼 탭 콜백
  final VoidCallback? onFindId;

  /// 비밀번호 찾기 버튼 탭 콜백
  final VoidCallback? onFindPassword;

  const LoginForm({
    super.key,
    required this.onLogin,
    this.onFindId,
    this.onFindPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  /// 폼 상태 관리를 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  /// 이메일 입력 컨트롤러
  final _emailController = TextEditingController();

  /// 비밀번호 입력 컨트롤러
  final _passwordController = TextEditingController();

  /// 비밀번호 표시/숨김 상태
  bool _obscurePassword = true;

  /// 자동로그인 체크 상태
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 이메일 형식 검증
  String? _validateEmail(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }
    // 이메일 정규식 검증
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.emailInvalidFormat;
    }
    return null;
  }

  /// 비밀번호 검증
  String? _validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordMinLength;
    }
    return null;
  }

  /// 로그인 버튼 탭 핸들러
  void _handleLogin() {
    // 폼 검증
    if (_formKey.currentState?.validate() ?? false) {
      // 검증 성공 시 로그인 콜백 호출
      widget.onLogin(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 이메일 입력 필드 (언더라인 스타일)
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next, // 다음 필드로 이동
            validator: (value) => _validateEmail(value, context),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary, // 흰색 텍스트
            ),
            decoration: InputDecoration(
              labelText: l10n.emailLabel,
              hintText: l10n.emailHint,
              filled: false, // 박스 배경 제거 (중요!)
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.outline, // 밝은 회색 라벨
              ),
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.outline, // 밝은 회색 힌트
              ),
              // 하단 라인만 표시 (박스 제거)
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.outline),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.outline),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.onPrimary, // 포커스 시 흰색
                  width: AppSizes.borderMedium,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.errorContainer),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.errorContainer,
                  width: AppSizes.borderMedium,
                ),
              ),
              errorStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorContainer, // 연한 핑크 에러 메시지
              ),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          /// 비밀번호 입력 필드 (언더라인 스타일)
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword, // 비밀번호 마스킹
            textInputAction: TextInputAction.done, // 완료 버튼
            onFieldSubmitted: (_) => _handleLogin(), // 엔터 시 로그인
            validator: (value) => _validatePassword(value, context),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary, // 흰색 텍스트
            ),
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              hintText: l10n.passwordHint,
              filled: false, // 박스 배경 제거 (중요!)
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.outline, // 밝은 회색 라벨
              ),
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.outline, // 밝은 회색 힌트
              ),
              // 비밀번호 보기/숨기기 토글 버튼 (suffixIcon만 유지)
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.outline, // 밝은 회색 아이콘
                  size: AppSizes.iconMedium,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              // 하단 라인만 표시 (박스 제거)
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.outline),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.outline),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.onPrimary, // 포커스 시 흰색
                  width: AppSizes.borderMedium,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.errorContainer),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.errorContainer,
                  width: AppSizes.borderMedium,
                ),
              ),
              errorStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorContainer, // 연한 핑크 에러 메시지
              ),
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          /// 자동로그인 & 비밀번호 찾기 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽: 자동로그인 체크박스
              Row(
                children: [
                  SizedBox(
                    width: AppSizes.iconDefault,
                    height: AppSizes.iconDefault.h,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      // 체크박스 색상: 흰색 테두리, 선택 시 흰색 배경
                      checkColor: AppColors.gradientMiddle, // 체크마크 색상
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.onPrimary; // 선택 시 흰색
                        }
                        return Colors.transparent; // 미선택 시 투명
                      }),
                      side: BorderSide(
                        color: AppColors.outline, // 밝은 회색 테두리
                        width: AppSizes.borderThin,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.autoLogin,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.outline, // 밝은 회색 텍스트
                    ),
                  ),
                ],
              ),

              // 오른쪽: 비밀번호 찾기만 (아이디 찾기 제거)
              TertiaryButton(
                text: l10n.findPassword,
                onPressed: widget.onFindPassword,
                // 로그인 화면 전용 둥근 모서리 스타일 (변경할 속성만 지정)
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          /// 로그인 버튼 (공용 PrimaryButton 컴포넌트 사용)
          PrimaryButton(
            text: l10n.login,
            onPressed: _handleLogin,
            isFullWidth: true,
            // 로그인 화면 전용 둥근 모서리 스타일 (변경할 속성만 지정)
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

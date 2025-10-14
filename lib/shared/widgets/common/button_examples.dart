import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';
import 'common_button.dart';

/// 공용 버튼 컴포넌트 사용 예제 화면
///
/// 다양한 버튼 스타일과 조합을 시연합니다.
/// 디버그 및 테스트 목적으로 사용할 수 있습니다.
class ButtonExamplesScreen extends StatefulWidget {
  const ButtonExamplesScreen({super.key});

  @override
  State<ButtonExamplesScreen> createState() => _ButtonExamplesScreenState();
}

class _ButtonExamplesScreenState extends State<ButtonExamplesScreen> {
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('버튼 컴포넌트 예제'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== Primary Buttons ====================
            _buildSection(
              title: 'Primary Buttons',
              description: '주요 액션을 위한 버튼 (ElevatedButton 기반)',
              children: [
                PrimaryButton(
                  text: '기본 버튼',
                  onPressed: () => _showSnackBar('Primary Button 클릭'),
                ),
                AppSpacing.verticalSpaceMD,
                PrimaryButton(
                  text: '아이콘 버튼',
                  icon: Icons.check,
                  onPressed: () => _showSnackBar('아이콘 버튼 클릭'),
                ),
                AppSpacing.verticalSpaceMD,
                PrimaryButton(
                  text: '로딩 상태',
                  isLoading: _isLoading,
                  onPressed: _toggleLoading,
                ),
                AppSpacing.verticalSpaceMD,
                PrimaryButton(
                  text: '비활성화 상태',
                  onPressed: null, // null이면 비활성화
                ),
                AppSpacing.verticalSpaceMD,
                PrimaryButton(
                  text: '컴팩트 버튼',
                  isFullWidth: false,
                  onPressed: () => _showSnackBar('컴팩트 버튼 클릭'),
                ),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ==================== Secondary Buttons ====================
            _buildSection(
              title: 'Secondary Buttons',
              description: '부가 액션을 위한 버튼 (OutlinedButton 기반)',
              children: [
                SecondaryButton(
                  text: '기본 버튼',
                  onPressed: () => _showSnackBar('Secondary Button 클릭'),
                ),
                AppSpacing.verticalSpaceMD,
                SecondaryButton(
                  text: '아이콘 버튼',
                  icon: Icons.edit,
                  onPressed: () => _showSnackBar('아이콘 버튼 클릭'),
                ),
                AppSpacing.verticalSpaceMD,
                SecondaryButton(
                  text: '로딩 상태',
                  isLoading: _isLoading,
                  onPressed: _toggleLoading,
                ),
                AppSpacing.verticalSpaceMD,
                SecondaryButton(
                  text: '비활성화 상태',
                  onPressed: null,
                ),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ==================== Tertiary Buttons ====================
            _buildSection(
              title: 'Tertiary Buttons',
              description: '텍스트 전용 버튼 (TextButton 기반)',
              children: [
                TertiaryButton(
                  text: '기본 버튼',
                  onPressed: () => _showSnackBar('Tertiary Button 클릭'),
                ),
                AppSpacing.verticalSpaceMD,
                TertiaryButton(
                  text: '아이콘 버튼',
                  icon: Icons.info,
                  onPressed: () => _showSnackBar('아이콘 버튼 클릭'),
                ),
                AppSpacing.verticalSpaceMD,
                TertiaryButton(
                  text: '비활성화 상태',
                  onPressed: null,
                ),
                AppSpacing.verticalSpaceMD,
                TertiaryButton(
                  text: '전체 너비',
                  isFullWidth: true,
                  onPressed: () => _showSnackBar('전체 너비 버튼 클릭'),
                ),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ==================== Icon Buttons ====================
            _buildSection(
              title: 'Icon Buttons',
              description: '아이콘만 있는 버튼',
              children: [
                Row(
                  children: [
                    CommonIconButton(
                      icon: Icons.favorite_border,
                      onPressed: () => _showSnackBar('좋아요'),
                      tooltip: '좋아요',
                    ),
                    SizedBox(width: AppSpacing.md),
                    CommonIconButton(
                      icon: Icons.share,
                      onPressed: () => _showSnackBar('공유'),
                      tooltip: '공유',
                    ),
                    SizedBox(width: AppSpacing.md),
                    CommonIconButton(
                      icon: Icons.bookmark_border,
                      onPressed: () => _showSnackBar('북마크'),
                      tooltip: '북마크',
                    ),
                    SizedBox(width: AppSpacing.md),
                    CommonIconButton(
                      icon: Icons.more_vert,
                      onPressed: null, // 비활성화
                      tooltip: '더보기',
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceMD,
                const Text('배경이 있는 아이콘 버튼:'),
                AppSpacing.verticalSpaceSM,
                Row(
                  children: [
                    CommonIconButton(
                      icon: Icons.add,
                      onPressed: () => _showSnackBar('추가'),
                      tooltip: '추가',
                      hasBackground: true,
                    ),
                    SizedBox(width: AppSpacing.md),
                    CommonIconButton(
                      icon: Icons.delete,
                      onPressed: () => _showSnackBar('삭제'),
                      tooltip: '삭제',
                      hasBackground: true,
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ==================== Button Groups ====================
            _buildSection(
              title: 'Button Groups',
              description: '여러 버튼을 그룹으로 배치',
              children: [
                const Text('수평 배치:'),
                AppSpacing.verticalSpaceSM,
                ButtonGroup(
                  children: [
                    SecondaryButton(
                      text: '취소',
                      onPressed: () => _showSnackBar('취소'),
                    ),
                    PrimaryButton(
                      text: '확인',
                      onPressed: () => _showSnackBar('확인'),
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceMD,
                const Text('수직 배치:'),
                AppSpacing.verticalSpaceSM,
                ButtonGroup(
                  isHorizontal: false,
                  children: [
                    PrimaryButton(
                      text: 'Google로 로그인',
                      icon: Icons.g_mobiledata,
                      onPressed: () => _showSnackBar('Google 로그인'),
                    ),
                    SecondaryButton(
                      text: 'Apple로 로그인',
                      icon: Icons.apple,
                      onPressed: () => _showSnackBar('Apple 로그인'),
                    ),
                    TertiaryButton(
                      text: '건너뛰기',
                      isFullWidth: true,
                      onPressed: () => _showSnackBar('건너뛰기'),
                    ),
                  ],
                ),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ==================== Real Use Cases ====================
            _buildSection(
              title: 'Real Use Cases',
              description: '실제 사용 사례 예시',
              children: [
                const Text('로그인 화면:'),
                AppSpacing.verticalSpaceSM,
                ButtonGroup(
                  isHorizontal: false,
                  children: [
                    PrimaryButton(
                      text: '로그인',
                      onPressed: () => _showSnackBar('로그인 시도'),
                    ),
                    TertiaryButton(
                      text: '회원가입',
                      isFullWidth: true,
                      onPressed: () => _showSnackBar('회원가입 화면으로 이동'),
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceMD,
                const Text('다이얼로그:'),
                AppSpacing.verticalSpaceSM,
                ButtonGroup(
                  children: [
                    SecondaryButton(
                      text: '아니오',
                      onPressed: () => _showSnackBar('취소'),
                    ),
                    PrimaryButton(
                      text: '예',
                      onPressed: () => _showSnackBar('확인'),
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceMD,
                const Text('폼 제출:'),
                AppSpacing.verticalSpaceSM,
                PrimaryButton(
                  text: '저장하기',
                  icon: Icons.save,
                  onPressed: () => _showSnackBar('저장 완료'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.verticalSpaceXS,
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        AppSpacing.verticalSpaceMD,
        ...children,
      ],
    );
  }
}

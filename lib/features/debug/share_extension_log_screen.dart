import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

/// Share Extension 로그 확인 화면
///
/// 백그라운드에서 Share Extension이 저장한 로그 파일을 확인하는 디버깅 화면
class ShareExtensionLogScreen extends StatefulWidget {
  const ShareExtensionLogScreen({super.key});

  @override
  State<ShareExtensionLogScreen> createState() =>
      _ShareExtensionLogScreenState();
}

/// 로그 엔트리 모델
class LogEntry {
  final String timestamp;
  final String message;
  final String? url;

  LogEntry({required this.timestamp, required this.message, this.url});
}

class _ShareExtensionLogScreenState extends State<ShareExtensionLogScreen> {
  static const MethodChannel _channel = MethodChannel('sharing_service');
  List<LogEntry> _logEntries = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  /// 로그 파일 읽기 및 파싱
  Future<void> _loadLog() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _channel.invokeMethod<String>('getShareLog');

      debugPrint('==== [로그 파일 읽기] ====');
      debugPrint('원본 로그 길이: ${result?.length ?? 0}자');
      debugPrint('원본 로그 내용:\n$result');
      debugPrint('========================');

      if (result == null || result.isEmpty) {
        setState(() {
          _logEntries = [];
          _errorMessage = '로그 파일이 비어있습니다';
          _isLoading = false;
        });
        return;
      }

      // 에러 메시지 체크
      if (result.contains('로그 파일이 없거나 읽을 수 없습니다')) {
        setState(() {
          _logEntries = [];
          _errorMessage = result;
          _isLoading = false;
        });
        return;
      }

      // 로그 파싱
      final entries = _parseLogContent(result);

      setState(() {
        _logEntries = entries;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('로그 읽기 실패: $e');
      setState(() {
        _logEntries = [];
        _errorMessage = '로그 읽기 실패: $e';
        _isLoading = false;
      });
    }
  }

  /// 로그 내용을 파싱하여 LogEntry 리스트로 변환
  List<LogEntry> _parseLogContent(String content) {
    final List<LogEntry> entries = [];

    // 줄바꿈으로 분리 (빈 줄 제외)
    final lines = content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    for (final line in lines) {
      // 형식: [날짜 시간] 메시지
      final match = RegExp(r'\[(.*?)\]\s*(.*)').firstMatch(line);

      if (match != null) {
        final timestamp = match.group(1) ?? '';
        final message = match.group(2) ?? '';

        // URL 추출 (http:// 또는 https://로 시작하는 URL)
        final urlMatch = RegExp(r'https?://[^\s]+').firstMatch(message);
        final url = urlMatch?.group(0);

        entries.add(LogEntry(timestamp: timestamp, message: message, url: url));

        debugPrint('파싱된 로그 - timestamp: $timestamp, url: $url');
      } else {
        // 타임스탬프 없는 로그 (예외 처리)
        debugPrint('파싱 실패한 로그: $line');
      }
    }

    return entries;
  }

  /// 로그 삭제
  Future<void> _clearLog() async {
    try {
      debugPrint('==== [로그 삭제 시작] ====');

      final result = await _channel.invokeMethod('clearShareLog');
      debugPrint('삭제 결과: $result');

      debugPrint('삭제 후 로그 다시 읽기...');
      await _loadLog();

      debugPrint('==== [로그 삭제 완료] ====');
    } catch (e) {
      debugPrint('로그 삭제 실패: $e');
    }
  }

  /// URL을 클립보드에 복사
  Future<void> _copyUrl(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'URL 복사 완료: $url',
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textColor1,
            ),
          ),
          backgroundColor: AppColors.surface,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Share Extension 로그'),
            Text(
              '최신 5개만 자동 유지 (현재: ${_logEntries.length}개)',
              style: AppTextStyles.caption12,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLog,
            tooltip: '새로고침',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearLog,
            tooltip: '로그 삭제',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildEmptyState(
        icon: Icons.error_outline,
        message: _errorMessage!,
      );
    }

    if (_logEntries.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox_outlined,
        message: '저장된 로그가 없습니다\n\n외부 앱에서 URL을 공유하면 여기에 로그가 표시됩니다',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _logEntries.length,
      itemBuilder: (context, index) {
        final entry = _logEntries[index];
        return _buildLogCard(entry, index);
      },
    );
  }

  /// 빈 상태 표시
  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64.w, color: AppColors.textSecondary),
            AppSpacing.verticalSpaceLG,
            Text(
              message,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 로그 카드 빌드
  Widget _buildLogCard(LogEntry entry, int index) {
    final bool hasUrl = entry.url != null && entry.url!.isNotEmpty;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      elevation: AppElevation.medium,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (타임스탬프 + 인덱스)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allSmall,
                  ),
                  child: Text(
                    '#${_logEntries.length - index}',
                    style: AppTextStyles.buttonMediumMedium14.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppSpacing.horizontalSpaceSM,
                Expanded(
                  child: Text(entry.timestamp, style: AppTextStyles.caption12),
                ),
                if (hasUrl)
                  Icon(Icons.link, size: 16.w, color: AppColors.success),
              ],
            ),

            AppSpacing.verticalSpaceMD,

            // 메시지 내용
            Text(entry.message, style: AppTextStyles.bodyRegular14),

            // URL 표시 (있는 경우)
            if (hasUrl) ...[
              AppSpacing.verticalSpaceMD,
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allSmall,
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 18.w, color: AppColors.success),
                    AppSpacing.horizontalSpaceSM,
                    Expanded(
                      child: Text(
                        entry.url!,
                        style: AppTextStyles.metaMedium12.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpacing.horizontalSpaceSM,
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        size: 18.w,
                        color: AppColors.success,
                      ),
                      onPressed: () => _copyUrl(entry.url!),
                      tooltip: 'URL 복사',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

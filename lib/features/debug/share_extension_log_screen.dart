import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

/// Share Extension 로그 확인 화면
///
/// 백그라운드에서 Share Extension이 저장한 로그 파일을 확인하는 디버깅 화면
class ShareExtensionLogScreen extends StatefulWidget {
  const ShareExtensionLogScreen({super.key});

  @override
  State<ShareExtensionLogScreen> createState() =>
      _ShareExtensionLogScreenState();
}

class _ShareExtensionLogScreenState extends State<ShareExtensionLogScreen> {
  static const MethodChannel _channel = MethodChannel('sharing_service');
  String _logContent = '로그를 불러오는 중...';
  bool _isLoading = true;
  int _logCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  /// 로그 파일 읽기
  Future<void> _loadLog() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _channel.invokeMethod<String>('getShareLog');

      // 로그 엔트리 개수 계산 (빈 줄 제외)
      final logLines = (result ?? '')
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      setState(() {
        _logContent = result ?? '로그 파일이 없습니다';
        _logCount = logLines.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _logContent = '로그 읽기 실패: $e';
        _logCount = 0;
        _isLoading = false;
      });
    }
  }

  /// 로그 삭제
  Future<void> _clearLog() async {
    try {
      await _channel.invokeMethod('clearShareLog');
      await _loadLog();
    } catch (e) {
      debugPrint('로그 삭제 실패: $e');
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
              '최신 5개만 자동 유지 (현재: $_logCount개)',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _logContent,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace', // 디버그 로그용 고정폭 폰트
                    color: AppColors.success,
                    height: 1.5,
                  ),
                ),
              ),
            ),
    );
  }
}

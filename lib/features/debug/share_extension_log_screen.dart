import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      setState(() {
        _logContent = result ?? '로그 파일이 없습니다';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _logContent = '로그 읽기 실패: $e';
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
        title: const Text('Share Extension 로그'),
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
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.sp,
                    color: Colors.greenAccent,
                    height: 1.5,
                  ),
                ),
              ),
            ),
    );
  }
}

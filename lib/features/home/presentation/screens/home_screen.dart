import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';

/// 홈 화면 위젯
/// 앱의 메인 화면이며, 공유 데이터를 받아서 처리하는 기능을 포함
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 공유 서비스 인스턴스
  late SharingService _sharingService;

  /// 공유 데이터 스트림 구독
  StreamSubscription<SharedData>? _sharingSubscription;

  /// 현재 받은 공유 데이터
  SharedData? _currentSharedData;

  /// 공유 데이터 처리 중 상태
  bool _isProcessingSharedData = false;

  @override
  void initState() {
    super.initState();
    // 공유 서비스 초기화 및 데이터 스트림 구독
    _initializeSharingService();
  }

  /// 공유 서비스 초기화 및 스트림 구독 설정
  Future<void> _initializeSharingService() async {
    _sharingService = SharingService.instance;

    // 공유 서비스 초기화 (iOS UserDefaults 또는 Android Intent 데이터 확인)
    await _sharingService.initialize();

    // 공유 데이터 스트림 구독
    _sharingSubscription = _sharingService.dataStream.listen(
      _handleSharedData,
      onError: (error) {
        debugPrint('[HomeScreen] 공유 데이터 스트림 에러: $error');
      },
    );

    // 이미 저장된 공유 데이터가 있는지 확인
    if (_sharingService.currentSharedData != null) {
      _handleSharedData(_sharingService.currentSharedData!);
    }
  }

  /// 공유 데이터 처리
  void _handleSharedData(SharedData sharedData) {
    debugPrint('[HomeScreen] 공유 데이터 수신: ${sharedData.toString()}');

    setState(() {
      _currentSharedData = sharedData;
      _isProcessingSharedData = true;
    });

    // 데이터 타입에 따른 처리
    if (sharedData.hasTextData) {
      // 텍스트/URL 데이터 처리
      _processTextData(sharedData.sharedTexts);
    }

    if (sharedData.hasMediaData) {
      // 미디어 파일 데이터 처리
      _processMediaFiles(sharedData.sharedFiles);
    }

    // 처리 완료 후 상태 업데이트
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessingSharedData = false;
        });
      }
    });
  }

  /// 텍스트/URL 데이터 처리
  void _processTextData(List<String> texts) {
    for (final text in texts) {
      debugPrint('[HomeScreen] 텍스트 데이터: $text');

      // URL인지 확인
      if (_sharingService.isValidUrl(text)) {
        debugPrint('[HomeScreen] URL 감지: $text');
        // TODO: URL에 따른 처리 (여행 정보 파싱 등)
      } else {
        debugPrint('[HomeScreen] 일반 텍스트: $text');
        // TODO: 일반 텍스트 처리 (여행 메모 등)
      }
    }
  }

  /// 미디어 파일 데이터 처리
  void _processMediaFiles(List<SharedMediaFile> files) {
    // 파일 타입별로 분류
    final images = files.where((f) => f.type == SharedMediaType.image).toList();
    final videos = files.where((f) => f.type == SharedMediaType.video).toList();
    final docs = files.where((f) => f.type == SharedMediaType.file).toList();

    if (images.isNotEmpty) {
      debugPrint('[HomeScreen] 이미지 ${images.length}개 수신');
      // TODO: 이미지 처리 (여행 사진 업로드 등)
    }

    if (videos.isNotEmpty) {
      debugPrint('[HomeScreen] 동영상 ${videos.length}개 수신');
      // TODO: 동영상 처리
    }

    if (docs.isNotEmpty) {
      debugPrint('[HomeScreen] 문서 ${docs.length}개 수신');
      // TODO: 문서 처리
    }
  }

  /// 공유 데이터 표시용 위젯 생성
  Widget _buildSharedDataDisplay() {
    if (_currentSharedData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.share_arrival_time,
                color: Colors.blue.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '공유 데이터 수신됨',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blue.shade700,
                ),
              ),
              const Spacer(),
              if (_isProcessingSharedData)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // 텍스트 데이터 표시
          if (_currentSharedData!.hasTextData) ...[
            Text(
              '텍스트 (${_currentSharedData!.sharedTexts.length}개):',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            ..._currentSharedData!.sharedTexts.map(
              (text) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  '• ${text.length > 50 ? '${text.substring(0, 50)}...' : text}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // 미디어 파일 정보 표시
          if (_currentSharedData!.hasMediaData) ...[
            Text(
              '미디어 파일 (${_currentSharedData!.sharedFiles.length}개):',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (_currentSharedData!.images.isNotEmpty)
                  _buildFileTypeChip(
                    Icons.image,
                    '이미지 ${_currentSharedData!.images.length}',
                  ),
                if (_currentSharedData!.videos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildFileTypeChip(
                      Icons.video_library,
                      '동영상 ${_currentSharedData!.videos.length}',
                    ),
                  ),
                if (_currentSharedData!.files.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildFileTypeChip(
                      Icons.description,
                      '파일 ${_currentSharedData!.files.length}',
                    ),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // 액션 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // 공유 데이터 삭제
                  setState(() {
                    _currentSharedData = null;
                  });
                  _sharingService.clearCurrentData();
                },
                child: const Text('닫기'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: 공유 데이터를 활용한 액션 (여행 생성 등)
                  debugPrint('[HomeScreen] 공유 데이터 활용 액션 실행');
                },
                child: const Text('여행 만들기'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 파일 타입 표시용 칩 위젯
  Widget _buildFileTypeChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CommonAppBar를 사용하여 일관된 AppBar UI 제공
      appBar: CommonAppBar.forHome(
        onMenuPressed: () {
          // 햄버거 메뉴 버튼을 눌렀을 때의 동작
          debugPrint('홈 화면 메뉴 버튼 클릭');
        },
        onNotificationPressed: () {
          // 알림 버튼을 눌렀을 때의 동작
          debugPrint('홈 화면 알림 버튼 클릭');
        },
      ),
      body: Column(
        children: [
          // 공유 데이터 표시 영역
          if (_currentSharedData != null) _buildSharedDataDisplay(),

          // 메인 콘텐츠 영역
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.of(context).navHome,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 디버깅용 버튼들
                  if (const bool.fromEnvironment('dart.vm.product') ==
                      false) ...[
                    ElevatedButton(
                      onPressed: () async {
                        // 수동으로 공유 데이터 확인 (iOS)
                        await _sharingService.checkForData();
                      },
                      child: const Text('공유 데이터 확인 (iOS)'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        // 모든 데이터 초기화 (테스트용)
                        await _sharingService.resetAllData();
                        setState(() {
                          _currentSharedData = null;
                        });
                      },
                      child: const Text('데이터 초기화 (테스트)'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 스트림 구독 해제
    _sharingSubscription?.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'core/services/sharing_service.dart';

void main() => runApp(MyApp());

/// 앱의 루트 위젯 - MaterialApp만 담당
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripTogether',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: 'Pretendard',
      ),
      home: HomePage(), // 홈페이지를 별도 위젯으로 분리
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 홈페이지 - 공유 데이터 관리와 화면 표시 담당
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  SharedData? _currentSharedData;
  bool _isInitialized = false;
  StreamSubscription<SharedData>? _sharingSubscription;

  @override
  void initState() {
    super.initState();
    debugPrint('[HomePage] initState 시작');

    // 앱 라이프사이클 관찰자 등록
    WidgetsBinding.instance.addObserver(this);

    _initializeSharing();
  }

  /// 공유 서비스 초기화 및 스트림 구독
  Future<void> _initializeSharing() async {
    try {
      debugPrint('[HomePage] 공유 서비스 초기화 시작');

      // SharingService 초기화
      await SharingService.instance.initialize();

      // 공유 데이터 스트림 구독
      _sharingSubscription = SharingService.instance.dataStream.listen(
        (SharedData data) {
          debugPrint('[HomePage] 공유 데이터 수신됨: ${data.toString()}');
          debugPrint('[HomePage] setState 호출 전');

          if (mounted) {
            setState(() {
              _currentSharedData = data;
            });

            // 공유 데이터 수신 시 사용자에게 알림 표시
            _showSharedDataNotification(data);

            debugPrint('[HomePage] setState 호출 완료');
          }
        },
        onError: (error) {
          debugPrint('[HomePage] 공유 스트림 오류: $error');
        },
      );

      setState(() {
        _isInitialized = true;
      });
      debugPrint('[HomePage] 공유 서비스 초기화 완료');
    } catch (error) {
      debugPrint('[HomePage] 공유 서비스 초기화 오류: $error');
    }
  }

  @override
  void dispose() {
    debugPrint('[HomePage] dispose 호출');

    // 앱 라이프사이클 관찰자 해제
    WidgetsBinding.instance.removeObserver(this);

    _sharingSubscription?.cancel();
    SharingService.instance.dispose();
    super.dispose();
  }

  /// 앱 라이프사이클 상태 변화 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('[HomePage] 앱 라이프사이클 변경: $state');

    // 앱이 백그라운드에서 포그라운드로 돌아올 때 데이터 확인
    if (state == AppLifecycleState.resumed) {
      debugPrint('[HomePage] 앱이 포그라운드로 복귀 - 공유 데이터 확인');
      _checkForNewData();
    }
  }

  /// 새로운 공유 데이터 확인
  Future<void> _checkForNewData() async {
    try {
      await SharingService.instance.checkForData();
    } catch (error) {
      debugPrint('[HomePage] 데이터 확인 오류: $error');
    }
  }

  /// 공유 데이터 수신 시 사용자 알림 표시
  void _showSharedDataNotification(SharedData data) {
    debugPrint('[HomePage] 공유 데이터 알림 표시');

    // 스낵바와 함께 진동(일부 기기에서 지원) 피드백 제공
    if (mounted) {
      // 공유된 컨텐츠 타입에 따른 메시지 생성
      String message = _getSharedDataMessage(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: '확인',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );

      debugPrint('[HomePage] 공유 데이터 알림 완료: $message');
    }
  }

  /// 공유된 데이터 타입에 따른 메시지 생성
  String _getSharedDataMessage(SharedData data) {
    if (data.hasTextData && data.hasMediaData) {
      return '텍스트 ${data.sharedTexts.length}개와 파일 ${data.sharedFiles.length}개가 공유되었습니다!';
    } else if (data.hasTextData) {
      if (data.sharedTexts.length == 1) {
        final text = data.sharedTexts.first;
        if (SharingService.instance.isValidUrl(text)) {
          return 'URL이 공유되었습니다!';
        } else {
          return '텍스트가 공유되었습니다!';
        }
      } else {
        return '텍스트 ${data.sharedTexts.length}개가 공유되었습니다!';
      }
    } else if (data.hasMediaData) {
      if (data.sharedFiles.length == 1) {
        final file = data.sharedFiles.first;
        switch (file.type) {
          case SharedMediaType.image:
            return '이미지가 공유되었습니다!';
          case SharedMediaType.video:
            return '동영상이 공유되었습니다!';
          case SharedMediaType.file:
            return '파일이 공유되었습니다!';
          default:
            return '컨텐츠가 공유되었습니다!';
        }
      } else {
        // 복수 파일의 경우 타입별 개수 표시
        final imageCount = data.images.length;
        final videoCount = data.videos.length;
        final fileCount = data.files.length;

        List<String> parts = [];
        if (imageCount > 0) parts.add('이미지 $imageCount개');
        if (videoCount > 0) parts.add('동영상 $videoCount개');
        if (fileCount > 0) parts.add('파일 $fileCount개');

        if (parts.isNotEmpty) {
          return '${parts.join(', ')}가 공유되었습니다!';
        } else {
          return '파일 ${data.sharedFiles.length}개가 공유되었습니다!';
        }
      }
    }

    return '컨텐츠가 공유되었습니다!';
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[HomePage] build 호출됨 - 데이터 있음: ${_currentSharedData != null}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripTogether - 공유 테스트'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  /// 수동 새로고침 처리
  Future<void> _onRefresh() async {
    debugPrint('[HomePage] 수동 새로고침 시작');
    await _checkForNewData();
  }

  /// 메인 화면 구성
  Widget _buildBody() {
    // 초기화 중일 때 로딩 표시
    if (!_isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              '공유 서비스 초기화 중...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 공유된 데이터가 없을 때
    if (_currentSharedData == null || !_currentSharedData!.hasData) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '다른 앱에서 콘텐츠를 공유해보세요!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '이미지, 동영상, 텍스트, 파일을 지원합니다.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '⬇️ 아래로 당겨서 새로고침',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataInfo(),
            const SizedBox(height: 20),
            if (_currentSharedData!.hasTextData) _buildTextSection(),
            if (_currentSharedData!.hasTextData &&
                _currentSharedData!.hasMediaData)
              const SizedBox(height: 20),
            if (_currentSharedData!.hasMediaData) _buildMediaSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// 데이터 정보 표시
  Widget _buildDataInfo() {
    final data = _currentSharedData!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 공유 데이터 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('수신 시간: ${data.receivedAt.toString().substring(0, 19)}'),
            Text('텍스트 개수: ${data.sharedTexts.length}'),
            Text('미디어 파일 개수: ${data.sharedFiles.length}'),
            if (data.hasMediaData) ...[
              Text('  - 이미지: ${data.images.length}개'),
              Text('  - 동영상: ${data.videos.length}개'),
              Text('  - 기타 파일: ${data.files.length}개'),
            ],
          ],
        ),
      ),
    );
  }

  /// 텍스트 섹션 구성
  Widget _buildTextSection() {
    final texts = _currentSharedData!.sharedTexts;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📝 공유된 텍스트/URL',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...texts.map(
              (text) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (SharingService.instance.isValidUrl(text))
                      const Text(
                        '🔗 URL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        '💬 텍스트',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(text, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 미디어 섹션 구성
  Widget _buildMediaSection() {
    final files = _currentSharedData!.sharedFiles;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📁 공유된 미디어 파일',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...files.map(
              (file) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getFileTypeIcon(file.type),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.path.split('/').last,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '경로: ${file.path}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (file.thumbnail != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '썸네일: ${file.thumbnail}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    if (file.duration != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '재생시간: ${(file.duration! / 1000).toStringAsFixed(1)}초',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 액션 버튼 구성
  Widget _buildActionButtons() {
    return Column(
      children: [
        // 첫 번째 줄: 새로고침 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              debugPrint('[HomePage] 수동 새로고침 버튼 클릭');

              // 로딩 스낵바 표시
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('공유 데이터 확인 중...'),
                  duration: Duration(seconds: 1),
                ),
              );

              await _checkForNewData();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('데이터 확인 완료'),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('새로고침'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.blue[700],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 두 번째 줄: 기존 버튼들
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // 모든 데이터 완전 초기화
                  await SharingService.instance.resetAllData();
                  setState(() {
                    _currentSharedData = null;
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('모든 공유 데이터가 초기화되었습니다'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('완전 초기화'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // 공유 처리 완료 (현재 데이터 지우기)
                  SharingService.instance.clearCurrentData();
                  setState(() {
                    _currentSharedData = null;
                  });

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('공유 처리 완료!')));
                },
                icon: const Icon(Icons.done),
                label: const Text('처리 완료'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 파일 타입별 아이콘 반환
  String _getFileTypeIcon(SharedMediaType type) {
    switch (type) {
      case SharedMediaType.image:
        return '🖼️ 이미지';
      case SharedMediaType.video:
        return '🎥 동영상';
      case SharedMediaType.file:
        return '📄 파일';
      case SharedMediaType.text:
        return '💬 텍스트';
      case SharedMediaType.url:
        return '🔗 URL';
    }
  }
}

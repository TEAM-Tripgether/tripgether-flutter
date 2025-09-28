import 'package:flutter/material.dart';
import 'dart:async';
import 'services/sharing_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<SharedData> _sharingSubscription;
  SharedData? _currentSharedData;

  @override
  void initState() {
    super.initState();
    _initializeSharing();
  }

  /// 공유 서비스 초기화
  Future<void> _initializeSharing() async {
    // SharingService 초기화
    await SharingService.instance.initialize();

    // 공유 데이터 스트림 구독
    _sharingSubscription = SharingService.instance.dataStream.listen(
      (SharedData data) {
        setState(() {
          _currentSharedData = data;
        });
        debugPrint('[MainApp] 공유 데이터 수신: ${data.toString()}');
      },
      onError: (error) {
        debugPrint('[MainApp] 공유 스트림 오류: $error');
      },
    );
  }

  @override
  void dispose() {
    _sharingSubscription.cancel();
    SharingService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripTogether',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: 'Pretendard',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TripTogether - 공유 테스트'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: _buildBody(),
      ),
    );
  }

  /// 메인 화면 구성
  Widget _buildBody() {
    if (_currentSharedData == null || !_currentSharedData!.hasData) {
      return const Center(
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
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataInfo(),
          const SizedBox(height: 20),
          if (_currentSharedData!.hasTextData) _buildTextSection(),
          if (_currentSharedData!.hasTextData && _currentSharedData!.hasMediaData)
            const SizedBox(height: 20),
          if (_currentSharedData!.hasMediaData) _buildMediaSection(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
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
            ...texts.map((text) => Container(
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
                  Text(
                    text,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )),
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
            ...files.map((file) => Container(
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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  if (file.duration != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '재생시간: ${(file.duration! / 1000).toStringAsFixed(1)}초',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// 액션 버튼 구성
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              SharingService.instance.clearCurrentData();
              setState(() {
                _currentSharedData = null;
              });
            },
            icon: const Icon(Icons.clear),
            label: const Text('데이터 초기화'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: 실제 처리 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('공유 처리 완료!')),
              );
            },
            icon: const Icon(Icons.done),
            label: const Text('처리 완료'),
          ),
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

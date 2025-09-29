import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 공유된 미디어 파일의 타입을 나타내는 열거형
enum SharedMediaType {
  image,
  video,
  file,
  text,
  url,
}

/// 공유된 미디어 파일 정보를 담는 클래스
class SharedMediaFile {
  final String path;
  final String? thumbnail;
  final double? duration;
  final SharedMediaType type;

  SharedMediaFile({
    required this.path,
    this.thumbnail,
    this.duration,
    required this.type,
  });

  @override
  String toString() {
    return 'SharedMediaFile(path: $path, thumbnail: $thumbnail, duration: $duration, type: $type)';
  }
}

/// 공유된 데이터를 나타내는 클래스
/// iOS Share Extension에서 전달된 데이터를 Flutter에서 사용할 수 있도록 변환
class SharedData {
  /// 공유된 미디어 파일 목록
  final List<SharedMediaFile> sharedFiles;

  /// 공유된 텍스트 목록 (URL 포함)
  final List<String> sharedTexts;

  /// 데이터가 수신된 시간
  final DateTime receivedAt;

  SharedData({
    required this.sharedFiles,
    required this.sharedTexts,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  /// 텍스트 데이터가 있는지 확인
  bool get hasTextData => sharedTexts.isNotEmpty;

  /// 미디어 파일이 있는지 확인
  bool get hasMediaData => sharedFiles.isNotEmpty;

  /// 공유된 데이터가 있는지 확인
  bool get hasData => hasTextData || hasMediaData;

  /// 첫 번째 텍스트 반환 (URL일 수 있음)
  String? get firstText => sharedTexts.isNotEmpty ? sharedTexts.first : null;

  /// 모든 이미지 파일만 필터링
  List<SharedMediaFile> get images =>
      sharedFiles.where((file) => file.type == SharedMediaType.image).toList();

  /// 모든 동영상 파일만 필터링
  List<SharedMediaFile> get videos =>
      sharedFiles.where((file) => file.type == SharedMediaType.video).toList();

  /// 모든 일반 파일만 필터링
  List<SharedMediaFile> get files =>
      sharedFiles.where((file) => file.type == SharedMediaType.file).toList();

  @override
  String toString() {
    return 'SharedData(files: ${sharedFiles.length}, texts: ${sharedTexts.length}, receivedAt: $receivedAt)';
  }
}

/// 공유 서비스 클래스
/// iOS와 Android에서 공유된 데이터를 통합 처리
class SharingService {
  static SharingService? _instance;

  /// 싱글톤 인스턴스 반환
  static SharingService get instance {
    _instance ??= SharingService._internal();
    return _instance!;
  }

  SharingService._internal();

  /// 공유 데이터 스트림 컨트롤러
  final StreamController<SharedData> _dataStreamController =
      StreamController<SharedData>.broadcast();

  /// 현재 공유된 데이터
  SharedData? _currentSharedData;

  /// iOS에서 공유 데이터 확인을 위한 타이머
  Timer? _sharingCheckTimer;

  /// Native 플랫폼 채널
  static const MethodChannel _channel = MethodChannel('sharing_service');

  /// 마지막으로 처리한 데이터의 해시값 (중복 방지용)
  String? _lastProcessedDataHash;


  /// 공유 데이터 스트림 (외부에서 구독 가능)
  Stream<SharedData> get dataStream => _dataStreamController.stream;

  /// 현재 공유된 데이터 반환
  SharedData? get currentSharedData => _currentSharedData;

  /// 공유 서비스 초기화
  /// 앱 시작 시 한 번만 호출해야 함
  Future<void> initialize() async {
    try {
      debugPrint('[SharingService] 공유 서비스 초기화 시작');

      if (Platform.isIOS) {
        // iOS에서는 주기적으로 UserDefaults 확인
        _startSharingCheck();

        // 앱 시작 시 기존 데이터 강제 처리 (중복 체크 무시)
        await _forceProcessInitialData();
      } else if (Platform.isAndroid) {
        // Android는 Intent를 통해 직접 처리됨 (기존 방식 유지)
        debugPrint('[SharingService] Android 공유는 Intent를 통해 처리됨');
      }

      debugPrint('[SharingService] 공유 서비스 초기화 완료');

    } catch (error) {
      debugPrint('[SharingService] 초기화 오류: $error');
    }
  }

  /// 앱 시작 시 기존 데이터 강제 처리 (중복 체크 무시)
  Future<void> _forceProcessInitialData() async {
    try {
      debugPrint('[SharingService] 초기 데이터 강제 처리 시작');

      // iOS UserDefaults에서 공유 데이터 읽기 시도
      final result = await _channel.invokeMethod('getSharedData');
      if (result != null) {
        debugPrint('[SharingService] 초기 데이터 발견: $result');

        // 해시값 생성
        final dataHash = result.toString().hashCode.toString();
        debugPrint('[SharingService] 초기 데이터 해시: $dataHash');

        // 중복 체크 없이 강제 처리
        final success = await _processSharedData(result, dataHash);
        if (success) {
          _lastProcessedDataHash = dataHash;
          debugPrint('[SharingService] ✅ 초기 데이터 처리 성공');
        } else {
          debugPrint('[SharingService] ❌ 초기 데이터 처리 실패');
        }
      } else {
        debugPrint('[SharingService] 초기 데이터 없음');
      }
    } catch (error) {
      debugPrint('[SharingService] 초기 데이터 처리 오류: $error');
    }
  }

  /// iOS에서 주기적으로 공유 데이터 확인
  void _startSharingCheck() {
    _sharingCheckTimer = Timer.periodic(
      const Duration(seconds: 2), // 1초 → 2초로 주기 증가
      (timer) => _checkForSharedData(),
    );
  }

  /// Timer 일시 정지 후 재시작 (데이터 처리 후 중복 방지)
  void _pauseAndRestartTimer() {
    debugPrint('[SharingService] Timer 일시 정지 후 재시작');

    // 기존 Timer 중단
    _sharingCheckTimer?.cancel();

    // 5초 후 재시작 (UserDefaults 동기화 시간 확보)
    Timer(const Duration(seconds: 5), () {
      if (Platform.isIOS) {
        debugPrint('[SharingService] Timer 재시작');
        _startSharingCheck();
      }
    });
  }

  /// iOS UserDefaults에서 공유 데이터 확인
  Future<void> _checkForSharedData() async {
    if (!Platform.isIOS) return;

    try {
      // iOS UserDefaults에서 공유 데이터 읽기 시도
      final result = await _channel.invokeMethod('getSharedData');
      if (result != null) {
        // 데이터 해시값 생성 (중복 체크용)
        final dataHash = result.toString().hashCode.toString();

        // 이미 처리한 데이터인지 확인
        if (_lastProcessedDataHash == dataHash) {
          debugPrint('[SharingService] 중복 데이터 무시: $dataHash');
          return;
        }

        debugPrint('[SharingService] iOS 공유 데이터 발견: $result');
        debugPrint('[SharingService] 데이터 해시: $dataHash');
        debugPrint('[SharingService] 데이터 타입: ${result.runtimeType}');

        // 데이터 처리 시도 (해시는 성공 후 저장)
        final success = await _processSharedData(result, dataHash);
        if (success) {
          _lastProcessedDataHash = dataHash;
          debugPrint('[SharingService] 데이터 처리 완료, 해시 저장: $dataHash');
        } else {
          debugPrint('[SharingService] 데이터 처리 실패: $dataHash');
        }
      }
    } catch (error) {
      debugPrint('[SharingService] 공유 데이터 확인 오류: $error');
    }
  }

  /// 공유 데이터 처리
  /// [data] 처리할 데이터 (보통 Map<String, dynamic>)
  /// [dataHash] 중복 체크용 해시값
  /// Returns: 처리 성공 여부
  Future<bool> _processSharedData(dynamic data, String dataHash) async {
    try {
      debugPrint('[SharingService] _processSharedData 시작');
      debugPrint('[SharingService] 받은 데이터: $data');
      debugPrint('[SharingService] 데이터 타입: ${data.runtimeType}');

      // 데이터 타입 검증 및 변환
      Map<String, dynamic> processedData;
      if (data is Map<String, dynamic>) {
        processedData = data;
      } else if (data is Map) {
        // Map을 Map<String, dynamic>으로 변환
        processedData = Map<String, dynamic>.from(data);
      } else {
        debugPrint('[SharingService] ❌ 지원하지 않는 데이터 타입: ${data.runtimeType}');
        return false;
      }

      debugPrint('[SharingService] 변환된 데이터: $processedData');
      final List<String> sharedTexts = [];
      final List<SharedMediaFile> sharedFiles = [];

      // 텍스트 데이터 처리
      if (processedData['texts'] != null) {
        final texts = List<String>.from(processedData['texts']);
        sharedTexts.addAll(texts);
        debugPrint('[SharingService] 텍스트 데이터 ${texts.length}개 처리됨');
      }

      // 미디어 파일 데이터 처리
      if (processedData['files'] != null) {
        final files = List<Map<String, dynamic>>.from(processedData['files']);
        for (final fileData in files) {
          final sharedFile = _parseSharedMediaFile(fileData);
          if (sharedFile != null) {
            sharedFiles.add(sharedFile);
          }
        }
        debugPrint('[SharingService] 미디어 파일 ${sharedFiles.length}개 처리됨');
      }

      // 데이터가 있으면 처리
      if (sharedTexts.isNotEmpty || sharedFiles.isNotEmpty) {
        final sharedData = SharedData(
          sharedFiles: sharedFiles,
          sharedTexts: sharedTexts,
        );

        _currentSharedData = sharedData;
        debugPrint('[SharingService] ✅ 스트림에 데이터 전달: ${sharedData.toString()}');
        _dataStreamController.add(sharedData);

        // iOS UserDefaults 클리어
        final clearSuccess = await _channel.invokeMethod('clearSharedData');
        debugPrint('[SharingService] UserDefaults 클리어 결과: $clearSuccess');

        if (clearSuccess != true) {
          debugPrint('[SharingService] ⚠️ 경고: UserDefaults 클리어 실패!');
        } else {
          // 클리어 성공 시 Timer를 일시 정지했다가 재시작
          _pauseAndRestartTimer();
        }

        return true; // 성공
      } else {
        debugPrint('[SharingService] ⚠️ 처리할 데이터가 없음');
        return false; // 데이터 없음
      }

    } catch (error) {
      debugPrint('[SharingService] ❌ 공유 데이터 처리 오류: $error');
      return false; // 실패
    }
  }

  /// SharedMediaFile 파싱
  SharedMediaFile? _parseSharedMediaFile(Map<String, dynamic> data) {
    try {
      final path = data['path'] as String?;
      final thumbnail = data['thumbnail'] as String?;
      final duration = data['duration'] as double?;
      final typeInt = data['type'] as int?;

      if (path == null || typeInt == null) return null;

      final type = SharedMediaType.values[typeInt];

      return SharedMediaFile(
        path: path,
        thumbnail: thumbnail,
        duration: duration,
        type: type,
      );
    } catch (error) {
      debugPrint('[SharingService] SharedMediaFile 파싱 오류: $error');
      return null;
    }
  }


  /// URL인지 확인하는 유틸리티 함수
  bool isValidUrl(String text) {
    try {
      final uri = Uri.parse(text);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// 파일 크기를 사람이 읽기 쉬운 형태로 변환
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 파일 확장자에서 미디어 타입 추론
  SharedMediaType getMediaTypeFromExtension(String path) {
    final extension = path.split('.').last.toLowerCase();

    // 이미지 확장자
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg', 'heic', 'heif'].contains(extension)) {
      return SharedMediaType.image;
    }

    // 동영상 확장자
    if (['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', 'm4v', '3gp'].contains(extension)) {
      return SharedMediaType.video;
    }

    // 나머지는 일반 파일로 처리
    return SharedMediaType.file;
  }

  /// 현재 공유 데이터 초기화
  void clearCurrentData() {
    _currentSharedData = null;
    debugPrint('[SharingService] 현재 공유 데이터 초기화 완료');
  }

  /// 모든 공유 데이터 완전 초기화 (테스트용)
  /// UserDefaults와 해시 모두 초기화
  Future<void> resetAllData() async {
    try {
      debugPrint('[SharingService] 모든 데이터 완전 초기화 시작');

      // 1. 현재 데이터 초기화
      _currentSharedData = null;

      // 2. 해시 초기화
      _lastProcessedDataHash = null;

      // 3. iOS UserDefaults 클리어
      if (Platform.isIOS) {
        final clearSuccess = await _channel.invokeMethod('clearSharedData');
        debugPrint('[SharingService] UserDefaults 강제 클리어 결과: $clearSuccess');
      }

      debugPrint('[SharingService] ✅ 모든 데이터 완전 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] ❌ 데이터 초기화 오류: $error');
    }
  }

  /// 서비스 종료 및 리소스 정리
  void dispose() {
    debugPrint('[SharingService] 서비스 종료 시작');

    _sharingCheckTimer?.cancel();
    _dataStreamController.close();
    _currentSharedData = null;

    debugPrint('[SharingService] 서비스 종료 완료');
  }
}
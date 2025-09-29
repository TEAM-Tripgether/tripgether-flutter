import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 공유된 미디어 파일의 타입을 나타내는 열거형
enum SharedMediaType { image, video, file, text, url }

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

  /// Native 플랫폼 채널
  static const MethodChannel _channel = MethodChannel('sharing_service');

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
        // 앱 시작 시 기존 데이터 처리
        await _processInitialData();
      } else if (Platform.isAndroid) {
        // Android는 Intent를 통해 직접 처리됨 (기존 방식 유지)
        debugPrint('[SharingService] Android 공유는 Intent를 통해 처리됨');
      }

      debugPrint('[SharingService] 공유 서비스 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] 초기화 오류: $error');
    }
  }

  /// 앱 시작 시 기존 데이터 처리
  Future<void> _processInitialData() async {
    try {
      debugPrint('[SharingService] 초기 데이터 처리 시작');

      // iOS UserDefaults에서 공유 데이터 읽기 시도
      final result = await _channel.invokeMethod('getSharedData');
      if (result != null) {
        debugPrint('[SharingService] 초기 데이터 발견: $result');

        // 데이터 처리 시도
        final success = await _processSharedData(result);
        if (success) {
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


  /// 공유 데이터 처리
  /// [data] 처리할 데이터 (보통 Map String, dynamic )
  /// Returns: 처리 성공 여부
  Future<bool> _processSharedData(dynamic data) async {
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
        try {
          debugPrint(
            '[SharingService] files 데이터 타입: ${processedData['files'].runtimeType}',
          );
          final filesList = processedData['files'] as List;
          debugPrint('[SharingService] files 배열 길이: ${filesList.length}');

          for (int i = 0; i < filesList.length; i++) {
            final item = filesList[i];
            debugPrint('[SharingService] 파일 $i 타입: ${item.runtimeType}');
            debugPrint('[SharingService] 파일 $i 데이터: $item');

            // 안전한 Map 타입 변환
            final fileData = Map<String, dynamic>.from(item as Map);
            debugPrint('[SharingService] 변환된 파일 데이터: $fileData');

            final sharedFile = _parseSharedMediaFile(fileData);
            if (sharedFile != null) {
              sharedFiles.add(sharedFile);
              debugPrint('[SharingService] 미디어 파일 추가 성공: ${sharedFile.path}');
            } else {
              debugPrint('[SharingService] ❌ 미디어 파일 파싱 실패');
            }
          }
          debugPrint('[SharingService] 총 ${sharedFiles.length}개 미디어 파일 처리 완료');
        } catch (error) {
          debugPrint('[SharingService] ❌ 미디어 파일 처리 오류: $error');
        }
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
      debugPrint('[SharingService] SharedMediaFile 파싱 시작: $data');

      final path = data['path'] as String?;
      final thumbnail = data['thumbnail'] as String?;
      final duration = data['duration'] as double?;
      final typeInt = data['type'] as int?;

      debugPrint(
        '[SharingService] 파싱된 필드들 - path: $path, type: $typeInt, thumbnail: $thumbnail, duration: $duration',
      );

      if (path == null || typeInt == null) {
        debugPrint('[SharingService] ❌ 필수 필드 누락 - path: $path, type: $typeInt');
        return null;
      }

      // 안전한 enum 인덱스 접근
      if (typeInt < 0 || typeInt >= SharedMediaType.values.length) {
        debugPrint('[SharingService] ❌ 잘못된 type 인덱스: $typeInt');
        return null;
      }

      final type = SharedMediaType.values[typeInt];
      debugPrint('[SharingService] 매핑된 타입: $type');

      final result = SharedMediaFile(
        path: path,
        thumbnail: thumbnail,
        duration: duration,
        type: type,
      );

      debugPrint(
        '[SharingService] ✅ SharedMediaFile 생성 성공: ${result.toString()}',
      );
      return result;
    } catch (error) {
      debugPrint('[SharingService] ❌ SharedMediaFile 파싱 오류: $error');
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
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 파일 확장자에서 미디어 타입 추론
  SharedMediaType getMediaTypeFromExtension(String path) {
    final extension = path.split('.').last.toLowerCase();

    // 이미지 확장자
    if ([
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'svg',
      'heic',
      'heif',
    ].contains(extension)) {
      return SharedMediaType.image;
    }

    // 동영상 확장자
    if ([
      'mp4',
      'mov',
      'avi',
      'mkv',
      'wmv',
      'flv',
      'm4v',
      '3gp',
    ].contains(extension)) {
      return SharedMediaType.video;
    }

    // 나머지는 일반 파일로 처리
    return SharedMediaType.file;
  }

  /// 수동으로 공유 데이터 확인
  /// 앱이 포그라운드로 돌아오거나 사용자가 새로고침할 때 호출
  Future<void> checkForData() async {
    if (!Platform.isIOS) return;

    try {
      debugPrint('[SharingService] 수동 데이터 확인 시작');

      // iOS UserDefaults에서 공유 데이터 읽기 시도
      final result = await _channel.invokeMethod('getSharedData');
      if (result != null) {
        debugPrint('[SharingService] 새로운 공유 데이터 발견: $result');

        // 데이터 처리 시도
        final success = await _processSharedData(result);
        if (success) {
          debugPrint('[SharingService] ✅ 수동 데이터 확인 처리 성공');
        } else {
          debugPrint('[SharingService] ❌ 수동 데이터 확인 처리 실패');
        }
      } else {
        debugPrint('[SharingService] 새로운 공유 데이터 없음');
      }
    } catch (error) {
      debugPrint('[SharingService] 수동 데이터 확인 오류: $error');
    }
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

    _dataStreamController.close();
    _currentSharedData = null;

    debugPrint('[SharingService] 서비스 종료 완료');
  }
}

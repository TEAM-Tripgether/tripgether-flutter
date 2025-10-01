import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  /// Native 플랫폼 채널 (iOS용)
  static const MethodChannel _channel = MethodChannel('sharing_service');

  /// 안드로이드 공유 스트림 구독 (임시 비활성화)
  // StreamSubscription<List<rsi.SharedMediaFile>>? _androidMediaSubscription;
  StreamSubscription<String>? _androidTextSubscription;

  /// iOS 앱 라이프사이클 리스너 (nullable로 변경하여 재초기화 가능)
  AppLifecycleListener? _appLifecycleListener;

  /// 지연 체크 타이머들 (정리가 필요한 모든 타이머 추적)
  final List<Timer> _delayedTimers = [];

  /// 디바운싱을 위한 타이머
  Timer? _debounceTimer;

  /// 서비스 일시정지 상태 (화면 전환 시 타이머 정지용)
  bool _isPaused = false;

  /// 마지막 체크 시간 (중복 호출 방지용)
  DateTime? _lastCheckTime;

  /// 최소 체크 간격 (1초)
  static const Duration _minCheckInterval = Duration(seconds: 1);

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
        // iOS: UserDefaults를 통한 데이터 처리
        await _processInitialData();

        // iOS: 앱 라이프사이클 리스너 추가 (포그라운드 전환 시 자동 체크)
        _setupAppLifecycleListener();

        // iOS: 추가적인 지연 체크 (Flutter 초기화 완료 후)
        _scheduleDelayedCheck();
      } else if (Platform.isAndroid) {
        // Android: MethodChannel을 통한 Intent 데이터 수신
        await _initializeAndroidMethodChannel();
      }

      debugPrint('[SharingService] 공유 서비스 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] 초기화 오류: $error');
    }
  }

  /// 안드로이드 MethodChannel 초기화
  /// MainActivity에서 Intent 데이터를 수신하여 처리
  Future<void> _initializeAndroidMethodChannel() async {
    try {
      debugPrint('[SharingService] 안드로이드 MethodChannel 초기화 시작');

      // MethodChannel 메서드 호출 리스너 설정
      _channel.setMethodCallHandler((call) async {
        debugPrint('==== [SharingService] MethodChannel 호출 받음 ====');
        debugPrint('[SharingService] 메서드: ${call.method}');
        debugPrint('[SharingService] 인자: ${call.arguments}');
        debugPrint('[SharingService] 인자 타입: ${call.arguments.runtimeType}');

        switch (call.method) {
          case 'onSharedData':
            debugPrint('[SharingService] onSharedData 메서드 처리 시작');
            debugPrint('[SharingService] 수신된 데이터: ${call.arguments}');
            try {
              await _processAndroidSharedData(call.arguments);
              debugPrint('[SharingService] onSharedData 처리 성공');
            } catch (e) {
              debugPrint('[SharingService] onSharedData 처리 중 오류: $e');
            }
            break;
          default:
            debugPrint('[SharingService] 지원하지 않는 메서드: ${call.method}');
        }
        debugPrint('==== [SharingService] MethodChannel 처리 완료 ====');
      });

      debugPrint('[SharingService] 안드로이드 MethodChannel 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] 안드로이드 MethodChannel 초기화 오류: $error');
    }
  }

  /// 안드로이드에서 받은 공유 데이터 처리
  Future<void> _processAndroidSharedData(dynamic arguments) async {
    try {
      debugPrint('==== [SharingService] 안드로이드 공유 데이터 처리 시작 ====');
      debugPrint('[SharingService] 원본 arguments: $arguments');
      debugPrint('[SharingService] arguments 타입: ${arguments.runtimeType}');

      if (arguments == null) {
        debugPrint('[SharingService] ❌ 공유 데이터가 null입니다');
        return;
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(arguments);
      final String type = data['type'] ?? '';

      debugPrint('[SharingService] ✅ 데이터 파싱 완료');
      debugPrint('[SharingService] 데이터 타입: $type');
      debugPrint('[SharingService] 전체 데이터 내용: $data');

      List<SharedMediaFile> sharedFiles = [];
      List<String> sharedTexts = [];

      switch (type) {
        case 'text':
          final String? text = data['text'];
          if (text != null && text.isNotEmpty) {
            sharedTexts.add(text);
            debugPrint('[SharingService] 텍스트 데이터 처리됨: $text');
          }
          break;

        case 'image':
        case 'video':
        case 'file':
          final String? uri = data['uri'];
          if (uri != null && uri.isNotEmpty) {
            final mediaType = _getMediaTypeFromString(type);
            final sharedFile = SharedMediaFile(
              path: uri,
              thumbnail: null,
              duration: null,
              type: mediaType,
            );
            sharedFiles.add(sharedFile);
            debugPrint('[SharingService] 미디어 파일 처리됨: $uri');
          }
          break;

        case 'multiple':
          final List<dynamic>? uris = data['uris'];
          final String? mimeType = data['mimeType'];

          if (uris != null && uris.isNotEmpty) {
            for (final uri in uris) {
              if (uri is String && uri.isNotEmpty) {
                final mediaType = _getMediaTypeFromMime(mimeType);
                final sharedFile = SharedMediaFile(
                  path: uri,
                  thumbnail: null,
                  duration: null,
                  type: mediaType,
                );
                sharedFiles.add(sharedFile);
              }
            }
            debugPrint('[SharingService] ${sharedFiles.length}개 파일 처리됨');
          }
          break;

        default:
          debugPrint('[SharingService] 지원하지 않는 데이터 타입: $type');
          return;
      }

      // SharedData 생성 및 스트림에 전달
      debugPrint('[SharingService] SharedData 생성 준비 중...');
      debugPrint('[SharingService] sharedFiles 개수: ${sharedFiles.length}');
      debugPrint('[SharingService] sharedTexts 개수: ${sharedTexts.length}');

      if (sharedFiles.isNotEmpty || sharedTexts.isNotEmpty) {
        final sharedData = SharedData(
          sharedFiles: sharedFiles,
          sharedTexts: sharedTexts,
        );

        debugPrint('[SharingService] ✅ SharedData 생성 완료');
        debugPrint('[SharingService] SharedData 내용: ${sharedData.toString()}');

        _currentSharedData = sharedData;

        debugPrint('[SharingService] 스트림에 데이터 추가 중...');
        _dataStreamController.add(sharedData);
        debugPrint('[SharingService] ✅ 스트림에 데이터 추가 완료');

        debugPrint(
          '[SharingService] 현재 스트림 리스너 수: ${_dataStreamController.hasListener ? "있음" : "없음"}',
        );
      } else {
        debugPrint(
          '[SharingService] ⚠️ 처리할 데이터가 없음 (파일: ${sharedFiles.length}, 텍스트: ${sharedTexts.length})',
        );
      }

      debugPrint('==== [SharingService] 안드로이드 공유 데이터 처리 종료 ====');
    } catch (error) {
      debugPrint('[SharingService] ❌ 안드로이드 공유 데이터 처리 오류: $error');
    }
  }

  /// 문자열 타입을 SharedMediaType으로 변환
  SharedMediaType _getMediaTypeFromString(String type) {
    switch (type) {
      case 'image':
        return SharedMediaType.image;
      case 'video':
        return SharedMediaType.video;
      case 'text':
        return SharedMediaType.text;
      default:
        return SharedMediaType.file;
    }
  }

  /// MIME 타입을 SharedMediaType으로 변환
  SharedMediaType _getMediaTypeFromMime(String? mimeType) {
    if (mimeType == null) return SharedMediaType.file;

    if (mimeType.startsWith('image/')) {
      return SharedMediaType.image;
    } else if (mimeType.startsWith('video/')) {
      return SharedMediaType.video;
    } else if (mimeType.startsWith('text/')) {
      return SharedMediaType.text;
    } else {
      return SharedMediaType.file;
    }
  }

  /// iOS 앱 시작 시 기존 데이터 처리
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

  /// iOS 앱 라이프사이클 리스너 설정
  /// 앱이 포그라운드로 전환될 때마다 자동으로 공유 데이터 확인
  void _setupAppLifecycleListener() {
    if (!Platform.isIOS) return;

    try {
      debugPrint('[SharingService] iOS 앱 라이프사이클 리스너 설정');

      _appLifecycleListener = AppLifecycleListener(
        onResume: () {
          debugPrint('[SharingService] 앱이 포그라운드로 전환됨 - 디바운싱 체크 실행');
          // 디바운싱으로 중복 호출 방지
          _debouncedCheckForData();
        },
        onShow: () {
          debugPrint('[SharingService] 앱이 표시됨 - 디바운싱 체크 실행');
          // 디바운싱으로 중복 호출 방지
          _debouncedCheckForData();
        },
      );

      debugPrint('[SharingService] ✅ iOS 앱 라이프사이클 리스너 설정 완료');
    } catch (error) {
      debugPrint('[SharingService] ❌ 앱 라이프사이클 리스너 설정 오류: $error');
    }
  }

  /// Flutter 초기화 완료 후 지연 체크 스케줄링
  /// 앱 시작 직후에는 데이터가 감지되지 않을 수 있으므로 추가 체크
  void _scheduleDelayedCheck() {
    if (!Platform.isIOS) return;

    try {
      debugPrint('[SharingService] 지연 체크 타이머 설정');

      // 1초, 3초, 5초 후에 추가로 체크
      final delays = [1000, 3000, 5000];

      for (int i = 0; i < delays.length; i++) {
        final timer = Timer(Duration(milliseconds: delays[i]), () {
          // 일시정지 상태가 아닐 때만 실행
          if (!_isPaused) {
            debugPrint(
              '[SharingService] 지연 체크 실행 (${delays[i]}ms 후) - 디바운싱 적용',
            );
            // 디바운싱으로 중복 호출 방지
            _debouncedCheckForData();
          }
        });

        // 타이머를 목록에 추가하여 추적
        _delayedTimers.add(timer);
      }

      debugPrint('[SharingService] ✅ 지연 체크 타이머 ${delays.length}개 설정 완료');
    } catch (error) {
      debugPrint('[SharingService] ❌ 지연 체크 타이머 설정 오류: $error');
    }
  }

  /// 디바운싱된 공유 데이터 확인
  /// 중복 호출을 방지하고 효율적으로 데이터를 체크합니다
  void _debouncedCheckForData() {
    if (!Platform.isIOS || _isPaused) return;

    try {
      debugPrint('[SharingService] 디바운싱 체크 요청됨');

      // 기존 디바운스 타이머 취소
      _debounceTimer?.cancel();

      // 새 타이머로 1초 후 실행 (여러 호출을 하나로 합침)
      _debounceTimer = Timer(const Duration(seconds: 1), () {
        // 일시정지 상태가 아닐 때만 실행
        if (!_isPaused) {
          _performCheckIfNeeded();
        }
      });

      debugPrint('[SharingService] 디바운스 타이머 설정됨 (1초 후 실행)');
    } catch (error) {
      debugPrint('[SharingService] 디바운싱 설정 오류: $error');
    }
  }

  /// 필요한 경우에만 실제 데이터 확인 수행
  /// 마지막 체크로부터 최소 간격이 지났을 때만 실행
  Future<void> _performCheckIfNeeded() async {
    if (!Platform.isIOS || _isPaused) return;

    try {
      final now = DateTime.now();

      // 마지막 체크로부터 최소 간격 확인
      if (_lastCheckTime != null &&
          now.difference(_lastCheckTime!) < _minCheckInterval) {
        debugPrint(
          '[SharingService] 중복 체크 방지: 마지막 체크로부터 ${now.difference(_lastCheckTime!).inMilliseconds}ms 경과 (최소 ${_minCheckInterval.inMilliseconds}ms 필요)',
        );
        return;
      }

      // 마지막 체크 시간 업데이트
      _lastCheckTime = now;

      debugPrint('[SharingService] 실제 데이터 체크 수행');
      await checkForData();
    } catch (error) {
      debugPrint('[SharingService] 조건부 체크 수행 오류: $error');
    }
  }

  /// 수동으로 공유 데이터 확인
  /// 앱이 포그라운드로 돌아오거나 사용자가 새로고침할 때 호출
  Future<void> checkForData() async {
    if (!Platform.isIOS || _isPaused) return;

    try {
      debugPrint('[SharingService] 데이터 확인 시작 (자동/수동)');

      // iOS UserDefaults에서 공유 데이터 읽기 시도
      final result = await _channel.invokeMethod('getSharedData');
      if (result != null) {
        debugPrint('[SharingService] 새로운 공유 데이터 발견: $result');

        // 데이터 처리 시도
        final success = await _processSharedData(result);
        if (success) {
          debugPrint('[SharingService] ✅ 데이터 확인 처리 성공');
        } else {
          debugPrint('[SharingService] ❌ 데이터 확인 처리 실패');
        }
      } else {
        debugPrint('[SharingService] 새로운 공유 데이터 없음');
      }
    } catch (error) {
      debugPrint('[SharingService] 데이터 확인 오류: $error');
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

  /// 서비스 일시정지 (화면에서 벗어날 때 호출)
  /// 모든 타이머와 lifecycle 리스너를 정지하여 리소스 절약
  void pause() {
    try {
      debugPrint('[SharingService] 서비스 일시정지 시작');

      _isPaused = true;

      // 모든 지연 타이머 정리
      for (final timer in _delayedTimers) {
        timer.cancel();
      }
      _delayedTimers.clear();

      // 디바운스 타이머 정리
      _debounceTimer?.cancel();
      _debounceTimer = null;

      // iOS 앱 라이프사이클 리스너 정리
      if (Platform.isIOS && _appLifecycleListener != null) {
        _appLifecycleListener!.dispose();
        _appLifecycleListener = null;
      }

      debugPrint(
        '[SharingService] ✅ 서비스 일시정지 완료 (타이머 ${_delayedTimers.length}개 정리됨)',
      );
    } catch (error) {
      debugPrint('[SharingService] ❌ 서비스 일시정지 오류: $error');
    }
  }

  /// 서비스 재개 (화면으로 돌아올 때 호출)
  /// 일시정지된 기능들을 다시 활성화
  void resume() {
    try {
      debugPrint('[SharingService] 서비스 재개 시작');

      _isPaused = false;

      // iOS에서만 라이프사이클 리스너 재설정
      if (Platform.isIOS && _appLifecycleListener == null) {
        _setupAppLifecycleListener();

        // 재개 시 즉시 한 번 체크
        _debouncedCheckForData();
      }

      debugPrint('[SharingService] ✅ 서비스 재개 완료');
    } catch (error) {
      debugPrint('[SharingService] ❌ 서비스 재개 오류: $error');
    }
  }

  /// 서비스 종료 및 리소스 정리
  void dispose() {
    debugPrint('[SharingService] 서비스 종료 시작');

    // 안드로이드 스트림 구독 해제 (현재 비활성화)
    // _androidMediaSubscription?.cancel();
    _androidTextSubscription?.cancel();

    // 모든 지연 타이머 정리
    for (final timer in _delayedTimers) {
      timer.cancel();
    }
    _delayedTimers.clear();

    // 디바운스 타이머 정리
    _debounceTimer?.cancel();

    // iOS 앱 라이프사이클 리스너 정리
    if (Platform.isIOS && _appLifecycleListener != null) {
      try {
        _appLifecycleListener!.dispose();
        _appLifecycleListener = null;
        debugPrint('[SharingService] iOS 라이프사이클 리스너 정리 완료');
      } catch (e) {
        debugPrint('[SharingService] iOS 라이프사이클 리스너 정리 오류: $e');
      }
    }

    _dataStreamController.close();
    _currentSharedData = null;
    _isPaused = true;

    debugPrint('[SharingService] 서비스 종료 완료');
  }
}

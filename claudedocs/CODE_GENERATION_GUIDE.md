# 코드 자동 생성 시스템 사용 가이드

Tripgether 프로젝트에서 사용하는 코드 자동 생성 도구 및 사용 방법을 안내합니다.

## 📚 목차

1. [개요](#개요)
2. [필수 패키지](#필수-패키지)
3. [데이터 모델 작성 (Freezed + JSON Serializable)](#데이터-모델-작성)
4. [Provider 작성 (Riverpod Generator)](#provider-작성)
5. [코드 생성 명령어](#코드-생성-명령어)
6. [실전 예제](#실전-예제)
7. [문제 해결](#문제-해결)
8. [모범 사례](#모범-사례)

---

## 개요

### 왜 코드 자동 생성을 사용하나요?

프로젝트에서 다음 3가지 코드 자동 생성 시스템을 사용합니다:

| 도구 | 용도 | 장점 |
|------|------|------|
| **Freezed** | 불변 데이터 클래스 생성 | `copyWith`, `==`, `hashCode` 자동 생성 |
| **JSON Serializable** | JSON 직렬화/역직렬화 | `fromJson`, `toJson` 자동 생성 |
| **Riverpod Generator** | Provider 보일러플레이트 제거 | `@riverpod` 어노테이션으로 간결한 코드 |

**효과:**
- ✅ 보일러플레이트 코드 약 70% 감소
- ✅ 타입 안정성 보장
- ✅ 휴먼 에러 방지
- ✅ 개발 생산성 향상

---

## 필수 패키지

### pubspec.yaml 설정

```yaml
dependencies:
  # 런타임 어노테이션
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  riverpod_annotation: ^2.6.1

dev_dependencies:
  # 코드 생성 엔진
  build_runner: ^2.4.14

  # 코드 생성기
  freezed: ^2.5.7
  json_serializable: ^6.9.2
  riverpod_generator: ^2.6.2
```

### 설치 명령어

```bash
flutter pub get
```

---

## 데이터 모델 작성

Freezed와 JSON Serializable을 함께 사용하여 불변 데이터 모델을 생성합니다.

### 기본 패턴

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

// 생성될 파일 선언
part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 사용자 데이터 모델
@freezed
class User with _$User {
  const User._();  // private constructor (커스텀 메서드용)

  const factory User({
    required String id,
    required String name,
    required String email,
    String? profileImageUrl,  // nullable 필드
    @Default(false) bool isVerified,  // 기본값 설정
    required DateTime createdAt,
  }) = _User;

  /// JSON 역직렬화
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 커스텀 getter 예시
  String get displayName => name.isEmpty ? email : name;
}
```

### Enum 사용

```dart
/// 사용자 역할
enum UserRole {
  @JsonValue('admin')
  admin('관리자'),

  @JsonValue('user')
  user('일반 사용자'),

  @JsonValue('guest')
  guest('게스트');

  final String displayName;
  const UserRole(this.displayName);
}
```

### 더미 데이터 생성 팩토리

```dart
@freezed
class User with _$User {
  // ... (위 코드와 동일)

  /// 더미 데이터 생성
  static User dummy({
    required String id,
    required String name,
  }) {
    return User(
      id: id,
      name: name,
      email: '$id@example.com',
      profileImageUrl: 'https://i.pravatar.cc/150?u=$id',
      isVerified: id.hashCode % 2 == 0,
      createdAt: DateTime.now().subtract(Duration(days: id.hashCode % 30)),
    );
  }
}

/// 더미 데이터 헬퍼 클래스
class UserDummyData {
  static List<User> getSampleUsers() {
    return [
      User.dummy(id: '1', name: '김철수'),
      User.dummy(id: '2', name: '이영희'),
      User.dummy(id: '3', name: '박민수'),
    ];
  }
}
```

### 실제 프로젝트 예시

```dart
// lib/features/home/data/models/place_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

/// 저장된 장소 데이터 모델
@freezed
class SavedPlace with _$SavedPlace {
  const SavedPlace._();

  const factory SavedPlace({
    required String id,
    required String name,
    required PlaceCategory category,
    required String address,
    String? detailAddress,
    required double latitude,
    required double longitude,
    String? description,
    required List<String> imageUrls,
    double? rating,
    int? reviewCount,
    String? businessHours,
    String? phoneNumber,
    required DateTime savedAt,
    @Default(false) bool isVisited,
    @Default(false) bool isFavorite,
  }) = _SavedPlace;

  factory SavedPlace.fromJson(Map<String, dynamic> json) =>
      _$SavedPlaceFromJson(json);

  /// 거리 표시용 포맷터
  String get distanceText {
    final distance = (id.hashCode % 50) / 10;
    return distance < 1
        ? '${(distance * 1000).toInt()}m'
        : '${distance.toStringAsFixed(1)}km';
  }
}

/// 장소 카테고리
enum PlaceCategory {
  @JsonValue('restaurant')
  restaurant('음식점', '🍽️'),

  @JsonValue('cafe')
  cafe('카페', '☕'),

  @JsonValue('attraction')
  attraction('관광지', '🏛️');

  final String displayName;
  final String emoji;
  const PlaceCategory(this.displayName, this.emoji);
}
```

---

## Provider 작성

Riverpod Generator를 사용하여 Provider를 간결하게 작성합니다.

### 기본 패턴

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 생성될 파일 선언
part 'user_provider.g.dart';

/// 사용자 목록 Provider
@riverpod
class UserList extends _$UserList {
  @override
  FutureOr<List<User>> build() async {
    // 초기 데이터 로드
    return await _fetchUsers();
  }

  /// 사용자 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _fetchUsers();
    });
  }

  /// 사용자 추가
  Future<void> addUser(User user) async {
    final previousState = state;

    // Optimistic update
    state = AsyncValue.data([...?state.value, user]);

    try {
      await _saveUser(user);
    } catch (e) {
      // 실패 시 이전 상태로 복원
      state = previousState;
      rethrow;
    }
  }

  Future<List<User>> _fetchUsers() async {
    // API 호출 로직
    await Future.delayed(const Duration(seconds: 1));
    return UserDummyData.getSampleUsers();
  }

  Future<void> _saveUser(User user) async {
    // API 호출 로직
  }
}
```

### Simple Provider (상태 없음)

```dart
/// 현재 사용자 ID Provider
@riverpod
String currentUserId(CurrentUserIdRef ref) {
  // 단순한 값 반환
  return 'user_123';
}

/// 사용자 Repository Provider
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository();
}
```

### 실제 프로젝트 예시

```dart
// lib/features/auth/providers/login_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/auth/google_auth_service.dart';

part 'login_provider.g.dart';

/// 로그인 상태 관리 Provider
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  FutureOr<void> build() {
    // 초기 상태: 아무것도 하지 않음
  }

  /// 이메일/비밀번호 로그인
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint('[LoginProvider] 🔄 이메일 로그인 시도...');

    // 로딩 상태로 전환
    state = const AsyncValue.loading();

    try {
      // API 호출 (현재는 더미)
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('[LoginProvider] ✅ 이메일 로그인 성공!');

      // ✅ 성공 시 state를 변경하지 않고 바로 true 반환
      return true;
    } catch (e, stack) {
      // ❌ 에러 발생 시에만 state를 에러로 설정
      state = AsyncValue.error(e, stack);
      debugPrint('[LoginProvider] ❌ 이메일 로그인 실패: $e');
      return false;
    }
  }

  /// 구글 로그인
  Future<bool> loginWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      final googleUser = await GoogleAuthService.signIn();

      if (googleUser == null) {
        debugPrint('[LoginProvider] ℹ️ 구글 로그인 취소됨');
        state = const AsyncValue.data(null);
        return false;
      }

      final googleAuth = googleUser.authentication;

      debugPrint('[LoginProvider] ✅ 구글 로그인 성공!');

      // ✅ 성공 시 state를 변경하지 않고 바로 true 반환
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
```

---

## 코드 생성 명령어

### 일회성 코드 생성

```bash
# 전체 코드 생성 (Freezed + JSON Serializable + Riverpod)
dart run build_runner build

# 기존 생성 파일과 충돌 시 강제 재생성
dart run build_runner build --delete-conflicting-outputs
```

### Watch 모드 (개발 중 권장)

```bash
# 파일 변경 감지 시 자동 코드 생성
dart run build_runner watch

# 충돌 시 자동 삭제 옵션
dart run build_runner watch --delete-conflicting-outputs
```

### 생성 파일 정리

```bash
# 생성된 파일 모두 삭제
dart run build_runner clean
```

---

## 실전 예제

### 시나리오: 새로운 Trip 모델 추가하기

#### 1단계: 모델 파일 생성

`lib/features/trip/data/models/trip_model.dart` 생성:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

/// 여행 정보 모델
@freezed
class Trip with _$Trip {
  const Trip._();

  const factory Trip({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> participants,
    @Default([]) List<String> placeIds,
    @Default(false) bool isPublic,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  /// 여행 기간 (일)
  int get durationDays => endDate.difference(startDate).inDays + 1;

  /// 여행 기간 텍스트
  String get durationText => '$durationDays일';
}
```

#### 2단계: 코드 생성

```bash
# Watch 모드로 자동 생성 (권장)
dart run build_runner watch --delete-conflicting-outputs

# 또는 일회성 생성
dart run build_runner build --delete-conflicting-outputs
```

#### 3단계: 생성 결과 확인

다음 파일들이 자동 생성됩니다:
- `trip_model.freezed.dart` - Freezed 코드 (copyWith, ==, hashCode 등)
- `trip_model.g.dart` - JSON Serializable 코드 (fromJson, toJson)

#### 4단계: Provider 생성

`lib/features/trip/providers/trip_provider.dart` 생성:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/trip_model.dart';

part 'trip_provider.g.dart';

@riverpod
class TripList extends _$TripList {
  @override
  FutureOr<List<Trip>> build() async {
    return await _fetchTrips();
  }

  Future<void> addTrip(Trip trip) async {
    state = AsyncValue.data([...?state.value, trip]);
    // TODO: API 호출
  }

  Future<List<Trip>> _fetchTrips() async {
    // TODO: API 호출
    return [];
  }
}
```

#### 5단계: UI에서 사용

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripListProvider);

    return tripsAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('오류: $error'),
      data: (trips) => ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return ListTile(
            title: Text(trip.title),
            subtitle: Text(trip.durationText),
          );
        },
      ),
    );
  }
}
```

---

## 문제 해결

### 1. "part of 파일을 찾을 수 없습니다" 에러

**원인:** 코드가 아직 생성되지 않았습니다.

**해결:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. "Conflicting outputs" 에러

**원인:** 기존 생성 파일과 새로운 생성 내용이 충돌합니다.

**해결:**
```bash
# 옵션 1: 강제 재생성
dart run build_runner build --delete-conflicting-outputs

# 옵션 2: 기존 파일 삭제 후 재생성
dart run build_runner clean
dart run build_runner build
```

### 3. Provider 이름이 예상과 다름

**원인:** Riverpod Generator는 클래스 이름 + `Provider` 패턴을 사용합니다.

**예시:**
```dart
// 클래스 이름: LoginNotifier
@riverpod
class LoginNotifier extends _$LoginNotifier { }

// 자동 생성된 Provider 이름: loginNotifierProvider
final provider = loginNotifierProvider;
```

**규칙:**
- `XxxNotifier` → `xxxNotifierProvider`
- `XxxService` → `xxxServiceProvider`
- 일반 함수 → `함수이름Provider`

### 4. JSON 직렬화 실패

**원인:** `@JsonKey` 어노테이션 누락 또는 타입 불일치

**해결:**
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,

    // DateTime은 자동 직렬화됨
    required DateTime createdAt,

    // 커스텀 직렬화가 필요한 경우
    @JsonKey(name: 'user_name')  // API 필드명 매핑
    required String name,

    @JsonKey(defaultValue: false)  // null 시 기본값
    required bool isActive,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 5. Watch 모드가 변경을 감지하지 못함

**원인:** 파일 시스템 감시 제한

**해결:**
```bash
# Watch 모드 재시작
# Ctrl+C로 종료 후
dart run build_runner watch --delete-conflicting-outputs

# 또는 일회성 생성 사용
dart run build_runner build --delete-conflicting-outputs
```

---

## 모범 사례

### ✅ DO: 권장 사항

#### 1. 항상 private constructor 사용

```dart
@freezed
class User with _$User {
  const User._();  // ✅ 커스텀 메서드를 위한 private constructor

  const factory User({ ... }) = _User;

  // 커스텀 getter 사용 가능
  String get fullName => '$firstName $lastName';
}
```

#### 2. Enum에 displayName 추가

```dart
enum Status {
  @JsonValue('active')
  active('활성'),  // ✅ 표시용 텍스트 포함

  @JsonValue('inactive')
  inactive('비활성');

  final String displayName;
  const Status(this.displayName);
}
```

#### 3. 더미 데이터 팩토리 메서드 작성

```dart
@freezed
class User with _$User {
  // ... 기본 factory

  /// ✅ 테스트/개발용 더미 데이터 생성
  static User dummy({required String id}) {
    return User(
      id: id,
      name: 'User $id',
      email: 'user$id@example.com',
      createdAt: DateTime.now(),
    );
  }
}
```

#### 4. API 응답 모델에 한국어 주석 작성

```dart
/// 사용자 정보 모델
///
/// API 응답:
/// ```json
/// {
///   "id": "user123",
///   "name": "홍길동",
///   "email": "hong@example.com"
/// }
/// ```
@freezed
class User with _$User {
  // ✅ 명확한 문서화
}
```

#### 5. Watch 모드 사용 (개발 중)

```bash
# ✅ 파일 저장 시 자동 코드 생성
dart run build_runner watch --delete-conflicting-outputs
```

### ❌ DON'T: 피해야 할 사항

#### 1. 생성 파일을 수동으로 편집하지 마세요

```dart
// ❌ trip_model.g.dart 파일을 직접 수정
// 다음 코드 생성 시 덮어써집니다!

// ✅ 대신 원본 모델 파일을 수정하세요
// trip_model.dart에서 수정 → 코드 재생성
```

#### 2. 성공 시 AsyncNotifier state를 변경하지 마세요

```dart
@riverpod
class LoginNotifier extends _$LoginNotifier {
  Future<bool> login() async {
    state = const AsyncValue.loading();

    try {
      // API 호출

      // ❌ 화면 전환 시 "Future already completed" 에러 발생
      state = const AsyncValue.data(null);
      return true;

      // ✅ 성공 시 state 변경 없이 바로 반환
      return true;
    } catch (e, stack) {
      // ✅ 에러만 state에 설정
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}
```

#### 3. part 파일 선언 순서를 지키세요

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

// ✅ 올바른 순서
part 'user_model.freezed.dart';
part 'user_model.g.dart';

// ❌ 잘못된 순서 (컴파일 에러 발생 가능)
part 'user_model.g.dart';
part 'user_model.freezed.dart';
```

#### 4. 생성 파일을 .gitignore에 추가하지 마세요

```gitignore
# ❌ 생성 파일을 ignore하지 마세요
# *.g.dart
# *.freezed.dart

# ✅ 생성 파일도 커밋해야 팀원들이 바로 사용 가능
```

---

## 추가 자료

### 공식 문서

- [Freezed](https://pub.dev/packages/freezed)
- [JSON Serializable](https://pub.dev/packages/json_serializable)
- [Riverpod Generator](https://riverpod.dev/docs/concepts/about_code_generation)
- [Build Runner](https://pub.dev/packages/build_runner)

### 프로젝트 예시 파일

- `lib/features/home/data/models/sns_content_model.dart` - Freezed 기본 패턴
- `lib/features/home/data/models/place_model.dart` - 복잡한 모델 예시
- `lib/features/course_market/data/models/course_model.dart` - 커스텀 getter 활용
- `lib/features/auth/providers/login_provider.dart` - AsyncNotifier 패턴
- `lib/core/providers/locale_provider.dart` - 간단한 Notifier 패턴

---

## 요약

### 빠른 시작 체크리스트

- [ ] pubspec.yaml에 패키지 추가 완료
- [ ] 모델 파일 작성 (`@freezed`, `part` 선언)
- [ ] Provider 파일 작성 (`@riverpod`, `part` 선언)
- [ ] `dart run build_runner build --delete-conflicting-outputs` 실행
- [ ] 생성된 파일 확인 (.freezed.dart, .g.dart)
- [ ] UI에서 Provider 사용 (ref.watch, ref.read)
- [ ] 커밋 및 푸시

### 개발 워크플로우

```bash
# 1. Watch 모드 시작 (터미널 1)
dart run build_runner watch --delete-conflicting-outputs

# 2. 코드 작성 및 저장 → 자동 코드 생성

# 3. 앱 실행 (터미널 2)
flutter run

# 4. 문제 발생 시
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

**문서 버전:** 1.0
**마지막 업데이트:** 2025-01-13
**작성자:** Tripgether Team

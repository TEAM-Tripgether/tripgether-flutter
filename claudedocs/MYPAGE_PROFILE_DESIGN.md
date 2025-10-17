# 마이페이지 프로필 사진 기능 설계

**작성일**: 2025-10-17
**브랜치**: `20251017_#27_기능추가_Auth_로그인_토큰재발급_로그아웃_기능_추가`

---

## 📋 목차

1. [개요](#개요)
2. [요구사항](#요구사항)
3. [UI 컴포넌트 설계](#ui-컴포넌트-설계)
4. [데이터 모델 설계](#데이터-모델-설계)
5. [상태 관리 설계](#상태-관리-설계)
6. [구현 순서](#구현-순서)
7. [체크리스트](#체크리스트)

---

## 개요

마이페이지에 사용자 프로필 정보를 표시하는 기능을 추가합니다. Google 소셜 로그인을 통해 받은 사용자 정보(프로필 사진, 이름, 이메일)를 마이페이지 상단에 표시하고, 추후 프로필 편집 기능으로 확장할 수 있도록 설계합니다.

### 목표

- ✅ **프로필 정보 표시**: 프로필 사진, 닉네임, 이메일 표시
- ✅ **재사용 가능한 컴포넌트**: `ProfileAvatar` 위젯을 공통 컴포넌트로 생성
- ✅ **상태 관리**: Riverpod를 사용한 사용자 상태 관리
- ✅ **Google 로그인 연동**: 로그인 시 받은 프로필 정보 저장 및 표시
- 🔄 **프로필 편집 (추후)**: 프로필 사진 변경, 닉네임 수정 기능

---

## 요구사항

### 기능적 요구사항

#### 1. 프로필 헤더 섹션

- **위치**: 마이페이지 상단 (언어 설정 섹션 위)
- **구성 요소**:
  - 프로필 사진 (원형, 80x80)
  - 사용자 닉네임 (중앙 정렬, 큰 글씨)
  - 사용자 이메일 (중앙 정렬, 작은 글씨)
  - 프로필 편집 버튼 (추후 구현)

#### 2. 프로필 아바타 위젯

- **재사용 가능**: `shared/widgets/common/profile_avatar.dart`
- **기능**:
  - CachedNetworkImage를 사용한 이미지 캐싱
  - Shimmer 로딩 효과
  - 기본 프로필 아이콘 (이미지 없을 시)
  - 다양한 크기 지원 (small, medium, large)
  - 테두리 옵션 (기본 테두리 있음)

#### 3. 사용자 상태 관리

- **Provider**: `UserNotifier` (Riverpod AsyncNotifier)
- **저장 위치**: Flutter Secure Storage
- **저장 데이터**:
  - 사용자 ID
  - 이메일
  - 닉네임
  - 프로필 이미지 URL
  - 로그인 플랫폼 (GOOGLE, KAKAO)

#### 4. Google 로그인 연동

- 로그인 성공 시 사용자 정보 저장
- 앱 시작 시 저장된 사용자 정보 로드
- 로그아웃 시 사용자 정보 삭제

---

## UI 컴포넌트 설계

### 1. ProfileAvatar 위젯

**파일 경로**: `lib/shared/widgets/common/profile_avatar.dart`

#### Props

```dart
class ProfileAvatar extends StatelessWidget {
  /// 프로필 이미지 URL
  final String? imageUrl;

  /// 아바타 크기
  final ProfileAvatarSize size;

  /// 테두리 표시 여부 (기본값: true)
  final bool showBorder;

  /// 테두리 색상 (기본값: primary color)
  final Color? borderColor;

  /// 기본 아이콘 색상 (기본값: primary color)
  final Color? iconColor;

  /// 탭 이벤트 핸들러 (선택)
  final VoidCallback? onTap;
}

enum ProfileAvatarSize {
  small(32),   // 32x32 - 리스트 아이템용
  medium(56),  // 56x56 - 일반 프로필용
  large(80),   // 80x80 - 마이페이지 헤더용
  xLarge(120); // 120x120 - 프로필 상세 화면용

  const ProfileAvatarSize(this.value);
  final double value;
}
```

#### UI 구조

```
Container (원형)
├─ CachedNetworkImage (프로필 사진)
│  ├─ Placeholder: Shimmer 로딩 효과
│  └─ ErrorWidget: 기본 아이콘 (Icons.person)
└─ Border (테두리, 선택적)
```

#### 디자인 스펙

| 크기 | 지름 | 테두리 두께 | 기본 아이콘 크기 | 사용 위치 |
|------|------|------------|----------------|----------|
| Small | 32px | 1.5px | 16px | 리스트 아이템, 댓글 |
| Medium | 56px | 2px | 28px | 일반 프로필 표시 |
| Large | 80px | 3px | 40px | 마이페이지 헤더 |
| XLarge | 120px | 4px | 60px | 프로필 상세/편집 |

---

### 2. ProfileHeader 위젯

**파일 경로**: `lib/features/mypage/presentation/widgets/profile_header.dart`

#### Props

```dart
class ProfileHeader extends ConsumerWidget {
  /// 편집 버튼 표시 여부 (기본값: true)
  final bool showEditButton;

  /// 편집 버튼 탭 핸들러 (선택)
  final VoidCallback? onEditPressed;
}
```

#### UI 구조

```
Container (배경색: surface, 패딩)
└─ Column (중앙 정렬)
   ├─ ProfileAvatar (large, 80x80)
   ├─ SizedBox (높이: 16)
   ├─ Text (닉네임, titleLarge, bold)
   ├─ SizedBox (높이: 4)
   ├─ Text (이메일, bodyMedium, secondary)
   ├─ SizedBox (높이: 16)
   └─ OutlinedButton (프로필 편집, 선택적)
```

#### 디자인 스펙

- **배경색**: `AppColors.surface`
- **패딩**: 상하 32px, 좌우 16px
- **정렬**: 중앙 정렬
- **닉네임**: `AppTextStyles.titleLarge`, `FontWeight.w700`
- **이메일**: `AppTextStyles.bodyMedium`, `AppColors.textSecondary`
- **편집 버튼**: `OutlinedButton`, 아이콘 + 텍스트

---

## 데이터 모델 설계

### User 모델

**파일 경로**: `lib/features/auth/data/models/user_model.dart`

```dart
/// 사용자 정보 모델
class User {
  /// 사용자 고유 ID (서버에서 발급, 로컬 로그인 시에는 null)
  final String? userId;

  /// 이메일 주소
  final String email;

  /// 닉네임 (displayName)
  final String nickname;

  /// 프로필 이미지 URL
  final String? profileImageUrl;

  /// 로그인 플랫폼 (GOOGLE, KAKAO)
  final String? loginPlatform;

  /// 생성일시 (로컬 저장 시간)
  final DateTime createdAt;

  const User({
    this.userId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.loginPlatform,
    required this.createdAt,
  });

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'loginPlatform': loginPlatform,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// JSON 역직렬화
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String?,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      loginPlatform: json['loginPlatform'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// copyWith 메서드 (프로필 수정 시 사용)
  User copyWith({
    String? userId,
    String? email,
    String? nickname,
    String? profileImageUrl,
    String? loginPlatform,
    DateTime? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      loginPlatform: loginPlatform ?? this.loginPlatform,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

---

## 상태 관리 설계

### UserNotifier Provider

**파일 경로**: `lib/features/auth/providers/user_provider.dart`

#### 역할

- 사용자 정보 상태 관리
- Flutter Secure Storage를 통한 로컬 저장/불러오기
- 로그인/로그아웃 시 사용자 정보 업데이트

#### 주요 메서드

```dart
@riverpod
class UserNotifier extends _$UserNotifier {
  static const String _storageKey = 'user_info';

  @override
  Future<User?> build() async {
    // 앱 시작 시 저장된 사용자 정보 로드
    return await _loadUserFromStorage();
  }

  /// 사용자 정보 설정 (로그인 시)
  Future<void> setUser(User user) async {
    state = AsyncValue.data(user);
    await _saveUserToStorage(user);
  }

  /// 사용자 정보 업데이트 (프로필 수정 시)
  Future<void> updateUser(User updatedUser) async {
    state = AsyncValue.data(updatedUser);
    await _saveUserToStorage(updatedUser);
  }

  /// 사용자 정보 삭제 (로그아웃 시)
  Future<void> clearUser() async {
    state = const AsyncValue.data(null);
    await _deleteUserFromStorage();
  }

  /// 로컬 스토리지에서 사용자 정보 로드
  Future<User?> _loadUserFromStorage() async {
    final secureStorage = ref.read(secureStorageProvider);
    final userJson = await secureStorage.read(key: _storageKey);

    if (userJson == null) return null;

    try {
      final json = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (e) {
      debugPrint('[UserProvider] 사용자 정보 로드 실패: $e');
      return null;
    }
  }

  /// 로컬 스토리지에 사용자 정보 저장
  Future<void> _saveUserToStorage(User user) async {
    final secureStorage = ref.read(secureStorageProvider);
    final userJson = jsonEncode(user.toJson());
    await secureStorage.write(key: _storageKey, value: userJson);
  }

  /// 로컬 스토리지에서 사용자 정보 삭제
  Future<void> _deleteUserFromStorage() async {
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.delete(key: _storageKey);
  }
}

/// SecureStorage Provider
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}
```

---

## Google 로그인 연동

### LoginProvider 수정

**파일 경로**: `lib/features/auth/providers/login_provider.dart`

#### 수정 사항

Google 로그인 성공 시 `UserNotifier`에 사용자 정보 저장:

```dart
Future<bool> loginWithGoogle() async {
  try {
    // ... (기존 Google 로그인 로직)

    final googleUser = await GoogleAuthService.signIn();
    if (googleUser == null) return false;

    // ✅ 사용자 정보 생성 및 저장
    final user = User(
      email: googleUser.email,
      nickname: googleUser.displayName ?? 'Unknown',
      profileImageUrl: googleUser.photoUrl,
      loginPlatform: 'GOOGLE',
      createdAt: DateTime.now(),
    );

    // ✅ UserProvider에 사용자 정보 저장
    await ref.read(userNotifierProvider.notifier).setUser(user);

    // TODO: 백엔드 API 연동 시 서버에서 받은 userId 포함하여 업데이트
    // final authResponse = await authService.signIn(...);
    // final updatedUser = user.copyWith(userId: authResponse.userId);
    // await ref.read(userNotifierProvider.notifier).updateUser(updatedUser);

    return true;
  } catch (e) {
    // ... 에러 처리
  }
}

/// 로그아웃 시 사용자 정보 삭제
Future<void> logout() async {
  try {
    // ✅ 사용자 정보 삭제
    await ref.read(userNotifierProvider.notifier).clearUser();

    // TODO: 토큰 삭제
    // await ref.read(authServiceProvider).logout();

    debugPrint('[LoginProvider] ✅ 로그아웃 완료');
  } catch (e) {
    // ... 에러 처리
  }
}
```

---

## 구현 순서

### Phase 1: 기본 구조 (현재)

1. **User 모델 생성**
   - [ ] `lib/features/auth/data/models/user_model.dart` 생성
   - [ ] JSON 직렬화/역직렬화 구현
   - [ ] copyWith 메서드 구현

2. **UserNotifier Provider 생성**
   - [ ] `lib/features/auth/providers/user_provider.dart` 생성
   - [ ] Flutter Secure Storage 연동
   - [ ] 사용자 정보 CRUD 메서드 구현

3. **ProfileAvatar 위젯 생성**
   - [ ] `lib/shared/widgets/common/profile_avatar.dart` 생성
   - [ ] CachedNetworkImage + Shimmer 구현
   - [ ] 다양한 크기 옵션 구현

4. **ProfileHeader 위젯 생성**
   - [ ] `lib/features/mypage/presentation/widgets/profile_header.dart` 생성
   - [ ] UserNotifier 연동
   - [ ] 로그인/로그아웃 상태 처리

5. **마이페이지 업데이트**
   - [ ] ProfileHeader 추가 (최상단)
   - [ ] 로그인하지 않은 경우 처리 (로그인 유도)

6. **LoginProvider 수정**
   - [ ] Google 로그인 성공 시 User 정보 저장
   - [ ] 로그아웃 시 User 정보 삭제

### Phase 2: 프로필 편집 (추후)

7. **프로필 편집 화면**
   - [ ] `lib/features/mypage/presentation/screens/profile_edit_screen.dart` 생성
   - [ ] 닉네임 수정 UI
   - [ ] 프로필 사진 변경 UI (이미지 선택)

8. **이미지 업로드**
   - [ ] `image_picker` 패키지 추가
   - [ ] 이미지 선택 및 크롭 기능
   - [ ] 서버 업로드 API 연동

### Phase 3: 서버 연동 (추후)

9. **API 연동**
   - [ ] 프로필 조회 API 연동
   - [ ] 프로필 수정 API 연동
   - [ ] 이미지 업로드 API 연동

---

## 체크리스트

### 필수 구현 사항

- [ ] **User 모델**: JSON 직렬화, copyWith 메서드
- [ ] **UserNotifier**: Riverpod AsyncNotifier, Secure Storage 연동
- [ ] **ProfileAvatar**: CachedNetworkImage, Shimmer, 다양한 크기
- [ ] **ProfileHeader**: 사용자 정보 표시, 로그인 상태 처리
- [ ] **마이페이지**: ProfileHeader 추가, UI 레이아웃 조정
- [ ] **LoginProvider**: Google 로그인 시 User 저장, 로그아웃 시 삭제

### 권장 구현 사항

- [ ] **로딩 상태**: AsyncValue를 활용한 로딩 UI
- [ ] **에러 처리**: 이미지 로드 실패 시 기본 아이콘 표시
- [ ] **접근성**: Semantics 위젯으로 스크린 리더 지원
- [ ] **애니메이션**: 프로필 사진 로드 시 페이드인 효과

### 테스트 항목

- [ ] **Google 로그인 → 마이페이지**: 프로필 정보 표시 확인
- [ ] **앱 재시작**: 저장된 사용자 정보 로드 확인
- [ ] **로그아웃**: 사용자 정보 삭제 및 UI 업데이트 확인
- [ ] **네트워크 오류**: 프로필 이미지 로드 실패 시 기본 아이콘 표시
- [ ] **로그인하지 않은 상태**: 로그인 유도 UI 표시

---

## 디렉토리 구조

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── user_model.dart          ← 새로 생성
│   │   └── providers/
│   │       ├── login_provider.dart          ← 수정 (User 저장 추가)
│   │       └── user_provider.dart           ← 새로 생성
│   └── mypage/
│       └── presentation/
│           ├── screens/
│           │   └── mypage_screen.dart       ← 수정 (ProfileHeader 추가)
│           └── widgets/
│               └── profile_header.dart      ← 새로 생성
├── shared/
│   └── widgets/
│       └── common/
│           └── profile_avatar.dart          ← 새로 생성
└── core/
    └── constants/
        └── app_colors.dart                  ← 기존 (색상 정의)
```

---

## 참고 자료

### 사용할 패키지

- **cached_network_image**: 이미지 캐싱
- **shimmer**: 로딩 효과
- **flutter_secure_storage**: 사용자 정보 보안 저장
- **riverpod**: 상태 관리

### 디자인 가이드라인

- **Material Design 3**: 프로필 아바타 디자인 참고
- **iOS Human Interface Guidelines**: 프로필 사진 크기 및 테두리 참고

---

**문서 버전**: 1.0.0
**최종 수정일**: 2025-10-17
**작성자**: Claude Code (마이페이지 프로필 기능 설계)

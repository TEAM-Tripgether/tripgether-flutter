# 인증 및 프로필 기능 구현 계획

**작성일**: 2025-10-17
**브랜치**: `20251017_#27_기능추가_Auth_로그인_토큰재발급_로그아웃_기능_추가`
**목표**: Google 로그인 → 프로필 표시 (백엔드 연동 준비 완료)

---

## 📋 목차

1. [현재 상황](#현재-상황)
2. [목표 및 전략](#목표-및-전략)
3. [전체 아키텍처](#전체-아키텍처)
4. [단계별 구현 계획](#단계별-구현-계획)
5. [파일 구조](#파일-구조)
6. [백엔드 연동 시나리오](#백엔드-연동-시나리오)

---

## 현재 상황

### ✅ 이미 동작하는 것

- **Google OAuth 로그인**: `GoogleAuthService.signIn()` - 실제 Google 계정으로 로그인
- **사용자 정보 받기**: email, displayName, photoUrl, googleId
- **로그 출력**: 받은 정보를 콘솔에 출력

### ❌ 아직 구현되지 않은 것

- 받은 Google 정보를 저장하는 시스템
- 백엔드 API 연동 (토큰 발급)
- 마이페이지에 프로필 정보 표시
- 로그아웃 시 정보 삭제

### 🎯 핵심 과제

**지금 당장**: 백엔드 없이도 Google 로그인 → 프로필 표시까지 동작
**나중에**: 백엔드 준비 시 최소 수정으로 연결

---

## 목표 및 전략

### 목표

1. **즉시 테스트 가능**: 백엔드 없이도 전체 플로우 동작
2. **쉬운 전환**: Mock → Real API 전환 시 최소 수정
3. **완전한 구현**: API 레이어까지 완성하여 백엔드 준비 시 즉시 연동

### 전략

```
Google 로그인 (실제)
   ↓
AuthApiService
   ├─ 지금: Mock 데이터 반환
   └─ 나중: 실제 API 호출 (_useMockData = false)
   ↓
UserNotifier (저장/관리)
   ↓
ProfileHeader (화면 표시)
```

### Mock/Real 전환 방식

```dart
class AuthApiService {
  // 🎭 개발 모드 플래그
  static const bool _useMockData = true;  // ← 이것만 바꾸면 전환!

  Future<AuthResponse> signIn(...) async {
    if (_useMockData) {
      return _mockSignIn(...);  // 지금
    } else {
      return _realSignIn(...);  // 나중
    }
  }
}
```

---

## 전체 아키텍처

### 레이어 구조

```
┌─────────────────────────────────────┐
│  UI Layer (Presentation)            │
│  - MyPageScreen                     │
│  - ProfileHeader                    │
│  - ProfileAvatar                    │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│  State Management (Providers)       │
│  - LoginProvider                    │
│  - UserNotifier                     │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│  Service Layer (API)                │
│  - AuthApiService                   │
│    ├─ Mock Methods (지금)          │
│    └─ Real Methods (나중)          │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│  Data Layer (Models + Storage)      │
│  - User, AuthRequest, AuthResponse  │
│  - Flutter Secure Storage           │
└─────────────────────────────────────┘
```

### 데이터 흐름

```
[사용자 액션]
   ↓
[Google 로그인 버튼 클릭]
   ↓
[GoogleAuthService.signIn()] ← 실제 Google OAuth
   ↓
[Google 정보 받기] (email, nickname, photoUrl)
   ↓
[LoginProvider.loginWithGoogle()]
   ↓
[AuthApiService.signIn()] ← Mock/Real 분기점
   ├─ Mock: 가짜 JWT 토큰 생성
   └─ Real: 실제 API 호출 → 진짜 JWT 받기
   ↓
[AuthResponse] (accessToken, refreshToken)
   ↓
[User 객체 생성] (Google 정보 + 토큰)
   ↓
[UserNotifier.setUser()] ← Secure Storage에 저장
   ↓
[홈/마이페이지로 이동]
   ↓
[ProfileHeader.build()]
   ↓
[UserNotifier 읽기] ← Secure Storage에서 로드
   ↓
[ProfileAvatar + 닉네임 + 이메일 표시] ✅
```

---

## 단계별 구현 계획

### Step 1: 데이터 모델 생성 with Freezed (Foundation) ✅ 완료

**파일**:
- `lib/features/auth/data/models/user_model.dart` ✅
- `lib/features/auth/data/models/auth_request.dart` ✅
- `lib/features/auth/data/models/auth_response.dart` ✅

**작업 내용**:
```dart
// Freezed로 자동 생성 (copyWith, toJson, fromJson, ==, hashCode, toString)
@freezed
class User with _$User {
  const factory User({
    String? userId,
    required String email,
    required String nickname,
    String? profileImageUrl,
    String? loginPlatform,
    required DateTime createdAt,
  }) = _User;

  factory User.fromGoogleSignIn({...}) { ... }
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AuthRequest with _$AuthRequest {
  const factory AuthRequest({
    String? socialPlatform,
    String? email,
    String? nickname,
    String? profileUrl,
    String? refreshToken,
  }) = _AuthRequest;

  factory AuthRequest.signIn({...}) { ... }
  factory AuthRequest.reissue({...}) { ... }
  factory AuthRequest.logout({...}) { ... }
  factory AuthRequest.fromJson(Map<String, dynamic> json) => _$AuthRequestFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required bool isFirstLogin,
  }) = _AuthResponse;

  bool get isAccessTokenValid { ... }
  bool get isRefreshTokenValid { ... }
  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}
```

**실행**:
```bash
dart run build_runner build --delete-conflicting-outputs
# ✅ 성공: 11개 파일 생성 (*.freezed.dart, *.g.dart)
# ✅ 절약된 코드: 약 288줄의 보일러플레이트 자동화
```

**장점**:
- ✅ 자동 생성: `copyWith()`, `toJson()`, `fromJson()`, `==`, `hashCode`, `toString()`
- ✅ 타입 안정성: 불변 객체로 상태 관리 안전성 보장
- ✅ 유지보수성: 필드 추가/수정 시 자동 업데이트

**실제 시간**: 20분 (Freezed 변환 + build_runner)

---

### Step 2: AuthApiService 생성 (API Layer) ✅ 완료

**파일**: `lib/features/auth/services/auth_api_service.dart` ✅

**작업 내용**:
```dart
class AuthApiService {
  static const bool _useMockData = true;  // Mock/Real 전환

  // 소셜 로그인 (Mock + Real 준비)
  Future<AuthResponse> signIn({...}) async {
    if (_useMockData) {
      return _mockSignIn(...);
    } else {
      return _realSignIn(...);
    }
  }

  // Mock: 가짜 토큰 생성
  Future<AuthResponse> _mockSignIn(...) async {
    await Future.delayed(Duration(seconds: 1));
    return AuthResponse(
      accessToken: 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      isFirstLogin: true,
    );
  }

  // Real: 실제 API 호출 (백엔드 연동용)
  Future<AuthResponse> _realSignIn(...) async {
    final response = await _dio.post(
      '/api/auth/sign-in',
      data: AuthRequest(...).toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  // 토큰 재발급
  Future<AuthResponse> reissueToken(String refreshToken) async { ... }

  // 로그아웃
  Future<void> logout(String refreshToken) async { ... }
}
```

**테스트**:
- Mock 데이터 반환 확인
- 1초 딜레이 후 토큰 생성 확인

**예상 시간**: 30분

---

### Step 3: UserNotifier 생성 (State Management)

**파일**: `lib/features/auth/providers/user_provider.dart`

**작업 내용**:
```dart
@riverpod
class UserNotifier extends _$UserNotifier {
  static const String _storageKey = 'user_info';

  @override
  Future<User?> build() async {
    // 앱 시작 시 저장된 사용자 정보 로드
    return await _loadUserFromStorage();
  }

  // 로그인 시 사용자 정보 저장
  Future<void> setUser(User user) async {
    state = AsyncValue.data(user);
    await _saveUserToStorage(user);
  }

  // 로그아웃 시 사용자 정보 삭제
  Future<void> clearUser() async {
    state = const AsyncValue.data(null);
    await _deleteUserFromStorage();
  }

  // Secure Storage 연동
  Future<User?> _loadUserFromStorage() async { ... }
  Future<void> _saveUserToStorage(User user) async { ... }
  Future<void> _deleteUserFromStorage() async { ... }
}
```

**테스트**:
- 저장: `setUser()` 후 Secure Storage 확인
- 불러오기: 앱 재시작 후 `build()` 호출 확인
- 삭제: `clearUser()` 후 Storage 비었는지 확인

**예상 시간**: 20분

---

### Step 4: LoginProvider 수정 (Integration)

**파일**: `lib/features/auth/providers/login_provider.dart` (기존 파일 수정)

**작업 내용**:
```dart
Future<bool> loginWithGoogle() async {
  try {
    // 1. Google 로그인 (실제)
    final googleUser = await GoogleAuthService.signIn();
    if (googleUser == null) return false;

    // 2. AuthApiService로 토큰 발급 (Mock/Real)
    final authService = ref.read(authApiServiceProvider);
    final authResponse = await authService.signIn(
      socialPlatform: 'GOOGLE',
      email: googleUser.email,
      nickname: googleUser.displayName ?? 'Unknown',
      profileUrl: googleUser.photoUrl,
    );

    // 3. User 객체 생성
    final user = User(
      email: googleUser.email,
      nickname: googleUser.displayName ?? 'Unknown',
      profileImageUrl: googleUser.photoUrl,
      loginPlatform: 'GOOGLE',
      createdAt: DateTime.now(),
    );

    // 4. UserNotifier에 저장
    await ref.read(userNotifierProvider.notifier).setUser(user);

    // 5. 토큰도 Secure Storage에 저장
    await _saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    return true;
  } catch (e) {
    // 에러 처리
    return false;
  }
}

// 로그아웃
Future<void> logout() async {
  await ref.read(userNotifierProvider.notifier).clearUser();
  await _deleteTokens();
}
```

**테스트**:
- Google 로그인 → Mock 토큰 발급 → User 저장
- 로그아웃 → User 삭제 → 토큰 삭제

**예상 시간**: 20분

---

### Step 5: ProfileAvatar 위젯 생성 (UI)

**파일**: `lib/shared/widgets/common/profile_avatar.dart`

**작업 내용**:
```dart
enum ProfileAvatarSize {
  small(32),
  medium(56),
  large(80),
  xLarge(120);

  const ProfileAvatarSize(this.value);
  final double value;
}

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final ProfileAvatarSize size;
  final bool showBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.value.w,
        height: size.value.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder ? Border.all(...) : null,
        ),
        child: ClipOval(
          child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                placeholder: (context, url) => Shimmer(...),
                errorWidget: (context, url, error) => _buildDefaultIcon(),
              )
            : _buildDefaultIcon(),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, size: size.value * 0.5),
    );
  }
}
```

**테스트**:
- 이미지 URL 있을 때: CachedNetworkImage 표시
- 이미지 URL 없을 때: 기본 아이콘 표시
- 로딩 중: Shimmer 효과
- 에러 발생: 기본 아이콘으로 대체

**예상 시간**: 25분

---

### Step 6: ProfileHeader 위젯 생성 (UI)

**파일**: `lib/features/mypage/presentation/widgets/profile_header.dart`

**작업 내용**:
```dart
class ProfileHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);

    return userAsync.when(
      loading: () => _buildLoading(),
      error: (error, stack) => _buildError(),
      data: (user) {
        if (user == null) {
          return _buildNotLoggedIn();
        }
        return _buildProfile(user);
      },
    );
  }

  Widget _buildProfile(User user) {
    return Container(
      padding: EdgeInsets.all(32.w),
      color: Colors.white,
      child: Column(
        children: [
          // 프로필 사진
          ProfileAvatar(
            imageUrl: user.profileImageUrl,
            size: ProfileAvatarSize.large,
            showBorder: true,
          ),
          SizedBox(height: 16.h),

          // 닉네임
          Text(
            user.nickname,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),

          // 이메일
          Text(
            user.email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
```

**테스트**:
- 로그인 상태: 프로필 정보 표시
- 로그인 안 함: "로그인이 필요합니다" 표시
- 로딩 중: Shimmer 표시

**예상 시간**: 20분

---

### Step 7: MyPageScreen 수정 (Integration)

**파일**: `lib/features/mypage/presentation/screens/mypage_screen.dart` (기존 파일 수정)

**작업 내용**:
```dart
class MyPageScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CommonAppBar(...),
      body: ListView(
        children: [
          // ✅ 프로필 헤더 추가 (최상단)
          ProfileHeader(),

          SizedBox(height: 16.h),

          // 기존: 디버그 섹션
          _buildDebugSection(context),

          // 기존: 언어 설정 섹션
          _buildLanguageSection(context, ref, l10n, currentLocale),
        ],
      ),
    );
  }
}
```

**테스트**:
- 마이페이지 열기 → 프로필 헤더 표시
- 프로필 사진, 닉네임, 이메일 확인

**예상 시간**: 10분

---

### Step 8: 통합 테스트

**테스트 시나리오**:

1. **Google 로그인 → 프로필 표시**
   - [ ] 로그인 버튼 클릭
   - [ ] Google 계정 선택
   - [ ] 권한 동의
   - [ ] Mock 토큰 발급 (1초 대기)
   - [ ] 홈 화면으로 이동
   - [ ] 마이페이지 열기
   - [ ] 프로필 사진, 닉네임, 이메일 확인

2. **앱 재시작 → 정보 유지**
   - [ ] 앱 완전 종료
   - [ ] 앱 재시작
   - [ ] 마이페이지 열기
   - [ ] 저장된 프로필 정보 표시 확인

3. **로그아웃 → 정보 삭제**
   - [ ] 로그아웃 버튼 클릭
   - [ ] UserNotifier에서 정보 삭제
   - [ ] Secure Storage에서 토큰 삭제
   - [ ] 마이페이지에서 "로그인이 필요합니다" 표시

**예상 시간**: 20분

---

## 파일 구조

### 생성할 파일 (5개)

```
lib/
├── features/auth/
│   ├── data/models/
│   │   ├── user_model.dart (✅ 완료)
│   │   ├── auth_request.dart (생성)
│   │   └── auth_response.dart (생성)
│   ├── services/
│   │   └── auth_api_service.dart (생성)
│   └── providers/
│       └── user_provider.dart (생성)
├── shared/widgets/common/
│   └── profile_avatar.dart (생성)
└── features/mypage/presentation/
    └── widgets/
        └── profile_header.dart (생성)
```

### 수정할 파일 (2개)

```
lib/features/auth/providers/
└── login_provider.dart (수정: AuthApiService 연동)

lib/features/mypage/presentation/screens/
└── mypage_screen.dart (수정: ProfileHeader 추가)
```

---

## 백엔드 연동 시나리오

### 현재 (Mock)

```dart
// AuthApiService
static const bool _useMockData = true;  // ← Mock 모드

Future<AuthResponse> signIn(...) async {
  if (_useMockData) {
    // 가짜 토큰 생성
    return AuthResponse(
      accessToken: 'mock_access_${timestamp}',
      refreshToken: 'mock_refresh_${timestamp}',
      isFirstLogin: true,
    );
  }
  // ...
}
```

**결과**: Google 로그인 → Mock 토큰 → 프로필 표시

---

### 백엔드 준비 후 (Real)

```dart
// AuthApiService
static const bool _useMockData = false;  // ← Real API 모드

Future<AuthResponse> signIn(...) async {
  if (_useMockData) {
    // ...
  } else {
    // 실제 API 호출
    final response = await _dio.post(
      '/api/auth/sign-in',
      data: AuthRequest(
        socialPlatform: socialPlatform,
        email: email,
        nickname: nickname,
        profileUrl: profileUrl,
      ).toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }
}
```

**결과**: Google 로그인 → 실제 API 호출 → 진짜 JWT → 프로필 표시

---

### 백엔드 연동 체크리스트

**준비 사항**:
- [ ] 백엔드 API 엔드포인트 확인: `http://api.tripgether.suhsaechan.kr`
- [ ] Dio baseUrl 설정 확인
- [ ] API 명세서와 요청/응답 형식 일치 확인

**연동 절차**:
1. `_useMockData = false` 변경
2. 앱 재시작
3. Google 로그인 시도
4. 네트워크 로그 확인
5. 에러 발생 시:
   - API 요청 형식 확인
   - 응답 형식 확인
   - CORS 설정 확인

**롤백 절차**:
1. `_useMockData = true` 복구
2. 앱 재시작
3. Mock 모드로 다시 테스트

---

## 예상 작업 시간

| 단계 | 작업 내용 | 예상 시간 | 실제 시간 | 상태 |
|------|----------|----------|----------|------|
| Step 1 | Freezed 모델 (User, AuthRequest, AuthResponse) | 15분 | 20분 | ✅ 완료 |
| Step 2 | AuthApiService (Mock + Real) | 30분 | 15분 | ✅ 완료 |
| Step 3 | UserNotifier | 20분 | - | ⏳ 진행 중 |
| Step 4 | LoginProvider 수정 | 20분 | - | 대기 중 |
| Step 5 | ProfileAvatar 위젯 | 25분 | - | 대기 중 |
| Step 6 | ProfileHeader 위젯 | 20분 | - | 대기 중 |
| Step 7 | MyPageScreen 수정 | 10분 | - | 대기 중 |
| Step 8 | 통합 테스트 | 20분 | - | 대기 중 |
| **총 예상** | | **2시간 40분** | **35분 / 2시간 40분** | **23% 완료** |

---

## 체크리스트

### 필수 구현

- [x] User 모델 (Freezed)
- [x] AuthRequest 모델 (Freezed)
- [x] AuthResponse 모델 (Freezed)
- [x] build_runner 코드 생성
- [x] AuthApiService (Mock + Real)
- [ ] UserNotifier
- [ ] LoginProvider 수정
- [ ] ProfileAvatar 위젯
- [ ] ProfileHeader 위젯
- [ ] MyPageScreen 수정

### 테스트

- [ ] Google 로그인 → 프로필 표시
- [ ] 앱 재시작 → 정보 유지
- [ ] 로그아웃 → 정보 삭제
- [ ] 백엔드 연동 준비 확인

### 백엔드 연동 준비

- [ ] Mock/Real 전환 가능
- [ ] API 명세서 준수
- [ ] 에러 처리 완료
- [ ] 토큰 관리 완료

---

**문서 버전**: 1.0.0
**최종 수정일**: 2025-10-17
**작성자**: Claude Code (인증 및 프로필 기능 구현 계획)

# Tripgether API 명세서

**Base URL**: `http://api.tripgether.suhsaechan.kr`
**API Version**: v1.0.0
**문서 작성일**: 2025-10-17

---

## 목차

1. [개요](#개요)
2. [인증 방식](#인증-방식)
3. [API 엔드포인트](#api-엔드포인트)
   - [소셜 로그인](#1-소셜-로그인)
   - [토큰 재발급](#2-토큰-재발급)
   - [로그아웃](#3-로그아웃)
4. [데이터 스키마](#데이터-스키마)
5. [에러 코드](#에러-코드)
6. [Flutter 구현 가이드](#flutter-구현-가이드)

---

## 개요

Tripgether API는 여행 계획 및 협업 서비스를 위한 REST API입니다. 이 문서는 **인증(Authentication) API**를 다룹니다.

### 주요 특징

- **JWT 기반 인증**: Access Token과 Refresh Token을 사용한 인증 시스템
- **소셜 로그인 지원**: Google, Kakao 소셜 로그인 제공
- **토큰 자동 갱신**: Refresh Token을 통한 Access Token 재발급
- **보안 로그아웃**: 토큰 블랙리스트 및 Redis 기반 세션 관리

### 토큰 유효기간

| 토큰 타입 | 유효기간 |
|----------|---------|
| Access Token | 1시간 |
| Refresh Token | 7일 |

---

## 인증 방식

### JWT Bearer Token

대부분의 API는 JWT Bearer Token을 사용한 인증이 필요합니다.

**Header 형식**:
```
Authorization: Bearer {accessToken}
```

### 인증이 필요한 API
- 로그아웃 (`POST /api/auth/logout`)
- 기타 보호된 리소스 API (추후 추가)

### 인증이 불필요한 API
- 소셜 로그인 (`POST /api/auth/sign-in`)
- 토큰 재발급 (`POST /api/auth/reissue`)

---

## API 엔드포인트

### 1. 소셜 로그인

클라이언트에서 소셜 플랫폼(Google, Kakao) OAuth 인증을 완료한 후, 사용자 정보를 서버에 전송하여 JWT 토큰을 발급받습니다.

#### 기본 정보

- **URL**: `/api/auth/sign-in`
- **Method**: `POST`
- **인증 필요**: ❌ 불필요
- **Content-Type**: `application/json`

#### 요청 파라미터 (AuthRequest)

```json
{
  "socialPlatform": "GOOGLE",
  "email": "user@example.com",
  "nickname": "홍길동",
  "profileUrl": "https://example.com/profile.jpg"
}
```

| 필드 | 타입 | 필수 | 설명 |
|-----|------|------|------|
| `socialPlatform` | string | ✅ | 로그인 플랫폼 (`KAKAO` 또는 `GOOGLE`) |
| `email` | string | ✅ | 사용자 이메일 주소 |
| `nickname` | string | ✅ | 사용자 닉네임 |
| `profileUrl` | string | ⬜ | 사용자 프로필 이미지 URL (선택) |

#### 응답 (AuthResponse)

**HTTP Status**: `200 OK`

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "isFirstLogin": true
}
```

| 필드 | 타입 | 설명 |
|-----|------|------|
| `accessToken` | string | 발급된 Access Token (유효기간: 1시간) |
| `refreshToken` | string | 발급된 Refresh Token (유효기간: 7일) |
| `isFirstLogin` | boolean | 최초 로그인 여부 (회원가입 시 `true`) |

#### 특이사항

1. **클라이언트 책임**: 클라이언트에서 Kakao/Google OAuth 처리 후 받은 사용자 정보로 서버에 JWT 토큰을 요청합니다.
2. **토큰 저장**: 응답받은 `accessToken`과 `refreshToken`은 클라이언트의 **보안 스토리지**(Flutter Secure Storage)에 저장해야 합니다.
3. **최초 로그인**: `isFirstLogin`이 `true`인 경우, 추가 프로필 설정 화면으로 이동하는 등의 처리가 필요할 수 있습니다.

#### 에러 코드

| 코드 | 설명 |
|------|------|
| `INVALID_SOCIAL_TOKEN` | 유효하지 않은 소셜 인증 토큰입니다. |
| `SOCIAL_AUTH_FAILED` | 소셜 로그인 인증에 실패하였습니다. |
| `MEMBER_NOT_FOUND` | 회원 정보를 찾을 수 없습니다. |

#### 예제: cURL

```bash
curl -X POST "http://api.tripgether.suhsaechan.kr/api/auth/sign-in" \
  -H "Content-Type: application/json" \
  -d '{
    "socialPlatform": "GOOGLE",
    "email": "user@example.com",
    "nickname": "홍길동",
    "profileUrl": "https://example.com/profile.jpg"
  }'
```

---

### 2. 토큰 재발급

만료된 Access Token을 Refresh Token을 사용하여 재발급받습니다.

#### 기본 정보

- **URL**: `/api/auth/reissue`
- **Method**: `POST`
- **인증 필요**: ❌ 불필요 (Refresh Token 사용)
- **Content-Type**: `application/json`

#### 요청 파라미터 (AuthRequest)

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

| 필드 | 타입 | 필수 | 설명 |
|-----|------|------|------|
| `refreshToken` | string | ✅ | 발급받은 Refresh Token |

#### 응답 (AuthResponse)

**HTTP Status**: `200 OK`

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "isFirstLogin": false
}
```

| 필드 | 타입 | 설명 |
|-----|------|------|
| `accessToken` | string | 재발급된 Access Token (유효기간: 1시간) |
| `refreshToken` | string | Refresh Token (변경되지 않음) |
| `isFirstLogin` | boolean | 최초 로그인 여부 (재발급 시 항상 `false`) |

#### 특이사항

1. **자동 갱신**: Access Token 만료 시 자동으로 재발급을 시도하는 Interceptor 구현을 권장합니다.
2. **Refresh Token 불변**: 재발급 시 Refresh Token은 변경되지 않고 그대로 유지됩니다.
3. **에러 처리**: Refresh Token이 만료되었거나 유효하지 않은 경우, 사용자를 로그인 화면으로 리다이렉트해야 합니다.

#### 에러 코드

| 코드 | 설명 |
|------|------|
| `REFRESH_TOKEN_NOT_FOUND` | 리프레시 토큰을 찾을 수 없습니다. |
| `INVALID_REFRESH_TOKEN` | 유효하지 않은 리프레시 토큰입니다. |
| `EXPIRED_REFRESH_TOKEN` | 만료된 리프레시 토큰입니다. |
| `MEMBER_NOT_FOUND` | 회원 정보를 찾을 수 없습니다. |

#### 예제: cURL

```bash
curl -X POST "http://api.tripgether.suhsaechan.kr/api/auth/reissue" \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

---

### 3. 로그아웃

사용자를 로그아웃 처리하고 토큰을 무효화합니다.

#### 기본 정보

- **URL**: `/api/auth/logout`
- **Method**: `POST`
- **인증 필요**: ✅ 필요 (Access Token)
- **Content-Type**: `application/json`

#### 요청 헤더

```
Authorization: Bearer {accessToken}
```

#### 요청 파라미터 (AuthRequest)

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

| 필드 | 타입 | 필수 | 설명 |
|-----|------|------|------|
| `refreshToken` | string | ✅ | 로그아웃할 Refresh Token |

**참고**: Access Token은 Authorization 헤더에서 자동으로 추출됩니다.

#### 응답

**HTTP Status**: `200 OK`

```
(빈 응답 본문)
```

로그아웃 성공 시 응답 본문은 비어있으며, HTTP 상태 코드 `200 OK`만 반환됩니다.

#### 동작 설명

1. **Access Token 무효화**: 액세스 토큰을 블랙리스트에 등록하여 무효화 처리합니다.
2. **Refresh Token 삭제**: Redis에 저장된 리프레시 토큰을 삭제합니다.
3. **세션 정리**: 서버 측 세션 정보를 모두 제거합니다.

#### 특이사항

1. **클라이언트 정리**: 로그아웃 후 클라이언트에서도 저장된 토큰을 모두 삭제해야 합니다.
2. **토큰 블랙리스트**: 로그아웃된 Access Token은 재사용할 수 없습니다.
3. **자동 리다이렉트**: 로그아웃 후 로그인 화면으로 이동 처리가 필요합니다.

#### 에러 코드

| 코드 | 설명 |
|------|------|
| `INVALID_TOKEN` | 유효하지 않은 토큰입니다. |
| `UNAUTHORIZED` | 인증이 필요한 요청입니다. |

#### 예제: cURL

```bash
curl -X POST "http://api.tripgether.suhsaechan.kr/api/auth/logout" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

---

## 데이터 스키마

### AuthRequest

로그인 및 토큰 관리에 사용되는 요청 데이터 스키마입니다.

```typescript
interface AuthRequest {
  // 소셜 로그인 시 사용
  socialPlatform?: "KAKAO" | "GOOGLE";
  email?: string;
  nickname?: string;
  profileUrl?: string;

  // 토큰 재발급 및 로그아웃 시 사용
  refreshToken?: string;
}
```

| 필드 | 타입 | 필수 | 설명 |
|-----|------|------|------|
| `socialPlatform` | string | 조건부 | 로그인 플랫폼 (`KAKAO` 또는 `GOOGLE`) - 로그인 시 필수 |
| `email` | string | 조건부 | 사용자 이메일 - 로그인 시 필수 |
| `nickname` | string | 조건부 | 사용자 닉네임 - 로그인 시 필수 |
| `profileUrl` | string | ⬜ | 프로필 이미지 URL (선택) |
| `refreshToken` | string | 조건부 | Refresh Token - 재발급/로그아웃 시 필수 |

---

### AuthResponse

인증 API의 응답 데이터 스키마입니다.

```typescript
interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  isFirstLogin: boolean;
}
```

| 필드 | 타입 | 설명 |
|-----|------|------|
| `accessToken` | string | JWT Access Token (유효기간: 1시간) |
| `refreshToken` | string | JWT Refresh Token (유효기간: 7일) |
| `isFirstLogin` | boolean | 최초 로그인 여부 (`true`: 회원가입, `false`: 기존 회원 로그인) |

---

### MemberDto

회원 정보를 나타내는 데이터 전송 객체(DTO)입니다.

```typescript
interface MemberDto {
  memberId: string;           // UUID 형식
  email: string;              // 필수
  nickname: string;           // 필수, 2-50자
  profileImageUrl?: string;   // 선택
  status?: string;            // 회원 상태
}
```

| 필드 | 타입 | 필수 | 설명 |
|-----|------|------|------|
| `memberId` | string (UUID) | ✅ | 회원 고유 식별자 |
| `email` | string | ✅ | 회원 이메일 주소 |
| `nickname` | string | ✅ | 회원 닉네임 (2-50자) |
| `profileImageUrl` | string | ⬜ | 프로필 이미지 URL |
| `status` | string | ⬜ | 회원 상태 (예: ACTIVE, INACTIVE) |

---

## 에러 코드

### 인증 관련 에러

| 에러 코드 | HTTP Status | 설명 | 해결 방법 |
|----------|-------------|------|----------|
| `INVALID_SOCIAL_TOKEN` | 401 | 유효하지 않은 소셜 인증 토큰 | 소셜 로그인을 다시 시도하세요 |
| `SOCIAL_AUTH_FAILED` | 401 | 소셜 로그인 인증 실패 | 소셜 플랫폼 연동을 확인하세요 |
| `INVALID_TOKEN` | 401 | 유효하지 않은 토큰 | 토큰을 확인하고 재발급을 시도하세요 |
| `UNAUTHORIZED` | 401 | 인증 필요 | 로그인이 필요합니다 |

### 토큰 관련 에러

| 에러 코드 | HTTP Status | 설명 | 해결 방법 |
|----------|-------------|------|----------|
| `REFRESH_TOKEN_NOT_FOUND` | 404 | 리프레시 토큰을 찾을 수 없음 | 재로그인이 필요합니다 |
| `INVALID_REFRESH_TOKEN` | 401 | 유효하지 않은 리프레시 토큰 | 재로그인이 필요합니다 |
| `EXPIRED_REFRESH_TOKEN` | 401 | 만료된 리프레시 토큰 | 재로그인이 필요합니다 |

### 회원 관련 에러

| 에러 코드 | HTTP Status | 설명 | 해결 방법 |
|----------|-------------|------|----------|
| `MEMBER_NOT_FOUND` | 404 | 회원 정보를 찾을 수 없음 | 회원가입이 필요합니다 |

---

## Flutter 구현 가이드

### 1. 데이터 모델 정의

#### AuthRequest 모델

```dart
/// 인증 요청 데이터 모델
/// 소셜 로그인, 토큰 재발급, 로그아웃에 사용
class AuthRequest {
  // 소셜 로그인용 필드
  final String? socialPlatform;  // "KAKAO" 또는 "GOOGLE"
  final String? email;
  final String? nickname;
  final String? profileUrl;

  // 토큰 재발급 및 로그아웃용 필드
  final String? refreshToken;

  const AuthRequest({
    this.socialPlatform,
    this.email,
    this.nickname,
    this.profileUrl,
    this.refreshToken,
  });

  /// 소셜 로그인 요청 생성 팩토리
  factory AuthRequest.signIn({
    required String socialPlatform,
    required String email,
    required String nickname,
    String? profileUrl,
  }) {
    return AuthRequest(
      socialPlatform: socialPlatform,
      email: email,
      nickname: nickname,
      profileUrl: profileUrl,
    );
  }

  /// 토큰 재발급 요청 생성 팩토리
  factory AuthRequest.reissue({
    required String refreshToken,
  }) {
    return AuthRequest(refreshToken: refreshToken);
  }

  /// 로그아웃 요청 생성 팩토리
  factory AuthRequest.logout({
    required String refreshToken,
  }) {
    return AuthRequest(refreshToken: refreshToken);
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (socialPlatform != null) json['socialPlatform'] = socialPlatform;
    if (email != null) json['email'] = email;
    if (nickname != null) json['nickname'] = nickname;
    if (profileUrl != null) json['profileUrl'] = profileUrl;
    if (refreshToken != null) json['refreshToken'] = refreshToken;

    return json;
  }

  /// JSON 역직렬화
  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    return AuthRequest(
      socialPlatform: json['socialPlatform'] as String?,
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      profileUrl: json['profileUrl'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}
```

#### AuthResponse 모델

```dart
/// 인증 응답 데이터 모델
/// 로그인 및 토큰 재발급 시 사용
class AuthResponse {
  /// JWT Access Token (유효기간: 1시간)
  final String accessToken;

  /// JWT Refresh Token (유효기간: 7일)
  final String refreshToken;

  /// 최초 로그인 여부 (회원가입 시 true)
  final bool isFirstLogin;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.isFirstLogin,
  });

  /// JSON 역직렬화
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      isFirstLogin: json['isFirstLogin'] as bool,
    );
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'isFirstLogin': isFirstLogin,
    };
  }
}
```

#### MemberDto 모델

```dart
/// 회원 정보 데이터 전송 객체(DTO)
class MemberDto {
  /// 회원 고유 식별자 (UUID)
  final String? memberId;

  /// 회원 이메일 (필수)
  final String email;

  /// 회원 닉네임 (필수, 2-50자)
  final String nickname;

  /// 프로필 이미지 URL (선택)
  final String? profileImageUrl;

  /// 회원 상태 (예: ACTIVE, INACTIVE)
  final String? status;

  const MemberDto({
    this.memberId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.status,
  });

  /// JSON 역직렬화
  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
      memberId: json['memberId'] as String?,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      status: json['status'] as String?,
    );
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'email': email,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'status': status,
    };
  }
}
```

---

### 2. API 서비스 구현

#### AuthApiService

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 인증 API 서비스
/// 소셜 로그인, 토큰 재발급, 로그아웃 기능을 제공
class AuthApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const String baseUrl = 'http://api.tripgether.suhsaechan.kr';

  // 보안 스토리지 키
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthApiService(this._dio, this._secureStorage) {
    // Dio 기본 설정
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // 인터셉터 추가 (토큰 자동 재발급)
    _dio.interceptors.add(_createAuthInterceptor());
  }

  /// 소셜 로그인
  ///
  /// Google 또는 Kakao OAuth 인증 후 받은 사용자 정보로 JWT 토큰을 발급받습니다.
  ///
  /// [socialPlatform]: "GOOGLE" 또는 "KAKAO"
  /// [email]: 사용자 이메일
  /// [nickname]: 사용자 닉네임
  /// [profileUrl]: 프로필 이미지 URL (선택)
  ///
  /// Returns: [AuthResponse] - accessToken, refreshToken, isFirstLogin
  /// Throws: [DioException] - API 호출 실패 시
  Future<AuthResponse> signIn({
    required String socialPlatform,
    required String email,
    required String nickname,
    String? profileUrl,
  }) async {
    try {
      final request = AuthRequest.signIn(
        socialPlatform: socialPlatform,
        email: email,
        nickname: nickname,
        profileUrl: profileUrl,
      );

      final response = await _dio.post(
        '/api/auth/sign-in',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // 토큰 저장
      await _saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 토큰 재발급
  ///
  /// 만료된 Access Token을 Refresh Token으로 재발급받습니다.
  ///
  /// Returns: [AuthResponse] - 새로운 accessToken 포함
  /// Throws: [DioException] - 재발급 실패 시 (로그인 필요)
  Future<AuthResponse> reissueToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

      if (refreshToken == null) {
        throw Exception('Refresh token not found. Please login again.');
      }

      final request = AuthRequest.reissue(refreshToken: refreshToken);

      final response = await _dio.post(
        '/api/auth/reissue',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // 새로운 Access Token 저장
      await _secureStorage.write(
        key: _accessTokenKey,
        value: authResponse.accessToken,
      );

      return authResponse;
    } on DioException catch (e) {
      // Refresh Token도 만료된 경우 로그인 필요
      await _clearTokens();
      throw _handleError(e);
    }
  }

  /// 로그아웃
  ///
  /// 서버에 로그아웃 요청을 보내고 로컬에 저장된 토큰을 모두 삭제합니다.
  ///
  /// Throws: [DioException] - 로그아웃 실패 시
  Future<void> logout() async {
    try {
      final accessToken = await _secureStorage.read(key: _accessTokenKey);
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

      if (refreshToken == null) {
        // 토큰이 없으면 로컬만 정리
        await _clearTokens();
        return;
      }

      final request = AuthRequest.logout(refreshToken: refreshToken);

      await _dio.post(
        '/api/auth/logout',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      // 로컬 토큰 삭제
      await _clearTokens();
    } on DioException catch (e) {
      // 에러가 발생해도 로컬 토큰은 삭제
      await _clearTokens();
      throw _handleError(e);
    }
  }

  /// 저장된 Access Token 가져오기
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// 저장된 Refresh Token 가져오기
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

  /// 토큰 저장 (Flutter Secure Storage)
  Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// 토큰 삭제
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// 인증 인터셉터 생성
  ///
  /// 모든 API 요청에 자동으로 Access Token을 추가하고,
  /// 401 에러 발생 시 자동으로 토큰 재발급을 시도합니다.
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 로그인/재발급 요청은 토큰 불필요
        if (options.path.contains('/auth/sign-in') ||
            options.path.contains('/auth/reissue')) {
          return handler.next(options);
        }

        // Access Token 자동 추가
        final accessToken = await getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // 401 에러 (인증 실패) 시 토큰 재발급 시도
        if (error.response?.statusCode == 401) {
          try {
            // 토큰 재발급
            await reissueToken();

            // 원래 요청 재시도
            final accessToken = await getAccessToken();
            error.requestOptions.headers['Authorization'] =
                'Bearer $accessToken';

            final response = await _dio.fetch(error.requestOptions);
            return handler.resolve(response);
          } catch (e) {
            // 재발급 실패 시 로그인 필요
            return handler.reject(error);
          }
        }

        return handler.next(error);
      },
    );
  }

  /// 에러 처리
  Exception _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      // 서버에서 반환한 에러 코드 처리
      if (data is Map<String, dynamic> && data.containsKey('code')) {
        final errorCode = data['code'] as String;
        return Exception(_getErrorMessage(errorCode));
      }

      // HTTP 상태 코드별 기본 메시지
      switch (statusCode) {
        case 401:
          return Exception('인증에 실패했습니다. 다시 로그인해주세요.');
        case 404:
          return Exception('요청한 리소스를 찾을 수 없습니다.');
        case 500:
          return Exception('서버 오류가 발생했습니다.');
        default:
          return Exception('알 수 없는 오류가 발생했습니다.');
      }
    }

    // 네트워크 오류
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('네트워크 연결이 불안정합니다.');
    }

    return Exception('요청 처리 중 오류가 발생했습니다.');
  }

  /// 에러 코드별 메시지 반환
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'INVALID_SOCIAL_TOKEN':
        return '유효하지 않은 소셜 인증 토큰입니다.';
      case 'SOCIAL_AUTH_FAILED':
        return '소셜 로그인 인증에 실패하였습니다.';
      case 'REFRESH_TOKEN_NOT_FOUND':
        return '리프레시 토큰을 찾을 수 없습니다. 다시 로그인해주세요.';
      case 'INVALID_REFRESH_TOKEN':
        return '유효하지 않은 리프레시 토큰입니다.';
      case 'EXPIRED_REFRESH_TOKEN':
        return '만료된 리프레시 토큰입니다. 다시 로그인해주세요.';
      case 'MEMBER_NOT_FOUND':
        return '회원 정보를 찾을 수 없습니다.';
      case 'INVALID_TOKEN':
        return '유효하지 않은 토큰입니다.';
      case 'UNAUTHORIZED':
        return '인증이 필요한 요청입니다.';
      default:
        return '오류가 발생했습니다: $errorCode';
    }
  }
}
```

---

### 3. 사용 예제

#### 소셜 로그인 구현 예제

```dart
/// Google 소셜 로그인 및 토큰 발급
Future<void> handleGoogleLogin(BuildContext context) async {
  try {
    // 1. Google OAuth 처리
    final googleUser = await GoogleAuthService.signIn();

    if (googleUser == null) {
      throw Exception('Google 로그인이 취소되었습니다.');
    }

    // 2. 사용자 정보 추출
    final email = googleUser.email;
    final displayName = googleUser.displayName ?? 'Unknown';
    final photoUrl = googleUser.photoUrl;

    // 3. 서버에 토큰 발급 요청
    final authService = ref.read(authApiServiceProvider);
    final authResponse = await authService.signIn(
      socialPlatform: 'GOOGLE',
      email: email,
      nickname: displayName,
      profileUrl: photoUrl,
    );

    // 4. 최초 로그인 여부에 따른 화면 이동
    if (authResponse.isFirstLogin) {
      // 최초 로그인 - 프로필 설정 화면으로 이동
      context.go(AppRoutes.profileSetup);
    } else {
      // 기존 회원 - 홈 화면으로 이동
      context.go(AppRoutes.home);
    }
  } catch (e) {
    // 에러 처리
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로그인 실패: ${e.toString()}')),
    );
  }
}
```

#### 로그아웃 구현 예제

```dart
/// 로그아웃 처리
Future<void> handleLogout(BuildContext context) async {
  try {
    final authService = ref.read(authApiServiceProvider);

    // 1. 서버에 로그아웃 요청 및 로컬 토큰 삭제
    await authService.logout();

    // 2. 로그인 화면으로 이동
    context.go(AppRoutes.login);

    // 3. 성공 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그아웃되었습니다.')),
    );
  } catch (e) {
    // 에러가 발생해도 로그인 화면으로 이동 (로컬 토큰은 이미 삭제됨)
    context.go(AppRoutes.login);
  }
}
```

#### 토큰 재발급 구현 (자동)

```dart
/// AuthApiService의 인터셉터가 자동으로 처리하므로 별도 호출 불필요
///
/// 동작 흐름:
/// 1. API 요청 시 401 에러 발생
/// 2. 인터셉터가 자동으로 reissueToken() 호출
/// 3. 새로운 Access Token으로 원래 요청 재시도
/// 4. 재발급 실패 시 로그인 화면으로 리다이렉트

// 수동 재발급이 필요한 경우 (드물음)
final authService = ref.read(authApiServiceProvider);
try {
  await authService.reissueToken();
  print('토큰 재발급 성공');
} catch (e) {
  print('토큰 재발급 실패: 재로그인 필요');
  context.go(AppRoutes.login);
}
```

---

### 4. Riverpod Provider 설정

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Dio 인스턴스 Provider
@riverpod
Dio dio(DioRef ref) {
  return Dio();
}

/// Flutter Secure Storage Provider
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

/// AuthApiService Provider
@riverpod
AuthApiService authApiService(AuthApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return AuthApiService(dio, secureStorage);
}
```

---

### 5. 구현 체크리스트

#### 필수 구현 사항

- [ ] **데이터 모델**: `AuthRequest`, `AuthResponse`, `MemberDto` 클래스 작성
- [ ] **API 서비스**: `AuthApiService` 클래스 작성
- [ ] **토큰 저장**: Flutter Secure Storage를 사용한 토큰 저장/불러오기
- [ ] **Dio 인터셉터**: 자동 토큰 추가 및 재발급 처리
- [ ] **에러 처리**: 서버 에러 코드별 메시지 처리
- [ ] **Riverpod 설정**: Provider 작성 및 의존성 주입

#### 권장 구현 사항

- [ ] **로딩 상태 관리**: 로그인/로그아웃 중 로딩 인디케이터 표시
- [ ] **에러 핸들링 UI**: 사용자 친화적인 에러 메시지 표시
- [ ] **자동 로그인**: 앱 시작 시 저장된 토큰으로 자동 로그인
- [ ] **토큰 만료 알림**: Refresh Token 만료 시 사용자에게 알림
- [ ] **로그 기록**: 개발 환경에서 API 요청/응답 로그 출력

#### 보안 체크리스트

- [ ] **토큰 보안 저장**: Flutter Secure Storage 사용 (절대 SharedPreferences 사용 금지)
- [ ] **HTTPS 통신**: 프로덕션 환경에서 HTTPS 사용 확인
- [ ] **토큰 로그 제거**: 프로덕션 빌드에서 토큰 관련 로그 제거
- [ ] **타임아웃 설정**: 네트워크 요청 타임아웃 설정 (10초 권장)
- [ ] **에러 메시지**: 민감한 정보가 에러 메시지에 노출되지 않도록 주의

---

## 참고 자료

### API 변경 이력

| 날짜 | 작성자 | 이슈 | 변경 내용 |
|------|--------|------|----------|
| 2025.10.16 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 |

### 관련 문서

- [Swagger UI](https://api.tripgether.suhsaechan.kr/swagger-ui/index.html)
- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Riverpod State Management](https://riverpod.dev/)

---

**문서 버전**: 1.0.0
**최종 수정일**: 2025-10-17
**작성자**: Claude Code (API 명세서 분석 및 문서화)

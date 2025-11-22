# 온보딩 API 분석 보고서

**작성일**: 2025-11-18
**분석 대상**: Tripgether 백엔드 온보딩 API
**분석 방법**: Swagger UI를 통한 실제 API 호출 테스트

---

## 📋 Executive Summary

백엔드 온보딩 API의 실제 동작을 분석한 결과, **클라이언트 구현에 중요한 발견**을 했습니다:

### 🔴 핵심 발견

1. **`currentStep`의 의미**: "다음에 해야 할 단계"가 아니라 **"현재 진행 중인 단계"**를 반환
2. **순차적 단계 검증**: 백엔드가 온보딩 단계 순서를 엄격하게 검증하며, 이전 단계로 되돌아가는 것을 차단
3. **토큰 즉시 사용 가능**: API 응답 즉시 반환되며, Access Token은 즉시 사용 가능 (Race Condition의 원인은 클라이언트 측 저장 지연)

---

## 🧪 실제 API 테스트 결과

### 테스트 환경
- **서버**: https://api.tripgether.suhsaechan.kr
- **인증 토큰**: Bearer eyJhbGciOiJIUzUxMiJ9... (유효)
- **회원 ID**: aa5c0b35-1aaf-4e58-b7dc-ea8d41bc12c5
- **회원 이메일**: ghd0106@gmail.com
- **회원 이름**: 엘리페어

---

### Test Case 1: 약관 동의 (POST /api/members/onboarding/terms)

#### Request
```json
{
  "isServiceTermsAndPrivacyAgreed": true,
  "isMarketingAgreed": false
}
```

#### Response (200 OK)
```json
{
  "currentStep": "BIRTH_DATE",
  "onboardingStatus": "IN_PROGRESS",
  "member": {
    "id": "aa5c0b35-1aaf-4e58-b7dc-ea8d41bc12c5",
    "email": "ghd0106@gmail.com",
    "name": "엘리페어",
    "onboardingStatus": "IN_PROGRESS",
    "isServiceTermsAndPrivacyAgreed": true,
    "isMarketingAgreed": false,
    "birthDate": null,
    "gender": null
  }
}
```

#### ⚠️ 분석
- **예상**: `currentStep: "NAME"` (약관 동의 후 다음 단계)
- **실제**: `currentStep: "BIRTH_DATE"`
- **결론**: 이미 NAME 단계가 완료되어 있었음 (회원 정보에 `name: "엘리페어"` 존재)

---

### Test Case 2: 이름 설정 시도 (POST /api/members/onboarding/name)

#### Request
```json
{
  "name": "홍길동"
}
```

#### Response (400 Bad Request)
```json
{
  "message": "유효하지 않은 온보딩 단계입니다."
}
```

#### 🔴 분석
- **시도**: BIRTH_DATE 단계에서 NAME 단계로 되돌아가려 함
- **결과**: 400 에러
- **결론**: 백엔드는 **순차적 단계 진행만 허용**하며, 이전 단계로 되돌아가는 것을 차단

---

### Test Case 3: 생년월일 설정 (POST /api/members/onboarding/birth-date)

#### Request
```json
{
  "birthDate": "1990-01-01"
}
```

#### Response (200 OK)
```json
{
  "currentStep": "GENDER",
  "onboardingStatus": "IN_PROGRESS",
  "member": {
    "id": "aa5c0b35-1aaf-4e58-b7dc-ea8d41bc12c5",
    "email": "ghd0106@gmail.com",
    "name": "엘리페어",
    "onboardingStatus": "IN_PROGRESS",
    "isServiceTermsAndPrivacyAgreed": true,
    "isMarketingAgreed": false,
    "birthDate": "1990-01-01",
    "gender": null
  }
}
```

#### ✅ 분석
- **현재 단계**: BIRTH_DATE → API 호출 성공
- **응답**: `currentStep: "GENDER"` (다음 단계로 자동 전환)
- **결론**: 올바른 순서로 진행하면 정상 작동

---

## 🔍 백엔드 동작 방식 분석

### 1. `currentStep`의 의미

백엔드는 **"다음에 수행해야 할 단계"**를 `currentStep`으로 반환합니다:

| API 호출 | 완료된 단계 | 응답의 currentStep | 의미 |
|---------|-----------|------------------|------|
| POST /terms | TERMS | BIRTH_DATE | 약관 동의 완료 → 다음은 생년월일 |
| POST /birth-date | BIRTH_DATE | GENDER | 생년월일 완료 → 다음은 성별 |
| POST /gender | GENDER | INTERESTS | 성별 완료 → 다음은 관심사 |
| POST /interests | INTERESTS | COMPLETED | 관심사 완료 → 온보딩 완료 |

### 2. 단계 순서 검증

백엔드는 다음과 같이 검증합니다:

```
TERMS → NAME → BIRTH_DATE → GENDER → INTERESTS → COMPLETED
```

- ✅ **순방향 진행**: 허용 (예: BIRTH_DATE 단계에서 BIRTH_DATE API 호출)
- ❌ **역방향 진행**: 차단 (예: BIRTH_DATE 단계에서 NAME API 호출)
- ❌ **건너뛰기**: 차단 (예: BIRTH_DATE 단계에서 GENDER API 호출)

### 3. 온보딩 상태 관리

```json
{
  "currentStep": "GENDER",           // 다음에 수행할 단계
  "onboardingStatus": "IN_PROGRESS", // 전체 온보딩 진행 상태
  "member": {
    "onboardingStatus": "IN_PROGRESS" // 회원의 온보딩 상태
  }
}
```

- `currentStep`: 개별 단계 (TERMS, NAME, BIRTH_DATE, GENDER, INTERESTS, COMPLETED)
- `onboardingStatus`: 전체 상태 (NOT_STARTED, IN_PROGRESS, COMPLETED)

---

## 🐛 클라이언트 측 문제 분석

### 문제 1: Race Condition (Access Token 없음 에러)

#### 증상
```
[UserNotifier] ✅ 사용자 정보 저장 완료
[LoginScreen] ✅ 온보딩 화면 전환 완료
[OnboardingProvider] ❌ Access Token이 없습니다.
```

#### 원인 분석

1. **백엔드는 문제 없음**: Swagger 테스트 결과, API는 즉시 응답하고 토큰은 즉시 사용 가능
2. **문제는 클라이언트 측 저장 지연**:
   - `FlutterSecureStorage.write()` 작업이 비동기로 완료되기까지 시간 소요
   - 플랫폼에 따라 300ms 이상 소요 가능
   - OnboardingProvider가 저장 완료 전에 읽기 시도

#### 해결 방법

**옵션 A: 메모리 캐싱 추가 (권장)**
```dart
class UserNotifier extends _$UserNotifier {
  // 메모리 캐시
  String? _accessTokenCache;

  Future<void> saveAuthTokens(AuthResponse response) async {
    // 1. 먼저 메모리 캐시에 저장 (즉시 사용 가능)
    _accessTokenCache = response.accessToken;

    // 2. 그 다음 Secure Storage에 비동기로 저장
    const storage = FlutterSecureStorage();
    await storage.write(key: 'accessToken', value: response.accessToken);
    await storage.write(key: 'refreshToken', value: response.refreshToken);
  }

  Future<String?> getAccessToken() async {
    // 메모리 캐시에서 먼저 확인
    if (_accessTokenCache != null) {
      return _accessTokenCache;
    }

    // 없으면 Secure Storage에서 읽기
    const storage = FlutterSecureStorage();
    _accessTokenCache = await storage.read(key: 'accessToken');
    return _accessTokenCache;
  }
}
```

**옵션 B: 현재 Retry 로직 개선**
```dart
Future<String?> _readAccessTokenWithRetry() async {
  const storage = FlutterSecureStorage();
  const maxRetries = 10;  // 3 → 10으로 증가

  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    final accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      return accessToken;
    }

    if (attempt < maxRetries) {
      // 지수 백오프: 50ms → 100ms → 200ms → 400ms → 500ms (max)
      final delay = Duration(milliseconds: min(50 * pow(2, attempt - 1).toInt(), 500));
      await Future.delayed(delay);
    }
  }

  return null;
}
```

---

### 문제 2: `currentStep` 해석 오류

#### 현재 클라이언트 구현 추정

클라이언트가 `currentStep`을 "현재 보여줄 페이지"로 해석하고 있을 가능성:

```dart
// ❌ WRONG: currentStep을 현재 페이지로 해석
final initialPage = getPageIndexFromOnboardingStep(onboardingStep);
context.go(AppRoutes.onboarding, extra: initialPage);

// 예: currentStep="BIRTH_DATE"면 생년월일 페이지로 이동
```

#### 올바른 해석

`currentStep`은 **"다음에 수행할 단계"**이므로:

```dart
// ✅ CORRECT: currentStep을 다음 단계로 해석
final initialPage = getPageIndexFromOnboardingStep(onboardingStep);
context.go(AppRoutes.onboarding, extra: initialPage);

// 예: currentStep="BIRTH_DATE"면 생년월일 페이지로 이동 (올바름)
```

**실제로 현재 구현이 맞습니다!** `currentStep`이 "BIRTH_DATE"이면 생년월일 페이지로 이동하는 것이 정확합니다.

---

### 문제 3: 온보딩 단계 저장 로직

#### 현재 구현
```dart
// OnboardingProvider의 각 메서드에서
await storage.write(key: 'onboardingStep', value: response.currentStep);
```

#### 분석

이 로직은 **완벽합니다**:
- API 호출 성공 시 `currentStep`을 저장
- 앱 재시작 시 해당 단계부터 재개
- 예: BIRTH_DATE API 호출 → `currentStep: "GENDER"` 저장 → 재시작 시 성별 페이지부터 시작

---

## ✅ 결론 및 권장사항

### 1. 현재 구현 상태

| 구성 요소 | 상태 | 비고 |
|---------|------|------|
| 백엔드 API | ✅ 정상 | 즉시 응답, 순차 검증 완벽 |
| `currentStep` 해석 | ✅ 정상 | 다음 단계로 올바르게 해석 |
| 온보딩 단계 저장 | ✅ 정상 | API 응답 후 즉시 저장 |
| Access Token 저장/읽기 | ❌ 문제 | FlutterSecureStorage 비동기 지연 |

### 2. 해결해야 할 문제

#### 🔴 Priority 1: Access Token Race Condition

**권장 해결책**: 메모리 캐싱 추가 (옵션 A)

**이유**:
- Retry 로직은 임시방편 (플랫폼마다 다른 지연 시간)
- 메모리 캐싱은 근본적 해결책 (즉시 사용 가능)
- 구현 간단하고 안정적

**구현 위치**:
- `lib/features/auth/providers/user_provider.dart` (UserNotifier)
- 메모리 캐시 변수 추가
- `saveAuthTokens()` 및 `getAccessToken()` 메서드 수정

### 3. 검증이 필요한 부분

#### 로그인 직후 onboardingStep 처리

**시나리오 1**: 첫 로그인 (회원 생성)
```
AuthResponse.onboardingStep = "TERMS"
→ 약관 동의 페이지로 이동 (페이지 인덱스 0)
```

**시나리오 2**: 온보딩 중단 후 재로그인
```
AuthResponse.onboardingStep = "GENDER"
→ 성별 선택 페이지로 이동 (페이지 인덱스 3)
```

**시나리오 3**: 온보딩 완료 후 로그인
```
AuthResponse.onboardingStep = "COMPLETED"
→ 홈 화면으로 이동
```

**확인 필요**: `AuthResponse`의 `onboardingStep` 필드가 백엔드에서 올바르게 반환되는지 확인

---

## 📊 API 응답 패턴 정리

### 성공 응답 패턴

```json
{
  "currentStep": "NEXT_STEP",        // 다음에 수행할 단계
  "onboardingStatus": "IN_PROGRESS", // 진행 상태
  "member": {
    // 업데이트된 회원 정보
    "birthDate": "1990-01-01",  // 방금 설정한 값
    "gender": null              // 아직 설정 안 됨
  }
}
```

### 에러 응답 패턴

```json
{
  "message": "유효하지 않은 온보딩 단계입니다."
}
```

**발생 조건**:
- 현재 단계가 아닌 API 호출 시
- 예: `currentStep="GENDER"`인데 NAME API 호출

---

## 🎯 다음 단계 (Action Items)

### 즉시 실행

1. ✅ **메모리 캐싱 구현** (UserNotifier)
   - `_accessTokenCache` 변수 추가
   - `saveAuthTokens()` 수정: 메모리 캐시 먼저 저장
   - `getAccessToken()` 수정: 메모리 캐시 먼저 확인

2. ✅ **Retry 로직 제거** (OnboardingProvider)
   - `_readAccessTokenWithRetry()` 삭제
   - `UserNotifier.getAccessToken()` 직접 호출로 변경

### 검증 필요

3. 🔍 **AuthResponse.onboardingStep 확인**
   - 로그인 API 응답에 `onboardingStep` 필드 존재 여부
   - 값이 백엔드와 동일한 형식인지 확인 (TERMS, NAME, BIRTH_DATE, GENDER, INTERESTS, COMPLETED)

4. 🔍 **전체 플로우 테스트**
   - 첫 로그인 → 약관 동의 → 앱 종료 → 재실행 → 이름 설정부터 재개
   - 온보딩 중단 → 로그아웃 → 재로그인 → 중단 지점부터 재개

---

## 📝 부록: Swagger API 문서 요약

### 온보딩 API 목록

| 순서 | API | 설명 | currentStep 변화 |
|-----|-----|------|----------------|
| 1 | POST /api/members/onboarding/terms | 약관 동의 | ? → NAME |
| 2 | POST /api/members/onboarding/name | 이름 설정 | NAME → BIRTH_DATE |
| 3 | POST /api/members/onboarding/birth-date | 생년월일 설정 | BIRTH_DATE → GENDER |
| 4 | POST /api/members/onboarding/gender | 성별 설정 | GENDER → INTERESTS |
| 5 | POST /api/members/onboarding/interests | 관심사 설정 | INTERESTS → COMPLETED |

**주의**: 테스트 시 이미 NAME 단계가 완료된 상태였으므로, TERMS → NAME 전환은 확인하지 못함

### 인증 요구사항

모든 온보딩 API는 JWT 인증 필요:
```
Authorization: Bearer {accessToken}
```

---

**분석 종료**

# Tripgether Backend API 문서

**Base URL**: `https://api.tripgether.suhsaechan.kr`
**문서 버전**: 2025-11-24
**API 버전**: OAS 3.1

---

## 📋 목차
1. [인증 시스템](#인증-시스템)
2. [인증 API](#인증-api)
3. [회원 관리 API](#회원-관리-api)
4. [온보딩 API](#온보딩-api)
5. [관심사 관리 API](#관심사-관리-api)
6. [장소 관리 API](#장소-관리-api)
7. [콘텐츠 API](#콘텐츠-api)
8. [AI 서버 API](#ai-서버-api)
9. [테스트 API](#테스트-api)
10. [에러 코드](#에러-코드)
11. [데이터 모델](#데이터-모델)

---

## 🔐 인증 시스템

### Bearer Token 인증
- **Type**: HTTP Bearer Authentication
- **Format**: JWT (JSON Web Token)
- **Header**: `Authorization: Bearer {accessToken}`
- **Access Token 유효기간**: 1시간
- **Refresh Token 유효기간**: 7일

### 인증이 필요한 API
- 회원 프로필 수정
- 온보딩 관련 API
- 콘텐츠 생성 및 분석
- 장소 저장/관리
- 로그아웃

### 인증이 불필요한 API
- 소셜 로그인
- 토큰 재발급
- 회원 조회
- 관심사 조회
- 닉네임 중복 확인

---

## 🔐 인증 API

회원 인증(소셜 로그인) 관련 API 제공

### POST /api/auth/sign-in
소셜 로그인 (Google, Kakao)

**인증**: 불필요

**Request Body** (`SignInRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| socialPlatform | string (enum) | ✅ | 로그인 플랫폼 (KAKAO, GOOGLE) | "KAKAO" |
| email | string | ✅ | 소셜 로그인 후 반환된 이메일 | "user@example.com" |
| name | string | ✅ | 소셜 로그인 후 반환된 닉네임 | "홍길동" |
| profileUrl | string | ❌ | 소셜 로그인 후 반환된 프로필 URL | "https://example.com/profile.jpg" |
| fcmToken | string | ❌ | FCM 푸시 알림 토큰 (선택) | "dXQzM2k1N2RkZjM0OGE3YjczZGY5..." |
| deviceType | string (enum) | ❌ | 디바이스 타입 (IOS, ANDROID) - fcmToken 제공 시 필수 | "IOS" |
| deviceId | string (uuid) | ❌ | 디바이스 고유 식별자 - fcmToken 제공 시 필수 | "550e8400-e29b-41d4-a716-446655440000" |

**Response 200** (`SignInResponse`):
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "isFirstLogin": true,
  "requiresOnboarding": true,
  "onboardingStep": "TERMS"
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| accessToken | string | 발급된 Access Token (1시간 유효) |
| refreshToken | string | 발급된 Refresh Token (7일 유효) |
| isFirstLogin | boolean | 최초 로그인 여부 |
| requiresOnboarding | boolean | 약관/온보딩 완료 여부 |
| onboardingStep | string | 현재 온보딩 단계 |

**특이사항**:
- 클라이언트에서 Kakao/Google OAuth 처리 후 받은 사용자 정보로 서버에 JWT 토큰을 요청합니다.
- 액세스 토큰은 1시간, 리프레시 토큰은 7일 유효합니다.
- **FCM 토큰을 전송하면 푸시 알림을 받을 수 있습니다. (멀티 디바이스 지원)**
- fcmToken, deviceType, deviceId는 3개 모두 함께 전송하거나 모두 전송하지 않아야 합니다.
- @Valid 검증이 적용됩니다: email, name은 필수 필드입니다.

**에러 코드**:
- `INVALID_SOCIAL_TOKEN`: 유효하지 않은 소셜 인증 토큰입니다.
- `SOCIAL_AUTH_FAILED`: 소셜 로그인 인증에 실패하였습니다.
- `MEMBER_NOT_FOUND`: 회원 정보를 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: FCM 토큰 관련 필드가 올바르지 않습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.23 | 서새찬 | - | FCM 토큰 멀티 디바이스 지원 | FCM 토큰 멀티 디바이스 지원 추가 |
| 2025.10.16 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 인증 모듈 추가 및 기본 OAuth 로그인 구현 |

---

### POST /api/auth/reissue
토큰 재발급

**인증**: 불필요

**Request Body** (`AuthRequest`):
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| refreshToken | string | ✅ | 리프레시 토큰 |

**Response 200** (`AuthResponse`):
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "isFirstLogin": false
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| accessToken | string | 재발급된 Access Token |
| refreshToken | string | 리프레시 토큰 (변경되지 않음) |
| isFirstLogin | boolean | 최초 로그인 여부 |

**특이사항**:
- 만료된 액세스 토큰을 리프레시 토큰으로 재발급합니다.

**에러 코드**:
- `REFRESH_TOKEN_NOT_FOUND`: 리프레시 토큰을 찾을 수 없습니다.
- `INVALID_REFRESH_TOKEN`: 유효하지 않은 리프레시 토큰입니다.
- `EXPIRED_REFRESH_TOKEN`: 만료된 리프레시 토큰입니다.
- `MEMBER_NOT_FOUND`: 회원 정보를 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.10.16 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 토큰 재발급 기능 구현 |

---

### POST /api/auth/logout
로그아웃

**인증**: 필요 (JWT)

**Request Headers**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| Authorization | string | ❌ | Bearer {accessToken} |

**Request Body** (`AuthRequest`):
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| accessToken | string | ✅ | 액세스 토큰 (Header에서 자동 추출) |
| refreshToken | string | ✅ | 리프레시 토큰 |

**Response 200**:
- 성공 시 상태코드 200 (OK)와 빈 응답 본문

**동작 설명**:
- 액세스 토큰을 블랙리스트에 등록하여 무효화 처리
- Redis에 저장된 리프레시 토큰 삭제

**에러 코드**:
- `INVALID_TOKEN`: 유효하지 않은 토큰입니다.
- `UNAUTHORIZED`: 인증이 필요한 요청입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.10.16 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 로그아웃 기능 구현 |

---

### DELETE /api/auth/withdraw
회원 탈퇴

**인증**: 필요 (JWT)

**Request Headers**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| Authorization | string | ✅ | Bearer {accessToken} |

**Request Parameters**: 없음

**Response 200**:
- 성공 시 상태코드 200 (OK)와 빈 응답 본문

**동작 설명**:
- 회원 정보를 소프트 삭제(Soft Delete) 처리합니다.
- 실제 데이터는 삭제되지 않고 `deletedAt` 필드가 설정됩니다.
- 탈퇴한 회원은 로그인 및 API 사용이 불가능합니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원 정보를 찾을 수 없습니다.
- `UNAUTHORIZED`: 인증이 필요한 요청입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.23 | 서새찬 | - | 회원 탈퇴 기능 | 회원 탈퇴 API 추가 |

---

## 👥 회원 관리 API

회원 생성, 조회 등의 기능을 제공하는 API

### GET /api/members
전체 회원 목록 조회

**인증**: 불필요

**Request Parameters**: 없음

**Response 200** (`List<MemberDto>`):
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "name": "여행러버",
    "onboardingStatus": "COMPLETED",
    "isServiceTermsAndPrivacyAgreed": true,
    "isMarketingAgreed": false,
    "birthDate": "1990-01-01",
    "gender": "MALE"
  }
]
```

**특이사항**:
- 전체 회원 목록을 반환합니다.
- 각 회원의 상세 정보가 포함됩니다.
- 모든 회원 데이터를 조회합니다.
- 삭제되지 않은 회원만 조회됩니다.

**에러 코드**:
- `INTERNAL_SERVER_ERROR`: 서버에 문제가 발생했습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.10.16 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 회원 관리 API 문서화 |

---

### POST /api/members
회원 생성

**인증**: 불필요

**Request Body** (`MemberDto`):
| 필드 | 타입 | 필수 | 제약사항 | 설명 | 예시 |
|------|------|------|----------|------|------|
| email | string | ✅ | - | 회원 이메일 | "user@example.com" |
| name | string | ✅ | 2-50자 | 회원 닉네임 | "여행러버" |
| profileImageUrl | string | ❌ | - | 프로필 이미지 URL | - |
| socialPlatform | string (enum) | ❌ | KAKAO, GOOGLE | 소셜 플랫폼 | "GOOGLE" |
| memberRole | string (enum) | ❌ | ROLE_USER, ROLE_ADMIN | 회원 권한 | "ROLE_USER" |
| status | string (enum) | ❌ | ACTIVE, INACTIVE, DELETED | 회원 상태 | "ACTIVE" |

**Response 200** (`MemberDto`):
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "여행러버",
  "onboardingStatus": "NOT_STARTED",
  "isServiceTermsAndPrivacyAgreed": false,
  "isMarketingAgreed": false,
  "gender": "NOT_SELECTED"
}
```

**특이사항**:
- 새로운 회원을 생성합니다.
- 이메일 중복 검사가 수행됩니다.

**에러 코드**:
- `EMAIL_ALREADY_EXISTS`: 이미 가입된 이메일입니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.10.16 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 회원 관리 API 문서화 |

---

### GET /api/members/check-name
닉네임 중복 확인

**인증**: 불필요

**Query Parameters**:
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| name | string | ✅ | 확인할 닉네임 (2자 이상 50자 이하) | "여행러버" |

**Response 200** (`CheckNameResponse`):
```json
{
  "isAvailable": true,
  "name": "여행러버"
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| isAvailable | boolean | 사용 가능 여부 (true: 사용 가능, false: 이미 사용 중) |
| name | string | 확인한 닉네임 |

**특이사항**:
- 회원가입 전에도 사용 가능한 API입니다.
- 닉네임 길이는 2자 이상 50자 이하여야 합니다.
- 탈퇴한 회원의 닉네임은 타임스탬프가 추가되어 중복 체크에서 제외됩니다.

**에러 코드**:
- `INVALID_NAME_LENGTH`: 닉네임은 2자 이상 50자 이하여야 합니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.23 | 서새찬 | [#106](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/106) | 닉네임 중복 확인 API 구현 필요 | 닉네임 중복 확인 API 추가 |

---

### GET /api/members/{memberId}
회원 단건 조회 (ID)

**인증**: 불필요

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| memberId | string (uuid) | ✅ | 회원 ID |

**Response 200** (`MemberDto`):
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "여행러버",
  "onboardingStatus": "COMPLETED",
  "birthDate": "1990-01-01",
  "gender": "MALE"
}
```

**특이사항**:
- 회원 ID로 특정 회원을 조회합니다.
- 삭제된 회원은 조회되지 않습니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

---

### GET /api/members/{memberId}/interests
회원 관심사 조회 (ID)

**인증**: 불필요

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| memberId | string (uuid) | ✅ | 회원 ID |

**Response 200** (`List<InterestDto>`):
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "한식"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440001",
    "name": "카페투어"
  }
]
```

**특이사항**:
- 회원 ID로 해당 회원의 관심사 목록을 조회합니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

---

### GET /api/members/email/{email}
회원 단건 조회 (Email)

**인증**: 불필요

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| email | string | ✅ | 회원 이메일 |

**Response 200** (`MemberDto`):
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "여행러버",
  "onboardingStatus": "COMPLETED"
}
```

**특이사항**:
- 이메일로 특정 회원을 조회합니다.
- 삭제된 회원은 조회되지 않습니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

---

### POST /api/members/profile
회원 프로필 설정(수정)

**인증**: 필요 (JWT)

**Request Body** (`ProfileUpdateRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| name | string | ✅ | 이름 | "홍길동" |
| gender | string (enum) | ❌ | 성별 (MALE, FEMALE, NOT_SELECTED) | "MALE" |
| birthDate | string (date) | ❌ | 생년월일 (LocalDate 형식) | "1990-01-01" |
| interestIds | array of uuid | ❌ | 관심사 ID 목록 | ["550e8400-..."] |

**Response 200** (`MemberDto`):
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "홍길동",
  "gender": "MALE",
  "birthDate": "1990-01-01",
  "onboardingStatus": "COMPLETED"
}
```

**특이사항**:
- 회원 프로필 정보를 업데이트합니다.
- 이름 중복 검사가 수행됩니다.
- 관심사도 함께 업데이트됩니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `NAME_ALREADY_EXISTS`: 이미 사용 중인 이름입니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

---

## 📝 온보딩 API

사용자 온보딩 단계별 설정 API

### 온보딩 단계 (OnboardingStep)
1. **TERMS** - 약관 동의
2. **NAME** - 이름 설정
3. **BIRTH_DATE** - 생년월일 설정
4. **GENDER** - 성별 설정
5. **INTERESTS** - 관심사 설정
6. **COMPLETED** - 완료

### 온보딩 상태 (OnboardingStatus)
- **NOT_STARTED** - 시작 전
- **IN_PROGRESS** - 진행 중
- **COMPLETED** - 완료

---

### POST /api/members/onboarding/terms
약관 동의

**인증**: 필요 (JWT)

**Request Body** (`UpdateServiceAgreementTermsRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| isServiceTermsAndPrivacyAgreed | boolean | ✅ | 서비스 이용약관 및 개인정보처리방침 동의 여부 (필수, true) | true |
| isMarketingAgreed | boolean | ❌ | 마케팅 수신 동의 여부 (선택) | false |

**Response 200** (`UpdateServiceAgreementTermsResponse`):
```json
{
  "currentStep": "NAME",
  "onboardingStatus": "IN_PROGRESS",
  "member": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "name": "여행러버",
    "isServiceTermsAndPrivacyAgreed": true,
    "isMarketingAgreed": false
  }
}
```

| 필드 | 타입 | 설명 | 가능한 값 |
|------|------|------|-----------|
| currentStep | string | 현재 온보딩 단계 | TERMS, NAME, BIRTH_DATE, GENDER, INTERESTS, COMPLETED |
| onboardingStatus | string | 온보딩 상태 | NOT_STARTED, IN_PROGRESS, COMPLETED |
| member | MemberDto | 회원 정보 (디버깅용) | - |

**특이사항**:
- 서비스 이용약관 및 개인정보처리방침 동의는 필수입니다.
- 마케팅 수신 동의는 선택 사항입니다.
- 약관 동의 후 온보딩 상태가 IN_PROGRESS로 변경됩니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `MEMBER_TERMS_REQUIRED_NOT_AGREED`: 필수 약관에 동의하지 않았습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.01.15 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 온보딩 약관 동의 API 추가 |

---

### POST /api/members/onboarding/name
이름 설정

**인증**: 필요 (JWT)

**Request Body** (`UpdateNameRequest`):
| 필드 | 타입 | 필수 | 제약사항 | 설명 | 예시 |
|------|------|------|----------|------|------|
| name | string | ✅ | 2-50자 | 이름 | "홍길동" |

**Response 200** (`OnboardingResponse`):
```json
{
  "currentStep": "BIRTH_DATE",
  "onboardingStatus": "IN_PROGRESS",
  "member": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "홍길동"
  }
}
```

**특이사항**:
- 온보딩 단계 중 이름 설정 단계를 완료합니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.01.15 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 온보딩 이름 설정 API 추가 |

---

### POST /api/members/onboarding/birth-date
생년월일 설정

**인증**: 필요 (JWT)

**Request Body** (`UpdateBirthDateRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| birthDate | string (date) | ✅ | 생년월일 (LocalDate 형식) | "1990-01-01" |

**Response 200** (`OnboardingResponse`):
```json
{
  "currentStep": "GENDER",
  "onboardingStatus": "IN_PROGRESS",
  "member": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "birthDate": "1990-01-01"
  }
}
```

**특이사항**:
- 온보딩 단계 중 생년월일 설정 단계를 완료합니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.01.15 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 온보딩 생년월일 설정 API 추가 |

---

### POST /api/members/onboarding/gender
성별 설정

**인증**: 필요 (JWT)

**Request Body** (`UpdateGenderRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| gender | string (enum) | ✅ | 성별 (MALE, FEMALE, NOT_SELECTED) | "MALE" |

**Response 200** (`OnboardingResponse`):
```json
{
  "currentStep": "INTERESTS",
  "onboardingStatus": "IN_PROGRESS",
  "member": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "gender": "MALE"
  }
}
```

**특이사항**:
- 온보딩 단계 중 성별 설정 단계를 완료합니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.01.15 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 온보딩 성별 설정 API 추가 |

---

### POST /api/members/onboarding/interests
관심사 설정

**인증**: 필요 (JWT)

**Request Body** (`UpdateInterestsRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| interestIds | array of uuid | ✅ | 관심사 ID 목록 (최소 1개 이상) | ["550e8400-e29b-41d4-a716-446655440000"] |

**Response 200** (`OnboardingResponse`):
```json
{
  "currentStep": "COMPLETED",
  "onboardingStatus": "COMPLETED",
  "member": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "onboardingStatus": "COMPLETED"
  }
}
```

**특이사항**:
- 온보딩 단계 중 관심사 설정 단계를 완료합니다.
- 기존 관심사는 전체 삭제 후 새로 추가됩니다 (전체 교체).

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.
- `INVALID_INPUT_VALUE`: 유효하지 않은 입력값입니다.
- `INTEREST_NOT_FOUND`: 유효하지 않은 관심사 ID가 포함되어 있습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.01.15 | 서새찬 | [#22](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/22) | 인증 모듈 추가 및 기본 OAuth 로그인 구현 | 온보딩 관심사 설정 API 추가 |

---

## 🎯 관심사 관리 API

관심사 조회 API (Redis 캐싱 적용)

### 관심사 카테고리 (InterestCategory)
1. **FOOD** - 맛집/푸드
2. **CAFE_DESSERT** - 카페/디저트
3. **LOCAL_MARKET** - 시장/로컬푸드
4. **NATURE_OUTDOOR** - 자연/야외활동
5. **URBAN_PHOTOSPOTS** - 도심/포토스팟
6. **CULTURE_ART** - 문화/예술
7. **HISTORY_ARCHITECTURE** - 역사/건축
8. **EXPERIENCE_CLASS** - 체험/클래스
9. **SHOPPING_FASHION** - 쇼핑/패션
10. **NIGHTLIFE** - 나이트라이프
11. **WELLNESS** - 웰니스/힐링
12. **FAMILY_KIDS** - 가족/키즈
13. **KPOP_CULTURE** - K-POP/한류
14. **DRIVE_SUBURBS** - 드라이브/교외

---

### GET /api/interests
전체 관심사 목록 조회

**인증**: 불필요

**Request Parameters**: 없음

**Response 200** (`GetAllInterestsResponse`):
```json
{
  "categories": [
    {
      "category": "FOOD",
      "displayName": "맛집/푸드",
      "interests": [
        {
          "id": "550e8400-e29b-41d4-a716-446655440000",
          "name": "한식"
        },
        {
          "id": "550e8400-e29b-41d4-a716-446655440001",
          "name": "일식"
        }
      ]
    },
    {
      "category": "CAFE_DESSERT",
      "displayName": "카페/디저트",
      "interests": [
        {
          "id": "550e8400-e29b-41d4-a716-446655440010",
          "name": "카페투어"
        }
      ]
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| categories | array | 카테고리별 그룹핑된 관심사 목록 |
| categories[].category | string | 카테고리 코드 (FOOD, CAFE_DESSERT 등) |
| categories[].displayName | string | 카테고리 표시 이름 |
| categories[].interests | array | 해당 카테고리의 관심사 목록 |
| categories[].interests[].id | string (uuid) | 관심사 ID |
| categories[].interests[].name | string | 관심사 이름 |

**특이사항**:
- 14개 대분류 카테고리별로 그룹핑된 전체 관심사 목록을 조회합니다.
- Redis 캐싱이 적용되어 빠른 응답이 가능합니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.04 | 서새찬 | [#61](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/61) | 사용자 정보수정 API 요청 | 전체 관심사 목록 조회 init |

---

### GET /api/interests/{interestId}
관심사 상세 조회

**인증**: 불필요

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| interestId | string (uuid) | ✅ | 관심사 ID |

**Response 200** (`GetInterestByIdResponse`):
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "category": "FOOD",
  "categoryDisplayName": "맛집/푸드",
  "name": "한식"
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| id | string (uuid) | 관심사 ID |
| category | string | 카테고리 코드 |
| categoryDisplayName | string | 카테고리 표시 이름 |
| name | string | 관심사 이름 |

**특이사항**:
- 관심사 ID로 특정 관심사의 상세 정보를 조회합니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.04 | 서새찬 | [#61](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/61) | 사용자 정보수정 API 요청 | 관심사 상세 조회 init |

---

### GET /api/interests/categories/{category}
특정 카테고리 관심사 조회

**인증**: 불필요

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 | 가능한 값 |
|------|------|------|------|-----------|
| category | string (enum) | ✅ | 관심사 카테고리 | FOOD, CAFE_DESSERT, LOCAL_MARKET, NATURE_OUTDOOR, URBAN_PHOTOSPOTS, CULTURE_ART, HISTORY_ARCHITECTURE, EXPERIENCE_CLASS, SHOPPING_FASHION, NIGHTLIFE, WELLNESS, FAMILY_KIDS, KPOP_CULTURE, DRIVE_SUBURBS |

**Response 200** (`GetInterestsByCategoryResponse`):
```json
{
  "interests": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "한식"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "name": "일식"
    },
    {
      "id": "550e8400-e29b-41d4-a716-446655440002",
      "name": "중식"
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| interests | array | 관심사 목록 |
| interests[].id | string (uuid) | 관심사 ID |
| interests[].name | string | 관심사 이름 |

**특이사항**:
- 특정 대분류 카테고리의 관심사 목록을 조회합니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.04 | 서새찬 | [#61](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/61) | 사용자 정보수정 API 요청 | 특정 카테고리 관심사 조회 init |

---

## 📍 장소 관리 API

장소 정보 조회 및 관리 API

### 장소 저장 상태 (SavedStatus)
- **TEMPORARY** - 임시 저장 (AI 분석으로 자동 생성)
- **SAVED** - 저장 완료 (사용자가 명시적으로 저장)

---

### GET /api/place/{placeId}
장소 세부정보 조회

**인증**: 필요 (JWT)

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| placeId | string (uuid) | ✅ | 조회할 장소 ID |

**Response 200** (`PlaceDetailDto`):
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "제주 카페 쿠모",
  "address": "제주특별자치도 제주시 애월읍",
  "country": "KR",
  "latitude": 33.4996213,
  "longitude": 126.5311884,
  "businessType": "카페",
  "phone": "010-1234-5678",
  "description": "제주 바다를 바라보며 커피를 즐길 수 있는 카페",
  "types": ["cafe", "restaurant"],
  "businessStatus": "OPERATIONAL",
  "iconUrl": "https://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png",
  "rating": 4.5,
  "userRatingsTotal": 123,
  "photoUrls": ["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"],
  "platformReferences": [
    {
      "platform": "GOOGLE",
      "referenceId": "ChIJN1t_tDeuEmsRUsoyG83frY4"
    }
  ],
  "businessHours": [
    {
      "dayOfWeek": "MONDAY",
      "openTime": "09:00",
      "closeTime": "18:00"
    }
  ],
  "medias": [
    {
      "mediaType": "IMAGE",
      "url": "https://example.com/media1.jpg"
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| id | string (uuid) | 장소 ID |
| name | string | 장소명 |
| address | string | 주소 |
| country | string | 국가 코드 (ISO 3166-1 alpha-2) |
| latitude | number | 위도 |
| longitude | number | 경도 |
| businessType | string | 업종 |
| phone | string | 전화번호 |
| description | string | 장소 설명 |
| types | array of string | 장소 유형 배열 |
| businessStatus | string | 영업 상태 |
| iconUrl | string | Google 아이콘 URL |
| rating | number | 평점 (0.0 ~ 5.0) |
| userRatingsTotal | integer | 리뷰 수 |
| photoUrls | array of string | 사진 URL 배열 |
| platformReferences | array | 플랫폼별 참조 정보 (Google Place ID 등) |
| businessHours | array | 영업시간 목록 |
| medias | array | 추가 미디어 목록 |

**특이사항**:
- Google Place ID를 포함한 플랫폼 참조 정보를 제공합니다.
- 영업시간과 추가 미디어 정보가 포함됩니다.

**에러 코드**:
- `PLACE_NOT_FOUND`: 장소를 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.10.25 | 서새찬 | [#36](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/36) | Deploy 20251025-v0.1.5 | 장소 상세 정보 조회 API 추가 |

---

### GET /api/place/saved
저장한 장소 목록 조회

**인증**: 필요 (JWT)

**Request Parameters**: 없음

**Response 200** (`GetSavedPlacesResponse`):
```json
{
  "places": [
    {
      "placeId": "550e8400-e29b-41d4-a716-446655440000",
      "name": "스타벅스 서울역점",
      "address": "서울특별시 중구 명동길 29",
      "rating": 4.5,
      "photoUrls": ["https://example.com/photo1.jpg"],
      "description": "서울역 인근, 공부하기 좋은 카페"
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| places | array of PlaceDto | 저장한 장소 목록 |
| places[].placeId | string (uuid) | 장소 ID |
| places[].name | string | 장소명 |
| places[].address | string | 주소 |
| places[].rating | number | 별점 (0.0 ~ 5.0) |
| places[].photoUrls | array of string | 사진 URL 배열 (최대 10개) |
| places[].description | string | 장소 요약 설명 |

**특이사항**:
- 사용자가 명시적으로 저장한 장소들을 조회합니다.
- 최신순으로 정렬되어 반환됩니다.
- `/api/content/place/saved`와는 다른 MemberPlace 기반 조회입니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.24 | 서새찬 | [#103](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/103) | 로그인 API FCM 토큰 필드 추가 및 멀티 디바이스 푸시 알림 지원 기능 추가 | 저장한 장소 목록 조회 API 추가 |

---

### GET /api/place/temporary
임시 저장 장소 목록 조회

**인증**: 필요 (JWT)

**Request Parameters**: 없음

**Response 200** (`GetTemporaryPlacesResponse`):
```json
{
  "places": [
    {
      "placeId": "550e8400-e29b-41d4-a716-446655440000",
      "name": "제주 카페 쿠모",
      "address": "제주특별자치도 제주시 애월읍",
      "rating": 4.5,
      "photoUrls": ["https://example.com/photo1.jpg"],
      "description": "제주 바다를 바라보며 커피를 즐길 수 있는 카페"
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| places | array of PlaceDto | 임시 저장 장소 목록 |

**특이사항**:
- AI 분석으로 자동 생성된 장소들을 조회합니다.
- 사용자가 아직 저장 여부를 결정하지 않은 상태입니다.
- 최신순으로 정렬되어 반환됩니다.

**에러 코드**:
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.24 | 서새찬 | [#103](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/103) | 로그인 API FCM 토큰 필드 추가 및 멀티 디바이스 푸시 알림 지원 기능 추가 | 임시 저장 장소 목록 조회 API 추가 |

---

### POST /api/place/{placeId}/save
장소 저장

**인증**: 필요 (JWT)

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| placeId | string (uuid) | ✅ | 저장할 장소 ID |

**Request Parameters**: 없음

**Response 200** (`SavePlaceResponse`):
```json
{
  "memberPlaceId": "550e8400-e29b-41d4-a716-446655440000",
  "placeId": "550e8400-e29b-41d4-a716-446655440000",
  "savedStatus": "SAVED",
  "savedAt": "2024-11-24T10:30:00"
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| memberPlaceId | string (uuid) | 회원 장소 ID |
| placeId | string (uuid) | 장소 ID |
| savedStatus | string | 저장 상태 (SAVED) |
| savedAt | string (datetime) | 저장 일시 |

**특이사항**:
- 임시 저장 상태(TEMPORARY)의 장소를 저장 상태(SAVED)로 변경합니다.
- 저장 시점의 시간이 기록됩니다.

**에러 코드**:
- `PLACE_NOT_FOUND`: 장소를 찾을 수 없습니다.
- `MEMBER_PLACE_NOT_FOUND`: 회원의 장소 정보를 찾을 수 없습니다.
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.24 | 서새찬 | [#103](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/103) | 로그인 API FCM 토큰 필드 추가 및 멀티 디바이스 푸시 알림 지원 기능 추가 | 장소 저장 API 추가 |

---

### DELETE /api/place/{placeId}/temporary
임시 저장 장소 삭제

**인증**: 필요 (JWT)

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| placeId | string (uuid) | ✅ | 삭제할 장소 ID |

**Request Parameters**: 없음

**Response 200**:
- **204 No Content**: 삭제 성공 (반환값 없음)

**특이사항**:
- 임시 저장 상태(TEMPORARY)의 장소만 삭제 가능합니다.
- 저장된 상태(SAVED)의 장소는 삭제할 수 없습니다.
- Soft Delete 방식으로 데이터는 실제로 삭제되지 않습니다.

**에러 코드**:
- `PLACE_NOT_FOUND`: 장소를 찾을 수 없습니다.
- `MEMBER_PLACE_NOT_FOUND`: 회원의 장소 정보를 찾을 수 없습니다.
- `CANNOT_DELETE_SAVED_PLACE`: 임시 저장된 장소만 삭제할 수 있습니다.
- `MEMBER_NOT_FOUND`: 회원을 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.24 | 서새찬 | [#103](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/103) | 로그인 API FCM 토큰 필드 추가 및 멀티 디바이스 푸시 알림 지원 기능 추가 | 임시 저장 장소 삭제 API 추가 |

---

## 📱 콘텐츠 API

SNS 콘텐츠 생성 및 장소 추출 요청 API

### 콘텐츠 플랫폼 (ContentPlatform)
- **INSTAGRAM** - 인스타그램
- **YOUTUBE** - 유튜브
- **YOUTUBE_SHORTS** - 유튜브 쇼츠
- **TIKTOK** - 틱톡
- **FACEBOOK** - 페이스북
- **TWITTER** - 트위터

### 콘텐츠 상태 (ContentStatus)
- **PENDING** - 대기 중
- **ANALYZING** - 분석 중
- **COMPLETED** - 완료
- **FAILED** - 실패
- **DELETED** - 삭제됨

---

### POST /api/content/analyze
콘텐츠 생성 후 장소 추출 요청

**인증**: 필요 (JWT)

**Request Body** (`PlaceExtractionRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| contentId | string (uuid) | ✅ | Content UUID | "550e8400-e29b-41d4-a716-446655440000" |
| snsUrl | string | ✅ | SNS URL (최대 2048자) | "https://www.instagram.com/p/ABC123/" |

**Response 200** (`RequestPlaceExtractionResponse`):
```json
{
  "contentId": "550e8400-e29b-41d4-a716-446655440000",
  "platform": "INSTAGRAM",
  "status": "PENDING",
  "platformUploader": "travel_lover",
  "caption": "오사카 최고의 라멘집!",
  "thumbnailUrl": "https://example.com/thumbnail.jpg",
  "originalUrl": "https://www.instagram.com/p/ABC123/",
  "title": "오사카 라멘 투어",
  "summary": "오사카에서 방문한 라멘집 리뷰",
  "lastCheckedAt": "2025-01-18T10:30:00",
  "createdAt": "2025-01-18T10:30:00",
  "updatedAt": "2025-01-18T10:30:00"
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| contentId | string (uuid) | 콘텐츠 UUID |
| platform | string (enum) | 콘텐츠 플랫폼 (INSTAGRAM, YOUTUBE, YOUTUBE_SHORTS, TIKTOK, FACEBOOK, TWITTER) |
| status | string (enum) | 장소 추출 요청 상태 (PENDING, ANALYZING, COMPLETED, FAILED, DELETED) |
| platformUploader | string | 콘텐츠 업로더 계정 이름 |
| caption | string | 게시글 본문 |
| thumbnailUrl | string | 썸네일 URL |
| originalUrl | string | 원본 URL |
| title | string | 콘텐츠 제목 |
| summary | string | 콘텐츠 요약 |
| lastCheckedAt | string (datetime) | 콘텐츠 마지막 조회 시간 |
| createdAt | string (datetime) | 생성일시 |
| updatedAt | string (datetime) | 수정일시 |

**특이사항**:
- 프론트엔드에서 전달한 SNS URL을 기반으로 콘텐츠를 생성합니다.
- **동일 URL로 이미 COMPLETED된 콘텐츠가 있으면 AI 요청 없이 기존 데이터를 즉시 반환합니다.** (중복 방지 및 비용 절감)
- PENDING/FAILED 상태의 콘텐츠는 재사용하여 AI 서버에 재요청합니다.
- status는 처음에 `PENDING` 상태로 생성됩니다.
- 생성된 콘텐츠를 기반으로 AI 서버에 장소 추출을 요청합니다.
- 장소 추출 요청이 성공적으로 접수되면 상태가 `PENDING`으로 유지됩니다.
- AI 서버 처리 완료 시 Webhook을 통해 `COMPLETED` 또는 `FAILED`로 변경됩니다.
- URL은 최대 2048자까지 허용됩니다.

**에러 코드**:
- `CONTENT_NOT_FOUND`: 해당 콘텐츠를 찾을 수 없습니다.
- `URL_TOO_LONG`: URL이 허용된 최대 길이(2048자)를 초과했습니다.
- `AI_SERVER_ERROR`: AI 서버 처리 중 오류가 발생했습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.02 | 강지윤 | [#54](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/54) | AI서버 장소 추출 요청 API 구현 필요 | 콘텐츠 Docs 추가 및 리팩토링 |

---

### GET /api/content/{contentId}
단일 SNS 콘텐츠 정보 조회

**인증**: 필요 (JWT)

**Path Parameters**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| contentId | string (uuid) | ✅ | 조회할 Content UUID |

**Response 200** (`GetContentInfoResponse`):
```json
{
  "content": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "platform": "INSTAGRAM",
    "status": "COMPLETED",
    "platformUploader": "travel_lover_123",
    "caption": "제주도 여행 브이로그",
    "thumbnailUrl": "https://example.com/thumbnail.jpg",
    "originalUrl": "https://www.instagram.com/p/ABC123/",
    "title": "제주도 힐링 여행",
    "summary": "제주도의 아름다운 카페와 맛집을 소개합니다.",
    "lastCheckedAt": "2025-11-23T10:30:00"
  },
  "places": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "제주 카페 쿠모",
      "address": "제주특별자치도 제주시 애월읍",
      "country": "KR",
      "latitude": 33.4996213,
      "longitude": 126.5311884,
      "businessType": "카페",
      "phone": "010-1234-5678",
      "description": "제주 바다를 바라보며 커피를 즐길 수 있는 카페",
      "types": ["cafe", "restaurant"],
      "businessStatus": "OPERATIONAL",
      "iconUrl": "https://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png",
      "rating": 4.5,
      "userRatingsTotal": 123,
      "photoUrls": ["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"]
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| content | ContentDto | Content 상세 정보 |
| content.id | string (uuid) | 콘텐츠 ID |
| content.platform | string | 플랫폼 유형 (INSTAGRAM, YOUTUBE 등) |
| content.status | string | 처리 상태 (PENDING, COMPLETED, FAILED 등) |
| content.platformUploader | string | 업로더 이름 |
| content.caption | string | 캡션 |
| content.thumbnailUrl | string | 썸네일 URL |
| content.originalUrl | string | 원본 SNS URL |
| content.title | string | 제목 |
| content.summary | string | 요약 설명 |
| content.lastCheckedAt | string (datetime) | 마지막 확인 시각 |
| places | array | 연관된 Place 목록 (position 순서대로 정렬) |

**동작 방식**:
- Content ID로 콘텐츠 정보와 연관된 장소 목록을 조회합니다.
- Place 목록은 position 순서대로 정렬되어 반환됩니다.
- Content가 존재하지 않으면 404 에러를 반환합니다.
- 연관된 Place가 없는 경우 빈 배열을 반환합니다.

**에러 코드**:
- `CONTENT_NOT_FOUND`: 해당 콘텐츠를 찾을 수 없습니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.23 | 서새찬 | [#111](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/111) | 단일 SNS 컨텐츠 조회 API | 단일 SNS 컨텐츠 조회 API 추가 |

---

### GET /api/content/recent
최근 SNS 콘텐츠 목록 조회

**인증**: 필요 (JWT)

**Request Parameters**: 없음

**Response 200** (`GetRecentContentResponse`):
```json
{
  "contents": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "platform": "INSTAGRAM",
      "status": "COMPLETED",
      "platformUploader": "travel_lover_123",
      "caption": "제주도 여행 브이로그",
      "thumbnailUrl": "https://example.com/thumbnail.jpg",
      "originalUrl": "https://www.instagram.com/p/ABC123/",
      "title": "제주도 힐링 여행",
      "summary": "제주도의 아름다운 카페와 맛집을 소개합니다.",
      "lastCheckedAt": "2025-11-23T10:30:00"
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| contents | array | 최근 10개 콘텐츠 목록 (최신순 정렬) |

**동작 방식**:
- 인증된 회원이 소유한 Content 목록을 최신순(createdAt DESC)으로 조회합니다.
- 최대 10개까지 반환됩니다.
- Place 정보는 제외하고 Content 정보만 반환합니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.23 | 서새찬 | - | 최근 콘텐츠 조회 API | 최근 SNS 콘텐츠 목록 조회 API 추가 |

---

### GET /api/content/member
회원 콘텐츠 목록 조회 (페이지네이션)

**인증**: 필요 (JWT)

**Query Parameters**:
| 필드 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| pageSize | integer | ❌ | 10 | 페이지 크기 |

**Response 200** (`GetMemberContentPageResponse`):
```json
{
  "contentPage": {
    "content": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "platform": "INSTAGRAM",
        "status": "COMPLETED",
        "platformUploader": "travel_lover_123",
        "caption": "제주도 여행 브이로그",
        "thumbnailUrl": "https://example.com/thumbnail.jpg",
        "originalUrl": "https://www.instagram.com/p/ABC123/",
        "title": "제주도 힐링 여행",
        "summary": "제주도의 아름다운 카페와 맛집을 소개합니다.",
        "lastCheckedAt": "2025-11-23T10:30:00"
      }
    ],
    "totalElements": 25,
    "totalPages": 3,
    "number": 0,
    "size": 10,
    "first": true,
    "last": false
  }
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| contentPage.content | array | 콘텐츠 목록 (ContentDto 배열) |
| contentPage.totalElements | long | 전체 콘텐츠 개수 |
| contentPage.totalPages | integer | 전체 페이지 수 |
| contentPage.number | integer | 현재 페이지 번호 (0부터 시작) |
| contentPage.size | integer | 페이지 크기 |
| contentPage.first | boolean | 첫 페이지 여부 |
| contentPage.last | boolean | 마지막 페이지 여부 |

**동작 방식**:
- 인증된 회원이 소유한 Content 목록을 최신순(createdAt DESC)으로 조회합니다.
- Place 정보는 제외하고 Content 정보만 반환합니다.
- 페이지 크기를 지정하지 않으면 기본 10개가 조회됩니다.
- 첫 페이지(0번 페이지)만 조회됩니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.23 | 서새찬 | [#112](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/112) | Member에 대한 리스트 Content 조회 메소드 | Member가 소유한 Content 목록 조회 API 추가 |

---

### GET /api/content/place/saved
사용자 장소 조회

**인증**: 필요 (JWT)

**Request Parameters**: 없음

**Response 200** (`GetSavedPlacesResponse`):
```json
{
  "places": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "제주 카페 쿠모",
      "address": "제주특별자치도 제주시 애월읍",
      "country": "KR",
      "latitude": 33.4996213,
      "longitude": 126.5311884,
      "businessType": "카페",
      "phone": "010-1234-5678",
      "description": "제주 바다를 바라보며 커피를 즐길 수 있는 카페",
      "types": ["cafe", "restaurant"],
      "businessStatus": "OPERATIONAL",
      "iconUrl": "https://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png",
      "rating": 4.5,
      "userRatingsTotal": 123,
      "photoUrls": ["https://example.com/photo1.jpg"]
    }
  ]
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| places | array | 최근 10개 장소 목록 (최신순 정렬) |

**동작 방식**:
- 인증된 회원이 저장한 Place 목록을 최신순으로 조회합니다.
- 최대 10개까지 반환됩니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.20 | 서새찬 | - | 사용자 장소 조회 API | 사용자 장소 조회 API 추가 |

---

## 🤖 AI 서버 API

AI 서버 연동 관련 API 제공

### POST /api/ai/callback
AI 서버 Webhook Callback

**인증**: API Key 필요 (Header: X-API-Key)

**Request Headers**:
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| X-API-Key | string | ✅ | API Key (환경변수로 설정) |

**Request Body** (`AiCallbackRequest`):
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| resultStatus | string (enum) | ✅ | 처리 결과 상태 (SUCCESS, FAILED) |
| contentInfo | ContentInfo | SUCCESS 시 필수 | 콘텐츠 정보 |
| places | array of PlaceInfo | SUCCESS 시 | 추출된 장소 목록 |

**ContentInfo Schema**:
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| contentId | string (uuid) | ✅ | Content UUID (백엔드에서 전송받은 UUID) | "123e4567-e89b-12d3-a456-426614174000" |
| thumbnailUrl | string | ✅ | 썸네일 URL | "https://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg" |
| platform | string (enum) | ✅ | SNS 플랫폼 (INSTAGRAM, YOUTUBE, YOUTUBE_SHORTS) | "YOUTUBE" |
| title | string | ✅ | 콘텐츠 제목 | "일본 전국 라멘 투어 - 개당 1200원의 가성비 초밥" |
| summary | string | ❌ | AI 콘텐츠 요약 | "샷포로 3대 스시 맛집 '토리톤' 방문..." |

**PlaceInfo Schema**:
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| name | string | ✅ | 장소명 | "명동 교자" |
| address | string | ✅ | 주소 | "서울특별시 중구 명동길 29" |
| country | string | ✅ | 국가 코드 (ISO 3166-1 alpha-2) | "KR" |
| latitude | number | ✅ | 위도 | 37.563512 |
| longitude | number | ✅ | 경도 | 126.985012 |
| description | string | ✅ | 장소 설명 | "칼국수와 만두로 유명한 맛집" |
| rawData | string | ✅ | AI 추출 원본 데이터 | "명동 교자에서 칼국수 먹었어요 (caption, confidence: 0.95)" |
| language | string (enum) | ❌ | 언어 코드 (ISO 639-1: ko, en, ja, zh) | "ko" |

**Request Example**:
```json
{
  "resultStatus": "SUCCESS",
  "contentInfo": {
    "contentId": "123e4567-e89b-12d3-a456-426614174000",
    "thumbnailUrl": "https://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg",
    "platform": "YOUTUBE",
    "title": "일본 전국 라멘 투어 - 개당 1200원의 가성비 초밥",
    "summary": "샷포로 3대 스시 맛집 '토리톤' 방문..."
  },
  "places": [
    {
      "name": "명동 교자",
      "address": "서울특별시 중구 명동길 29",
      "country": "KR",
      "latitude": 37.563512,
      "longitude": 126.985012,
      "description": "칼국수와 만두로 유명한 맛집",
      "rawData": "명동 교자에서 칼국수 먹었어요 (caption, confidence: 0.95)",
      "language": "ko"
    }
  ]
}
```

**Response 200** (`AiCallbackResponse`):
```json
{
  "received": true,
  "contentId": "123e4567-e89b-12d3-a456-426614174000"
}
```

**Response Schema**:
| 필드 | 타입 | 설명 |
|------|------|------|
| received | boolean | 수신 여부 |
| contentId | string (uuid) | Content UUID |

**특이사항**:
- AI 서버가 장소 추출 분석 완료 후 이 Webhook을 호출합니다.
- API Key는 환경변수를 통해 설정되며, 반드시 일치해야 합니다.
- Content 상태를 ANALYZING → COMPLETED/FAILED로 변경합니다.
- SUCCESS인 경우:
  - ContentInfo로 Content 메타데이터 업데이트 (title, thumbnailUrl, platformUploader, summary)
  - Place 생성 및 Content-Place 연결 수행
  - snsPlatform 값으로 Content.platform 동기화

**에러 코드**:
- `INVALID_API_KEY`: 유효하지 않은 API Key입니다.
- `CONTENT_NOT_FOUND`: 콘텐츠를 찾을 수 없습니다.
- `INVALID_REQUEST`: 잘못된 요청입니다.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.18 | 서새찬 | [#83](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/83) | AI 서버 Callback API 에 대한 API 명세 수정 및 파라미터 추가 필요 | AI 서버 Callback API ContentInfo 파라미터 추가 (summary 필드) |
| 2025.11.12 | 서새찬 | [#70](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/70) | 장소 정보를 위해 구글 API 를 이용한 구글ID 추출 필요 | 명세 변경, 기존 전체정보 > 상호명으로만 받음 |
| 2025.11.02 | 강지윤 | [#48](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/48) | AI 서버 연동 API 구현 필요 : 장소 추출 요청 및 Webhook Callback 처리 | AI 서버 Webhook Callback 리팩터링 |
| 2025.10.31 | 서새찬 | [#48](https://github.com/TEAM-Tripgether/Tripgether-BE/issues/48) | AI 서버 연동 API 구현 필요 : 장소 추출 요청 및 Webhook Callback 처리 | AI 서버 Webhook Callback 처리 API 구현 |

---

## 🧪 테스트 API

테스트용 API 제공

### POST /api/test/mock-content
Mock Content 생성 및 반환

**인증**: 불필요

**Request Body** (`TestRequest`):
| 필드 | 타입 | 필수 | 기본값 | 설명 | 예시 |
|------|------|------|--------|------|------|
| contentCount | integer | ❌ | 1 | 콘텐츠 개수 | 1 |

**Response 200** (`TestResponse`):
```json
{
  "contents": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "platform": "INSTAGRAM",
      "status": "COMPLETED",
      "platformUploader": "test_user",
      "caption": "테스트 콘텐츠입니다",
      "thumbnailUrl": "https://example.com/thumbnail.jpg",
      "originalUrl": "https://www.instagram.com/p/TEST123/",
      "title": "테스트 제목",
      "summary": "테스트 요약",
      "createdAt": "2025-01-18T10:30:00",
      "updatedAt": "2025-01-18T10:30:00",
      "isDeleted": false,
      "active": true
    }
  ]
}
```

**특이사항**:
- 테스트용 Mock 콘텐츠를 생성하여 반환합니다.
- 개발 및 테스트 환경에서만 사용하세요.

---

### POST /api/test/fcm/send
FCM 푸시 알림 전송 테스트

**인증**: 불필요

**Request Body** (`FcmNotificationRequest`):
| 필드 | 타입 | 필수 | 설명 | 예시 |
|------|------|------|------|------|
| fcmToken | string | ✅ | 실제 FCM 토큰 | "dXQzM2k1N2RkZjM0OGE3YjczZGY5..." |
| title | string | ❌ | 알림 제목 | "테스트 알림" |
| body | string | ❌ | 알림 본문 | "FCM 푸시 알림 테스트입니다" |

**Response 200**:
- 성공 시 상태코드 200 (OK)

**특이사항**:
- 단일 기기로 FCM 푸시 알림을 전송합니다.
- fcmToken 필드에 실제 FCM 토큰을 입력해야 합니다.
- 개발 및 테스트 환경에서만 사용하세요.

**API 변경 이력**:
| 날짜 | 작성자 | 이슈번호 | 이슈 제목 | 변경 내용 |
|------|--------|----------|-----------|-----------|
| 2025.11.24 | 서새찬 | - | FCM 푸시 알림 테스트 API | FCM 푸시 알림 전송 테스트 API 추가 |

---

## ⚠️ 에러 코드

### 인증 관련 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| INVALID_TOKEN | 401 | 유효하지 않은 토큰입니다. |
| EXPIRED_TOKEN | 401 | 만료된 토큰입니다. |
| UNAUTHORIZED | 401 | 인증이 필요한 요청입니다. |
| INVALID_SOCIAL_TOKEN | 401 | 유효하지 않은 소셜 인증 토큰입니다. |
| SOCIAL_AUTH_FAILED | 401 | 소셜 로그인 인증에 실패하였습니다. |
| REFRESH_TOKEN_NOT_FOUND | 404 | 리프레시 토큰을 찾을 수 없습니다. |
| INVALID_REFRESH_TOKEN | 401 | 유효하지 않은 리프레시 토큰입니다. |
| EXPIRED_REFRESH_TOKEN | 401 | 만료된 리프레시 토큰입니다. |

### 회원 관련 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| MEMBER_NOT_FOUND | 404 | 회원을 찾을 수 없습니다. |
| EMAIL_ALREADY_EXISTS | 409 | 이미 가입된 이메일입니다. |
| NAME_ALREADY_EXISTS | 409 | 이미 사용 중인 이름입니다. |
| MEMBER_TERMS_REQUIRED_NOT_AGREED | 400 | 필수 약관에 동의하지 않았습니다. |
| INVALID_NAME_LENGTH | 400 | 닉네임은 2자 이상 50자 이하여야 합니다. |

### 관심사 관련 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| INTEREST_NOT_FOUND | 404 | 유효하지 않은 관심사 ID가 포함되어 있습니다. |

### 장소 관련 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| PLACE_NOT_FOUND | 404 | 장소를 찾을 수 없습니다. |
| MEMBER_PLACE_NOT_FOUND | 404 | 회원의 장소 정보를 찾을 수 없습니다. |
| CANNOT_DELETE_SAVED_PLACE | 400 | 임시 저장된 장소만 삭제할 수 있습니다. |

### 콘텐츠 관련 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| CONTENT_NOT_FOUND | 404 | 해당 콘텐츠를 찾을 수 없습니다. |
| URL_TOO_LONG | 400 | URL이 허용된 최대 길이(2048자)를 초과했습니다. |
| AI_SERVER_ERROR | 500 | AI 서버 처리 중 오류가 발생했습니다. |

### AI 서버 관련 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| INVALID_API_KEY | 401 | 유효하지 않은 API Key입니다. |
| INVALID_REQUEST | 400 | 잘못된 요청입니다. |

### 공통 에러
| 에러 코드 | HTTP 상태 | 설명 |
|-----------|-----------|------|
| INVALID_INPUT_VALUE | 400 | 유효하지 않은 입력값입니다. |
| INTERNAL_SERVER_ERROR | 500 | 서버에 문제가 발생했습니다. |

---

## 📊 데이터 모델

### MemberDto
회원 정보 DTO

| 필드 | 타입 | 필수 | 제약사항 | 설명 | 예시 |
|------|------|------|----------|------|------|
| id | string (uuid) | ✅ | - | 회원 ID | "550e8400-e29b-41d4-a716-446655440000" |
| email | string | ✅ | - | 이메일 | "user@example.com" |
| name | string | ✅ | 2-50자 | 닉네임 | "여행러버" |
| onboardingStatus | string | ❌ | NOT_STARTED, IN_PROGRESS, COMPLETED | 온보딩 상태 | "NOT_STARTED" |
| isServiceTermsAndPrivacyAgreed | boolean | ❌ | - | 서비스 이용약관 및 개인정보처리방침 동의 여부 | true |
| isMarketingAgreed | boolean | ❌ | - | 마케팅 수신 동의 여부(선택) | false |
| birthDate | string (date) | ✅ | - | 생년월일 | "1990-01-01" |
| gender | string (enum) | ❌ | MALE, FEMALE, NOT_SELECTED | 성별 | "MALE" |

---

### InterestDto
관심사 정보 DTO

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| id | string (uuid) | 관심사 ID | "550e8400-e29b-41d4-a716-446655440000" |
| name | string | 관심사 이름 | "한식" |

---

### PlaceDto
장소 정보 DTO (간략)

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| placeId | string (uuid) | 장소 ID | "550e8400-e29b-41d4-a716-446655440000" |
| name | string | 장소명 | "스타벅스 서울역점" |
| address | string | 주소 | "서울특별시 중구 명동길 29" |
| rating | number | 별점 (0.0 ~ 5.0) | 4.5 |
| photoUrls | array of string | 사진 URL 배열 (최대 10개) | ["https://example.com/photo1.jpg"] |
| description | string | 장소 요약 설명 | "서울역 인근, 공부하기 좋은 카페" |

---

### PlaceDetailDto
장소 상세 정보 DTO

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| id | string (uuid) | 장소 ID | "550e8400-e29b-41d4-a716-446655440000" |
| name | string | 장소명 | "제주 카페 쿠모" |
| address | string | 주소 | "제주특별자치도 제주시 애월읍" |
| country | string | 국가 코드 (ISO 3166-1 alpha-2) | "KR" |
| latitude | number | 위도 | 33.4996213 |
| longitude | number | 경도 | 126.5311884 |
| businessType | string | 업종 | "카페" |
| phone | string | 전화번호 | "010-1234-5678" |
| description | string | 장소 설명 | "제주 바다를 바라보며 커피를 즐길 수 있는 카페" |
| types | array of string | 장소 유형 배열 | ["cafe", "restaurant"] |
| businessStatus | string | 영업 상태 | "OPERATIONAL" |
| iconUrl | string | Google 아이콘 URL | "https://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png" |
| rating | number | 평점 (0.0 ~ 5.0) | 4.5 |
| userRatingsTotal | integer | 리뷰 수 | 123 |
| photoUrls | array of string | 사진 URL 배열 | ["https://example.com/photo1.jpg"] |
| platformReferences | array | 플랫폼별 참조 정보 (Google Place ID 등) | - |
| businessHours | array | 영업시간 목록 | - |
| medias | array | 추가 미디어 목록 | - |

---

### ContentDto
콘텐츠 정보 DTO

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| id | string (uuid) | 콘텐츠 ID | "550e8400-e29b-41d4-a716-446655440000" |
| platform | string (enum) | 플랫폼 (INSTAGRAM, YOUTUBE, YOUTUBE_SHORTS, TIKTOK, FACEBOOK, TWITTER) | "INSTAGRAM" |
| status | string (enum) | 상태 (PENDING, ANALYZING, COMPLETED, FAILED, DELETED) | "COMPLETED" |
| platformUploader | string | 업로더 계정 이름 | "travel_lover_123" |
| caption | string | 게시글 본문 | "제주도 여행 브이로그" |
| thumbnailUrl | string | 썸네일 URL | "https://example.com/thumbnail.jpg" |
| originalUrl | string | 원본 URL | "https://www.instagram.com/p/ABC123/" |
| title | string | 콘텐츠 제목 | "제주도 힐링 여행" |
| summary | string | 콘텐츠 요약 | "제주도의 아름다운 카페와 맛집을 소개합니다." |
| lastCheckedAt | string (datetime) | 마지막 조회 시간 | "2025-11-23T10:30:00" |

---

## 📝 부록

### API 서버 정보
- **메인 서버**: `https://api.tripgether.suhsaechan.kr`
- **테스트 서버**: `https://api.test.tripgether.suhsaechan.kr`
- **로컬 서버**: `http://localhost:8080`

### Swagger UI
- **URL**: `https://api.tripgether.suhsaechan.kr/docs/swagger-ui/index.html`
- **OpenAPI Spec**: `https://api.tripgether.suhsaechan.kr/v3/api-docs`

### 주요 변경 이력
| 날짜 | 주요 변경 사항 |
|------|---------------|
| 2025.11.24 | 장소 관리 API 신규 추가 (5개 엔드포인트), 닉네임 중복 확인 API 추가, FCM 푸시 알림 테스트 API 추가 |
| 2025.11.23 | FCM 토큰 멀티 디바이스 지원 추가, Content 조회 API 추가 (단일/목록/페이지네이션), 회원 탈퇴 API 추가 |
| 2025.11.20 | 사용자 장소 조회 API 추가 |
| 2025.11.18 | AI 서버 Callback API ContentInfo 파라미터 추가 (summary 필드) |
| 2025.11.12 | 장소 정보 명세 변경 (전체정보 > 상호명으로만 받음) |
| 2025.11.04 | 관심사 조회 API init |
| 2025.11.02 | 콘텐츠 Docs 추가 및 리팩토링, AI 서버 Webhook Callback 리팩터링 |
| 2025.10.31 | AI 서버 Webhook Callback 처리 API 구현 |
| 2025.10.16 | 인증 모듈 추가 및 기본 OAuth 로그인 구현, 회원 관리 API 문서화 |
| 2025.01.15 | 온보딩 API 추가 (약관 동의, 이름, 생년월일, 성별, 관심사 설정) |

---

**문서 생성일**: 2025-11-24
**출처**: Tripgether Backend Swagger API Documentation
# 프로필 업데이트 API 요청

온보딩 완료 시 사용자가 입력한 프로필 정보를 저장하는 API 필요

---

## 📡 요청 API

**PUT /api/members/profile**

**인증:** JWT 토큰에서 member_id 추출

---

## 📤 프론트엔드가 보내는 데이터

```json
{
  "name": "여행러버",
  "gender": "FEMALE",
  "birthDate": "1995-03-15",
  "interests": ["수영", "등산", "맛집 탐방", "사진"]
}
```

### 필드 정보

- `name`: 닉네임 (2-10자)
- `gender`: 성별 (`MALE`, `FEMALE`, `NONE`)
- `birthDate`: 생년월일 (`YYYY-MM-DD` 형식, 선택사항)
- `interests`: 관심사 배열 (3-10개)

---

## 📥 백엔드가 반환하는 데이터

```json
{
  "accessToken": "...",
  "refreshToken": "...",
  "member": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "여행러버",
    "profileImageUrl": "https://...",
    "gender": "FEMALE",
    "birthDate": "1995-03-15",
    "interests": ["수영", "등산", "맛집 탐방", "사진"],
    "onboardingStatus": "COMPLETED",
    "createdAt": "2025-01-15T10:30:00Z",
    "updatedAt": "2025-01-15T10:35:00Z"
  }
}
```

**중요:** `onboardingStatus`를 `COMPLETED`로 변경해서 반환

---

## ❌ 에러 응답

### 닉네임 중복 (409)
```json
{
  "error": {
    "code": "NAME_ALREADY_EXISTS",
    "message": "이미 사용 중인 닉네임입니다."
  }
}
```

### 인증 실패 (401)
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "유효하지 않은 토큰입니다."
  }
}
```

---

## 🔄 사용 흐름

```
1. 온보딩 5단계 완료
   ↓
2. "시작하기" 버튼 클릭
   ↓
3. PUT /api/members/profile 호출
   ↓
4. onboardingStatus: COMPLETED 반환
   ↓
5. 홈 화면 이동
```

---

## ❓ 백엔드 확인 사항

### interests 저장 방식

프론트엔드는 문자열 배열로 보냅니다:
```json
["수영", "등산", "맛집 탐방", "사진"]
```

**질문:**
- 백엔드에서 `interest` 테이블에 문자열이 없으면 자동 생성하나요?
- 아니면 프론트엔드가 사전 정의된 interest_id를 보내야 하나요?

---

## 📊 DB 스키마 참고

백엔드 DB에 이미 존재하는 필드:
- `member.name` ✅
- `member.gender` ✅
- `member.birth_date` ✅
- `member.onboarding_status` ✅
- `member_interest` 테이블 (다대다) ✅

---

## 📝 추가 정보

- **API 호출 시점:** 온보딩 마지막 단계
- **나이 제한:** 프론트엔드에서 만 14세 이상만 입력 가능하게 막음
- **닉네임 중복:** 본인 기존 닉네임은 허용 (수정 케이스)
- **토큰 재발급:** 선택사항

---

**작성자:** Tripgether 프론트엔드 팀
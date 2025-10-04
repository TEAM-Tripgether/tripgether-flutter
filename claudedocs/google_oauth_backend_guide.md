# Google OAuth 백엔드 연동 가이드

Flutter 앱에서 Google 로그인 완료 후 백엔드로 전송되는 데이터와 백엔드 처리 방법을 설명합니다.

## 📦 플러터에서 받는 데이터

### 1. 필수 데이터

#### `idToken` (JWT) ⭐ 가장 중요
```
예시: eyJhbGciOiJSUzI1NiIsImtpZCI6IjE4MmU0M2VlNjUzYjRhMzE4MzgzODY5MzU5MjQ1YzdhYTE3YzFjY2QiLCJ0eXAiOiJKV1QifQ...
```
- **용도**: 백엔드에서 사용자 신원 확인
- **형식**: JWT (JSON Web Token)
- **검증 필요**: 반드시 Google 서버에서 검증해야 함
- **포함 정보**: email, name, picture, sub(Google User ID), iat, exp 등

#### `email`
```
예시: ghd0106@gmail.com
```
- **용도**: 사용자 이메일 주소
- **검증**: idToken 내부 email과 일치 확인

### 2. 선택 데이터

#### `displayName`
```
예시: "엘리페어"
```
- **용도**: 사용자 표시 이름
- **활용**: 프로필, 환영 메시지 등

#### `photoUrl`
```
예시: https://lh3.googleusercontent.com/a/ACg8ocIabcd...
```
- **용도**: 프로필 사진 URL
- **활용**: 아바타 이미지

#### `googleId`
```
예시: "110270891234567890123"
```
- **용도**: Google 고유 사용자 ID
- **활용**: 내부 DB에서 Google 계정 매핑

#### `accessToken` (선택)
```
예시: ya29.a0AfH6SMBabcd...
```
- **용도**: Google API 호출 (Gmail, Drive 등)
- **주의**: idToken과 다름, 별도 scope 필요

#### `serverAuthCode` (선택)
```
예시: 4/0AY0e-g7abc...
```
- **용도**: 서버에서 access token 재발급
- **활용**: 오프라인 액세스, 갱신 토큰

---

## 🔐 백엔드 처리 흐름

### 1단계: ID Token 검증

**왜 필요한가?**
- 플러터에서 보낸 데이터가 진짜 Google에서 발급한 것인지 확인
- 중간에 조작되지 않았는지 확인
- 토큰이 만료되지 않았는지 확인

**검증 방법 (Python FastAPI 예시)**

```python
from google.auth.transport import requests
from google.oauth2 import id_token

async def verify_google_token(token: str) -> dict:
    """Google ID Token을 검증하고 사용자 정보를 반환합니다."""
    try:
        # Google의 공개 키로 JWT 검증
        idinfo = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com"  # .env에서 가져오기
        )

        # 토큰 발급자 확인
        if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError('Wrong issuer.')

        # 검증 성공 - 사용자 정보 반환
        return {
            'google_id': idinfo['sub'],           # Google User ID
            'email': idinfo['email'],              # 이메일
            'email_verified': idinfo.get('email_verified', False),
            'name': idinfo.get('name'),            # 이름
            'picture': idinfo.get('picture'),      # 프로필 사진
        }
    except ValueError as e:
        # 검증 실패
        raise HTTPException(status_code=401, detail=f"Invalid token: {str(e)}")
```

**Node.js 예시**

```javascript
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

async function verifyGoogleToken(token) {
  try {
    const ticket = await client.verifyIdToken({
      idToken: token,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    return {
      googleId: payload['sub'],
      email: payload['email'],
      emailVerified: payload['email_verified'],
      name: payload['name'],
      picture: payload['picture'],
    };
  } catch (error) {
    throw new Error('Invalid token: ' + error.message);
  }
}
```

### 2단계: 사용자 DB 처리

```python
from sqlalchemy.orm import Session
from fastapi import Depends

@router.post("/auth/google/login")
async def google_login(
    request: GoogleLoginRequest,
    db: Session = Depends(get_db)
):
    # 1. ID Token 검증
    user_info = await verify_google_token(request.idToken)

    # 2. DB에서 사용자 찾기 또는 생성
    user = db.query(User).filter(User.email == user_info['email']).first()

    if not user:
        # 신규 사용자 생성
        user = User(
            email=user_info['email'],
            google_id=user_info['google_id'],
            display_name=request.displayName or user_info['name'],
            profile_image_url=request.photoUrl or user_info['picture'],
            provider='google',
            email_verified=user_info['email_verified']
        )
        db.add(user)
        db.commit()
        db.refresh(user)
    else:
        # 기존 사용자 정보 업데이트
        user.display_name = request.displayName or user_info['name']
        user.profile_image_url = request.photoUrl or user_info['picture']
        user.last_login = datetime.utcnow()
        db.commit()

    # 3. JWT 토큰 발급 (앱에서 사용할 인증 토큰)
    access_token = create_access_token(
        data={"sub": str(user.id), "email": user.email}
    )

    # 4. 응답 반환
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "display_name": user.display_name,
            "profile_image_url": user.profile_image_url
        }
    }
```

### 3단계: 응답 데이터

**성공 응답 (200 OK)**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "user": {
    "id": 123,
    "email": "ghd0106@gmail.com",
    "display_name": "엘리페어",
    "profile_image_url": "https://lh3.googleusercontent.com/a/..."
  }
}
```

**실패 응답 (401 Unauthorized)**
```json
{
  "detail": "Invalid token: Token expired"
}
```

---

## 🔑 ID Token 내부 구조

ID Token을 디코딩하면 다음과 같은 정보가 들어있습니다:

```json
{
  "iss": "https://accounts.google.com",
  "azp": "810846342989-bq9tq1261tgurg1tusq9q6ce29omddob.apps.googleusercontent.com",
  "aud": "810846342989-bq9tq1261tgurg1tusq9q6ce29omddob.apps.googleusercontent.com",
  "sub": "110270891234567890123",
  "email": "ghd0106@gmail.com",
  "email_verified": true,
  "name": "엘리페어",
  "picture": "https://lh3.googleusercontent.com/a/...",
  "given_name": "엘리",
  "family_name": "페어",
  "iat": 1234567890,
  "exp": 1234571490
}
```

**주요 필드 설명:**
- `iss`: 토큰 발급자 (Google)
- `sub`: Google User ID (고유 식별자)
- `email`: 사용자 이메일
- `email_verified`: 이메일 인증 여부
- `name`: 전체 이름
- `picture`: 프로필 사진 URL
- `iat`: 발급 시간 (Unix timestamp)
- `exp`: 만료 시간 (Unix timestamp, 보통 1시간 후)

---

## ⚠️ 보안 주의사항

### 1. 절대 하지 말아야 할 것
- ❌ ID Token을 검증 없이 신뢰하지 마세요
- ❌ 플러터에서 보낸 email, displayName만 믿지 마세요 (조작 가능)
- ❌ ID Token을 DB에 저장하지 마세요 (만료되는 임시 토큰)
- ❌ Access Token을 공개적으로 노출하지 마세요

### 2. 반드시 해야 할 것
- ✅ 매번 ID Token을 Google 서버에서 검증
- ✅ 검증된 정보만 DB에 저장
- ✅ 자체 JWT 토큰을 발급하여 앱에서 사용
- ✅ HTTPS만 사용
- ✅ Client ID를 환경변수로 관리

### 3. ID Token vs Access Token

| 항목 | ID Token | Access Token |
|------|----------|--------------|
| 용도 | **사용자 인증** | Google API 호출 |
| 포함 정보 | 사용자 프로필 | 권한 정보 |
| 검증 방법 | JWT 검증 | Google API 요청 시 사용 |
| 만료 시간 | 1시간 | 설정에 따라 다름 |
| 백엔드 필요 | **필수** | 선택 (Google API 사용 시) |

**결론**: 대부분의 경우 **ID Token만 있으면 충분**합니다!

---

## 📚 백엔드 라이브러리

### Python
```bash
pip install google-auth
```

### Node.js
```bash
npm install google-auth-library
```

### Java (Spring Boot)
```xml
<dependency>
    <groupId>com.google.api-client</groupId>
    <artifactId>google-api-client</artifactId>
    <version>2.0.0</version>
</dependency>
```

---

## 🧪 테스트 방법

1. **플러터 앱 실행** → Google 로그인
2. **콘솔에서 idToken 복사**
3. **jwt.io에서 디코딩** → 내용 확인 (검증은 안 됨!)
4. **백엔드 API 테스트**
   ```bash
   curl -X POST http://localhost:8000/auth/google/login \
     -H "Content-Type: application/json" \
     -d '{
       "idToken": "eyJhbGciOiJSUzI1NiIs...",
       "email": "ghd0106@gmail.com",
       "displayName": "엘리페어"
     }'
   ```

---

## 📝 요약

1. **플러터 → 백엔드**: idToken, email, displayName, photoUrl 전송
2. **백엔드**: idToken 검증 (Google 라이브러리 사용)
3. **DB 처리**: 사용자 생성/업데이트
4. **JWT 발급**: 앱에서 사용할 자체 인증 토큰 발급
5. **응답**: access_token + 사용자 정보 반환
6. **플러터**: 토큰 저장 (Secure Storage) + 홈 화면 이동

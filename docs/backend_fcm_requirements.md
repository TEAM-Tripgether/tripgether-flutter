# FCM 푸시 알림 백엔드 구현 요청사항

**프로젝트**: Tripgether
**작성일**: 2025-11-10
**담당**: 백엔드 Spring Boot 개발팀

---

## 📌 핵심 요약 (1분 안에 읽기)

### 🎯 무엇을 만드나요?
푸시 알림 기능을 위한 백엔드 API 및 Firebase 연동이 필요합니다.

### 📱 프론트엔드가 제공하는 것
1. **FCM 토큰**: Firebase가 각 기기에 발급한 고유 토큰 (예: `eY-nz7lFR0...`)
2. **기기 정보**:
   - `device_type`: "IOS" 또는 "ANDROID"
   - `device_name`: "Elipair's iPhone", "Galaxy S23" 등

### 🔑 백엔드가 해야 할 것
1. **Firebase 비공개 키 설정**: 프론트에서 받은 `.json` 파일로 Firebase Admin SDK 초기화
2. **DB 테이블 생성**: 사용자별 FCM 토큰 저장 (`member_fcm_token`)
3. **API 구현**:
   - POST `/api/members/fcm-token` - 토큰 등록/업데이트
   - DELETE `/api/members/fcm-token` - 토큰 삭제
4. **푸시 발송**: Firebase Admin SDK로 알림 전송
   - URL 추출 완료 시: "공유한 컨텐츠 분석이 완료되었습니다."
   - 물품 판매 완료 시: "등록하신 물품이 판매되었습니다."

### 🔄 간단한 흐름
```
1. [앱] 로그인 → FCM 토큰 생성
2. [앱 → 백엔드] POST /api/members/fcm-token (토큰 + 기기정보 전달)
3. [백엔드] DB에 저장
4. [백엔드 이벤트 발생] → DB에서 토큰 조회 → Firebase로 푸시 발송
5. [사용자 기기] 알림 수신 🔔
```

### ⚠️ 중요!
- **멀티 디바이스 지원**: 한 사용자가 iPhone + iPad 사용 시 모두 알림 받음
- **보안**: Firebase 비공개 키는 절대 Git 커밋 금지 (`.gitignore` 필수)

---

## 📋 목차

1. [Firebase Admin SDK 초기화](#-1-firebase-admin-sdk-초기화)
2. [데이터베이스 스키마](#-2-데이터베이스-스키마)
3. [API 엔드포인트](#-3-api-엔드포인트)
4. [푸시 알림 발송](#-4-푸시-알림-발송)
5. [구현 체크리스트](#-5-구현-체크리스트)

---

## 🔧 1. Firebase Admin SDK 초기화

### 1.1 의존성 추가

<details>
<summary><b>Gradle</b></summary>

```gradle
dependencies {
    implementation 'com.google.firebase:firebase-admin:9.2.0'
}
```
</details>

<details>
<summary><b>Maven</b></summary>

```xml
<dependency>
    <groupId>com.google.firebase</groupId>
    <artifactId>firebase-admin</artifactId>
    <version>9.2.0</version>
</dependency>
```
</details>

### 1.2 서비스 계정 키 설정

**파일명**: `tripgether-55abb-firebase-adminsdk-xxxxx.json`

**위치 옵션** (프로젝트 구조에 맞게 선택):
- `src/main/resources/` (권장)
- `config/`
- 환경 변수로 경로 지정: `FIREBASE_SERVICE_ACCOUNT_PATH`

**⚠️ 중요**:
- `.gitignore`에 반드시 추가!
- 프로덕션 환경에서는 환경 변수 사용 권장

### 1.3 초기화 코드

#### 옵션 1: resources 폴더 사용 (간단)
```java
@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void initialize() throws IOException {
        // 파일 위치를 프로젝트 구조에 맞게 수정하세요
        FileInputStream serviceAccount = new FileInputStream(
            "src/main/resources/firebase-service-account.json"
        );

        FirebaseOptions options = new FirebaseOptions.Builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build();

        FirebaseApp.initializeApp(options);

        log.info("✅ Firebase Admin SDK 초기화 완료");
    }
}
```

#### 옵션 2: ClassPath 리소스 사용 (배포 안전)
```java
@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void initialize() throws IOException {
        // ClassPath에서 읽기 (jar 배포 시에도 동작)
        InputStream serviceAccount = getClass()
            .getClassLoader()
            .getResourceAsStream("firebase-service-account.json");

        FirebaseOptions options = new FirebaseOptions.Builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build();

        FirebaseApp.initializeApp(options);

        log.info("✅ Firebase Admin SDK 초기화 완료");
    }
}
```

#### 옵션 3: 환경 변수 사용 (프로덕션 권장)
```java
@Configuration
public class FirebaseConfig {

    @Value("${firebase.service.account.path:src/main/resources/firebase-service-account.json}")
    private String serviceAccountPath;

    @PostConstruct
    public void initialize() throws IOException {
        FileInputStream serviceAccount = new FileInputStream(serviceAccountPath);

        FirebaseOptions options = new FirebaseOptions.Builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build();

        FirebaseApp.initializeApp(options);

        log.info("✅ Firebase Admin SDK 초기화 완료");
    }
}
```

**application.yml 예시**:
```yaml
firebase:
  service:
    account:
      path: ${FIREBASE_SERVICE_ACCOUNT_PATH:src/main/resources/firebase-service-account.json}
```

---

## 🗄️ 2. 데이터베이스 스키마

### 2.1 테이블 생성 SQL

**목적**: 멀티 디바이스 지원 (iPhone + iPad + Android)

```sql
CREATE TABLE public."member_fcm_token" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id UUID NOT NULL REFERENCES public."member"(id) ON DELETE CASCADE,
  fcm_token VARCHAR(255) NOT NULL,
  device_type VARCHAR(20) NOT NULL,
  device_name VARCHAR(100),
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  last_used_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT true,

  CONSTRAINT unique_member_token UNIQUE (member_id, fcm_token)
);

-- 인덱스
CREATE INDEX idx_member_fcm_token_member_id
  ON public."member_fcm_token"(member_id);

CREATE INDEX idx_member_fcm_token_active
  ON public."member_fcm_token"(member_id, is_active)
  WHERE is_active = true;
```

### 2.2 주요 컬럼

| 컬럼 | 설명 | 예시 |
|------|------|------|
| `member_id` | 사용자 ID (FK) | UUID |
| `fcm_token` | FCM 디바이스 토큰 | `eY-nz7lFR0Td...` |
| `device_type` | 디바이스 OS | `IOS`, `ANDROID` |
| `device_name` | 디바이스 이름 | `iPhone 14`, `Galaxy S23` |
| `is_active` | 활성 상태 | 로그아웃 시 `false` |

---

## 🔌 3. API 엔드포인트

### 3.1 FCM 토큰 등록/업데이트

**POST** `/api/members/fcm-token`

#### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

#### Request Body
```json
{
  "fcm_token": "eY-nz7lFR0TdpJiSS8UkQl:APA91b...",  // (필수) FCM 토큰
  "device_type": "IOS",                            // (필수) "IOS" 또는 "ANDROID"
  "device_name": "Elipair's iPhone"                // (필수) 사용자 지정 기기명
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "FCM 토큰이 등록되었습니다"
}
```

#### Response (400 Bad Request)
```json
{
  "success": false,
  "message": "잘못된 FCM 토큰 형식입니다"
}
```

#### Response (401 Unauthorized)
```json
{
  "success": false,
  "message": "인증이 필요합니다"
}
```

#### 처리 로직
1. JWT에서 `member_id` 추출
2. DB 조회: 같은 `member_id` + `fcm_token` 존재?
   - **YES**: `last_used_at` 업데이트, `is_active = true`
   - **NO**: 새 레코드 INSERT

---

### 3.2 FCM 토큰 삭제 (로그아웃)

**DELETE** `/api/members/fcm-token`

#### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

#### Request Body
```json
{
  "fcm_token": "eY-nz7lFR0TdpJiSS8UkQl:APA91b..."  // (필수) 삭제할 FCM 토큰
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "FCM 토큰이 삭제되었습니다"
}
```

#### Response (404 Not Found)
```json
{
  "success": false,
  "message": "해당 FCM 토큰을 찾을 수 없습니다"
}
```

#### 처리 로직
1. Request Body에서 `fcm_token` 추출
2. JWT에서 `member_id` 추출
3. DB에서 해당 사용자의 토큰 조회
4. `is_active = false` 설정 (soft delete, 히스토리 유지)
5. 토큰이 없으면 404 반환

---

## 📨 4. 푸시 알림 발송

### 4.1 공통 발송 메서드

```java
public void sendPushToAllDevices(
    UUID memberId,
    String title,
    String body,
    Map<String, String> data
) {
    // 1. 활성 토큰 조회
    List<MemberFcmToken> tokens = fcmTokenRepository
        .findByMemberIdAndIsActiveTrue(memberId);

    // 2. 각 토큰에 대해 푸시 발송
    for (MemberFcmToken token : tokens) {
        Message message = Message.builder()
            .setNotification(Notification.builder()
                .setTitle(title)
                .setBody(body)
                .build())
            .putAllData(data)
            .setToken(token.getFcmToken())
            .setApnsConfig(ApnsConfig.builder()  // iOS 설정
                .setAps(Aps.builder()
                    .setSound("default")
                    .setBadge(1)
                    .build())
                .build())
            .build();

        try {
            FirebaseMessaging.getInstance().send(message);
            // 성공 시 last_used_at 업데이트
            token.setLastUsedAt(LocalDateTime.now());
        } catch (FirebaseMessagingException e) {
            // 토큰 만료 시 비활성화
            if (e.getMessagingErrorCode() == MessagingErrorCode.UNREGISTERED) {
                token.setIsActive(false);
            }
        }
        fcmTokenRepository.save(token);
    }
}
```

### 4.2 URL 추출 완료 알림

```java
public void sendUrlExtractionNotification(
    UUID memberId,
    String contentTitle,
    String contentId
) {
    Map<String, String> data = Map.of(
        "type", "url_extraction",
        "content_id", contentId
    );

    sendPushToAllDevices(
        memberId,
        "콘텐츠가 추가되었어요! 🎉",
        contentTitle + " 정보를 확인해보세요",
        data
    );
}
```

**호출 시점**: URL 메타데이터 추출 완료 시

---

### 4.3 물품 판매 완료 알림

```java
public void sendItemSoldNotification(
    UUID sellerId,
    String itemName,
    String itemId
) {
    Map<String, String> data = Map.of(
        "type", "item_sold",
        "item_id", itemId
    );

    sendPushToAllDevices(
        sellerId,
        "물품이 판매되었어요! 💰",
        itemName + "이(가) 판매되었습니다",
        data
    );
}
```

**호출 시점**: 코스마켓 물품 판매 완료 시

---

### 4.4 여행 초대 알림 (향후)

```java
public void sendTripInvitationNotification(
    UUID inviteeId,
    String inviterName,
    String tripName,
    String tripId
) {
    Map<String, String> data = Map.of(
        "type", "trip_invitation",
        "trip_id", tripId,
        "inviter_name", inviterName
    );

    sendPushToAllDevices(
        inviteeId,
        "여행에 초대되었어요! ✈️",
        inviterName + "님이 " + tripName + "에 초대했습니다",
        data
    );
}
```

---

## ✅ 5. 구현 체크리스트

### Phase 1: 환경 설정
- [ ] Firebase Admin SDK 의존성 추가
- [ ] 서비스 계정 키 JSON 파일 추가
- [ ] `.gitignore`에 JSON 파일 경로 추가
- [ ] `FirebaseConfig` 초기화 코드 작성

### Phase 2: 데이터베이스
- [ ] `member_fcm_token` 테이블 생성
- [ ] 인덱스 생성
- [ ] JPA Entity 클래스 작성
- [ ] Repository 인터페이스 작성

### Phase 3: API 구현
- [ ] POST `/api/members/fcm-token` 구현
- [ ] DELETE `/api/members/fcm-token` 구현
- [ ] Postman 테스트

### Phase 4: 푸시 발송
- [ ] `PushNotificationService` 클래스 작성
- [ ] `sendPushToAllDevices()` 공통 메서드
- [ ] `sendUrlExtractionNotification()` 구현
- [ ] `sendItemSoldNotification()` 구현
- [ ] 토큰 에러 처리 (만료, 유효하지 않음)

### Phase 5: 이벤트 연동
- [ ] URL 추출 완료 이벤트 → 푸시 발송
- [ ] 물품 판매 이벤트 → 푸시 발송

### Phase 6: 테스트
- [ ] 단일 디바이스 푸시 테스트
- [ ] 멀티 디바이스 푸시 테스트 (iPhone + iPad)
- [ ] 토큰 만료 시나리오 테스트
- [ ] 로그아웃 시 토큰 비활성화 테스트

---

## 📊 데이터 흐름도

### 토큰 등록 흐름
```
[Flutter 앱]
    ↓ 로그인 성공
FirebaseMessaging.getToken()
    ↓ FCM 토큰 생성
POST /api/members/fcm-token
    ↓
[Spring Boot 백엔드]
    ↓ JWT에서 member_id 추출
DB 조회: 같은 토큰 존재?
    ├─ YES → last_used_at 업데이트
    └─ NO → INSERT 새 레코드
    ↓
Response 200 OK
```

### 푸시 발송 흐름
```
[백엔드 이벤트] (예: URL 추출 완료)
    ↓
sendUrlExtractionNotification(memberId, title)
    ↓
DB 조회: member_id의 활성 토큰들
    ↓
[token_1, token_2, token_3]
    ↓
각 토큰에 대해 Firebase Admin SDK 호출
    ↓
FirebaseMessaging.send(message)
    ↓
[Firebase 서버] → [APNs/FCM] → [사용자 디바이스]
    ↓
알림 표시 🔔
```

---

## 🚀 우선순위

### 1차 배포 (필수)
1. Firebase Admin SDK 초기화
2. `member_fcm_token` 테이블 및 API
3. URL 추출 완료 푸시 알림

### 2차 배포
1. 물품 판매 푸시 알림
2. 배치 작업 (90일 미사용 토큰 정리)

### 향후 확장
1. 여행 초대 푸시 알림
2. 푸시 알림 설정 관리

---

## 📞 참고 자료

- [Firebase Admin SDK (Java)](https://firebase.google.com/docs/admin/setup?hl=ko)
- [FCM 서버 구현 가이드](https://firebase.google.com/docs/cloud-messaging/server?hl=ko)
- [Firebase Admin SDK 샘플 (GitHub)](https://github.com/firebase/firebase-admin-java)

---

## 📝 전달 파일

**Firebase 서비스 계정 키**:
- 파일명: `tripgether-55abb-firebase-adminsdk-xxxxx.json`
- 전달 방법: Slack DM
- Project ID: `tripgether-55abb`

⚠️ **보안 주의**: 절대 Git에 커밋하지 말 것!

---

**작성자**: Claude (AI Assistant)
**검토**: [백엔드 개발자명]

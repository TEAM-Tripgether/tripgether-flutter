#!/bin/bash

# ═══════════════════════════════════════════════════════════
# .env 파일을 읽어서 Android local.properties에 주입하는 스크립트
# CI/CD 환경에서는 GitHub Secrets를 사용하므로 .env 파일이 없어도 OK
# ═══════════════════════════════════════════════════════════

set -e

# 스크립트 디렉토리 기준으로 .env 파일 경로 설정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../../.env"
OUTPUT_FILE="$SCRIPT_DIR/../local.properties"

# .env 파일이 존재하는지 확인
if [ ! -f "$ENV_FILE" ]; then
    # CI/CD 환경 확인 (GitHub Actions, CircleCI 등)
    if [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ] || [ -n "$CIRCLECI" ]; then
        echo "ℹ️  CI/CD 환경 감지: .env 파일 없이 진행 (환경 변수 사용)"
        # CI/CD에서는 환경 변수에서 직접 읽음
        GOOGLE_WEB_CLIENT_ID="${GOOGLE_WEB_CLIENT_ID:-}"
    else
        echo "❌ Error: .env file not found at $ENV_FILE"
        echo "   로컬 개발 환경에서는 .env 파일이 필요합니다."
        exit 1
    fi
else
    echo "✅ Loading environment variables from .env..."
    # .env 파일에서 환경 변수 읽기
    GOOGLE_WEB_CLIENT_ID=$(grep -E "^GOOGLE_WEB_CLIENT_ID=" "$ENV_FILE" | cut -d '=' -f2)
    GOOGLE_MAPS_API_KEY=$(grep -E "^GOOGLE_MAP_ANDROID_MAPS_API_KEY=" "$ENV_FILE" | cut -d '=' -f2)
fi

# GOOGLE_WEB_CLIENT_ID 값 확인
if [ -z "$GOOGLE_WEB_CLIENT_ID" ]; then
    if [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ] || [ -n "$CIRCLECI" ]; then
        echo "⚠️  Warning: GOOGLE_WEB_CLIENT_ID not found (CI/CD 환경)"
        echo "   GitHub Secrets에 GOOGLE_WEB_CLIENT_ID가 설정되어 있는지 확인하세요."
        # CI/CD에서는 경고만 출력하고 계속 진행 (기존 워크플로우가 다른 방식으로 처리할 수 있음)
    else
        echo "❌ Error: GOOGLE_WEB_CLIENT_ID not found in .env"
        exit 1
    fi
fi

echo "🌐 GOOGLE_WEB_CLIENT_ID: ${GOOGLE_WEB_CLIENT_ID:0:30}..."
echo "🗺️  GOOGLE_MAPS_API_KEY: ${GOOGLE_MAPS_API_KEY:0:20}..."

# local.properties에 기존 내용 유지하면서 환경 변수 추가
# 먼저 기존 local.properties의 sdk.dir 라인만 유지
if [ -f "$OUTPUT_FILE" ]; then
    SDK_DIR=$(grep -E "^sdk.dir=" "$OUTPUT_FILE" 2>/dev/null || echo "")
else
    SDK_DIR=""
fi

# 새로운 local.properties 생성
{
    if [ -n "$SDK_DIR" ]; then
        echo "$SDK_DIR"
    fi
    echo ""
    echo "# ═══════════════════════════════════════════════════════════"
    echo "# Google OAuth 환경 변수 (빌드 시 .env에서 자동 주입)"
    echo "# ═══════════════════════════════════════════════════════════"
    echo "GOOGLE_WEB_CLIENT_ID=$GOOGLE_WEB_CLIENT_ID"
    echo ""
    echo "# ═══════════════════════════════════════════════════════════"
    echo "# Google Maps API 키 (AndroidManifest.xml에서 사용)"
    echo "# ═══════════════════════════════════════════════════════════"
    echo "GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY"
} > "$OUTPUT_FILE"

echo "✅ Environment setup completed!"
echo "📁 Output: $OUTPUT_FILE"

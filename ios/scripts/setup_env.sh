#!/bin/bash

# ═══════════════════════════════════════════════════════════
# .env 파일을 읽어서 Xcode 빌드 환경 변수로 설정하는 스크립트
# CI/CD 환경에서는 GitHub Secrets를 사용하므로 .env 파일이 없어도 OK
# ═══════════════════════════════════════════════════════════

set -e

# 스크립트 디렉토리 기준으로 .env 파일 경로 설정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../../.env"

# .env 파일이 존재하는지 확인
if [ ! -f "$ENV_FILE" ]; then
    # CI/CD 환경 확인 (GitHub Actions, Xcode Cloud 등)
    if [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ] || [ -n "$XCODE_CLOUD" ]; then
        echo "ℹ️  CI/CD 환경 감지: .env 파일 없이 진행 (환경 변수 사용)"
        # CI/CD에서는 환경 변수에서 직접 읽음
        GOOGLE_IOS_CLIENT_ID="${GOOGLE_IOS_CLIENT_ID:-}"
    else
        echo "❌ Error: .env file not found at $ENV_FILE"
        echo "   로컬 개발 환경에서는 .env 파일이 필요합니다."
        exit 1
    fi
else
    echo "✅ Loading environment variables from .env..."
    # .env 파일에서 GOOGLE_IOS_CLIENT_ID 읽기
    GOOGLE_IOS_CLIENT_ID=$(grep -E "^GOOGLE_IOS_CLIENT_ID=" "$ENV_FILE" | cut -d '=' -f2)
fi

# GOOGLE_IOS_CLIENT_ID 값 확인
if [ -z "$GOOGLE_IOS_CLIENT_ID" ]; then
    if [ -n "$CI" ] || [ -n "$GITHUB_ACTIONS" ] || [ -n "$XCODE_CLOUD" ]; then
        echo "⚠️  Warning: GOOGLE_IOS_CLIENT_ID not found (CI/CD 환경)"
        echo "   GitHub Secrets에 GOOGLE_IOS_CLIENT_ID가 설정되어 있는지 확인하세요."
        # CI/CD에서는 경고만 출력하고 계속 진행 (기존 워크플로우가 다른 방식으로 처리할 수 있음)
    else
        echo "❌ Error: GOOGLE_IOS_CLIENT_ID not found in .env"
        exit 1
    fi
fi

echo "📱 GOOGLE_IOS_CLIENT_ID: ${GOOGLE_IOS_CLIENT_ID:0:30}..."

# Client ID를 역순으로 변환하여 URL Scheme 생성
# 예: 693963095425-jsjls...apps.googleusercontent.com
# → com.googleusercontent.apps.693963095425-jsjls...
GOOGLE_URL_SCHEME=$(echo "$GOOGLE_IOS_CLIENT_ID" | sed -E 's/^([0-9]+-[a-z0-9]+)\.apps\.googleusercontent\.com$/com.googleusercontent.apps.\1/')

echo "🔗 GOOGLE_URL_SCHEME: $GOOGLE_URL_SCHEME"

# Xcode 환경 변수로 export (Info.plist에서 $(GOOGLE_URL_SCHEME)으로 사용)
OUTPUT_FILE="$SCRIPT_DIR/../Flutter/GoogleEnv.xcconfig"
echo "GOOGLE_URL_SCHEME=$GOOGLE_URL_SCHEME" > "$OUTPUT_FILE"

echo "✅ Environment setup completed!"
echo "📁 Output: $OUTPUT_FILE"

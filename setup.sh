#!/bin/bash
# setup.sh - 새 기기에서 블로그 개발 환경 설정
#
# 사용법: git clone 후 프로젝트 루트에서 실행
#   ./setup.sh

set -e

ICLOUD_CONTENT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/BlogContent"

echo "=== 블로그 개발 환경 설정 ==="
echo ""

# iCloud 콘텐츠 디렉토리 확인
if [ ! -d "$ICLOUD_CONTENT/posts" ]; then
  echo "Error: iCloud BlogContent/posts 디렉토리가 없습니다."
  echo "iCloud Drive에서 BlogContent 폴더가 동기화되었는지 확인하세요."
  echo ""
  echo "필요하다면 다음 명령으로 강제 다운로드할 수 있습니다:"
  echo "  brctl download '$ICLOUD_CONTENT'"
  exit 1
fi

if [ ! -d "$ICLOUD_CONTENT/images" ]; then
  echo "Error: iCloud BlogContent/images 디렉토리가 없습니다."
  exit 1
fi

# 기존 디렉토리/심링크 정리
rm -rf src/data/blog
rm -rf src/assets/images/blog

# 부모 디렉토리 확인
mkdir -p src/data
mkdir -p src/assets/images

# 심링크 생성
ln -s "$ICLOUD_CONTENT/posts" src/data/blog
ln -s "$ICLOUD_CONTENT/images" src/assets/images/blog

echo "심링크 생성 완료:"
ls -la src/data/blog
ls -la src/assets/images/blog
echo ""

# Git 설정: skip-worktree로 심링크 경로의 콘텐츠 파일 보호
# (git이 디렉토리 심링크를 통해 파일을 직접 추적할 수 없으므로,
#  인덱스에 이미 있는 파일을 skip-worktree로 표시하여 "deleted" 경고를 방지)
echo "Git skip-worktree 설정 중..."
git ls-files src/data/blog/ src/assets/images/blog/ | while IFS= read -r f; do
  git update-index --skip-worktree "$f"
done

# 심링크 자체를 로컬 gitignore에 추가
EXCLUDE_FILE=".git/info/exclude"
if ! grep -q "src/data/blog" "$EXCLUDE_FILE" 2>/dev/null; then
  echo "" >> "$EXCLUDE_FILE"
  echo "# Symlinks to iCloud content (local development only)" >> "$EXCLUDE_FILE"
  echo "src/data/blog" >> "$EXCLUDE_FILE"
  echo "src/assets/images/blog" >> "$EXCLUDE_FILE"
fi

echo "Git 설정 완료"
echo ""

# 의존성 설치
echo "의존성 설치 중..."
bun install
echo ""

echo "=== 설정 완료! ==="
echo "'bun run dev'로 개발 서버를 실행하세요."

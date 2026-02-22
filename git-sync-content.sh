#!/bin/bash
# git-sync-content.sh - iCloud 심링크를 통한 콘텐츠 파일의 git 동기화
#
# git add/commit은 디렉토리 심링크를 통해 파일을 직접 추가할 수 없습니다.
# 이 스크립트는 git update-index를 사용하여 심링크를 통해 콘텐츠 파일을
# git 인덱스에 동기화합니다.
#
# 사용법:
#   ./git-sync-content.sh          # 변경된 콘텐츠를 git 인덱스에 스테이징
#   git commit -m "Update posts"   # 이후 일반적으로 커밋

set -e

CONTENT_DIRS=("src/data/blog" "src/assets/images/blog")

echo "=== 콘텐츠 파일 git 동기화 ==="

# 1. 현재 인덱스에 있는 콘텐츠 파일들의 skip-worktree 해제
echo "skip-worktree 해제 중..."
for dir in "${CONTENT_DIRS[@]}"; do
  git ls-files "$dir/" | while IFS= read -r f; do
    git update-index --no-skip-worktree "$f" 2>/dev/null || true
  done
done

# 2. 심링크를 통해 파일 내용을 git 인덱스에 업데이트
echo "콘텐츠 파일 인덱싱 중..."
UPDATED=0
ADDED=0
DELETED=0

for dir in "${CONTENT_DIRS[@]}"; do
  if [ ! -L "$dir" ]; then
    echo "Warning: $dir 은 심링크가 아닙니다. 건너뜁니다."
    continue
  fi

  # 현재 심링크 대상 디렉토리의 파일들을 인덱스에 추가/업데이트
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    filepath="$f"
    hash=$(git hash-object -w "$filepath")
    old_hash=$(git ls-files -s "$filepath" 2>/dev/null | awk '{print $2}')

    if [ -z "$old_hash" ]; then
      # 새 파일
      if [[ "$filepath" == *.md ]]; then
        git update-index --add --cacheinfo "100644,$hash,$filepath"
      else
        git update-index --add --cacheinfo "100644,$hash,$filepath"
      fi
      echo "  + $filepath (새 파일)"
      ADDED=$((ADDED + 1))
    elif [ "$hash" != "$old_hash" ]; then
      # 수정된 파일
      git update-index --cacheinfo "100644,$hash,$filepath"
      echo "  ~ $filepath (수정됨)"
      UPDATED=$((UPDATED + 1))
    fi
  done

  # 인덱스에는 있지만 심링크 대상에는 없는 파일 감지 (삭제된 파일)
  git ls-files "$dir/" | while IFS= read -r tracked; do
    if [ ! -f "$tracked" ]; then
      git update-index --force-remove "$tracked"
      echo "  - $tracked (삭제됨)"
      DELETED=$((DELETED + 1))
    fi
  done
done

# 3. skip-worktree 다시 설정
echo "skip-worktree 재설정 중..."
for dir in "${CONTENT_DIRS[@]}"; do
  git ls-files "$dir/" | while IFS= read -r f; do
    git update-index --skip-worktree "$f"
  done
done

echo ""
echo "동기화 완료: 추가 $ADDED, 수정 $UPDATED, 삭제 $DELETED"
echo ""

# 스테이징 상태 표시
STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
if [ "$STAGED" -gt 0 ]; then
  echo "스테이징된 변경사항:"
  git diff --cached --name-status
  echo ""
  echo "'git commit -m \"메시지\"'로 커밋하세요."
else
  echo "변경된 콘텐츠가 없습니다."
fi

# SeongwonChung's log

Seongwon Chung의 개인 기술 블로그입니다.

## 아키텍처

프로젝트(소스 코드, 설정, 의존성)는 **로컬 디스크**에, 블로그 콘텐츠(글, 이미지)는 **iCloud**에 분리하여 관리합니다.

```
~/Developer/Blog/                          ← 로컬 (git 추적)
├── src/
│   ├── data/
│   │   └── blog → (심링크) iCloud BlogContent/posts/
│   ├── assets/images/
│   │   └── blog → (심링크) iCloud BlogContent/images/
│   └── ...
└── ...

~/Library/Mobile Documents/com~apple~CloudDocs/BlogContent/  ← iCloud 동기화
├── posts/          ← 마크다운 파일
└── images/         ← 이미지 파일
```

iCloud에 있는 콘텐츠는 iPad/iPhone의 마크다운 에디터(iA Writer, Obsidian 등)로 편집 가능합니다.

## 새 기기 설정

```bash
git clone https://github.com/SeongwonChung/blog.git ~/Developer/Blog
cd ~/Developer/Blog
./setup.sh
bun run dev
```

`setup.sh`는 iCloud `BlogContent` 폴더로의 심링크 생성, git 설정, 의존성 설치를 자동으로 처리합니다.

## 글 작성

### 새 글 Frontmatter 템플릿

```markdown
---
title: ""
pubDatetime: 2026-01-01T00:00:00.000Z
description: ""
tags: []
category: uncategorized
draft: true
---
```

iCloud `BlogContent/posts/`에 마크다운 파일을 생성하면 됩니다.

### 콘텐츠 변경사항 커밋

git은 디렉토리 심링크를 통해 파일을 직접 추적할 수 없으므로, 콘텐츠 변경사항을 커밋할 때는 헬퍼 스크립트를 사용합니다:

```bash
./git-sync-content.sh   # iCloud 콘텐츠를 git 인덱스에 동기화
git commit -m "Add new post"
git push
```

# 스폰지클럽 스킬 — spongebot

폰 텔레그램으로 내 PC의 Claude Code를 조작하게 끝까지 연결하고,
**설정이 완료되면 바탕화면에 아이콘 버튼을 자동 생성**하는 대화형 설치 도우미.

## 설치법 (초보자용 — 둘 중 하나)

### 🟢 방법 A. 가장 쉬움 — 터미널에 한 줄 붙여넣기
터미널(맥: 응용프로그램 > 유틸리티 > 터미널)을 열고 아래 한 줄을 붙여넣고 엔터:
```
claude plugin marketplace add may070822/spongeclub-skills && claude plugin install spongebot@spongeclub-skills && echo "✅ 설치완료! Claude Code에서 /spongebot-setup 입력하세요"
```
그다음 Claude Code 를 열고 한 번만 입력:
```
/spongebot-setup
```

### 🟢 방법 B. 더블클릭 설치
이 레포의 **`스폰지봇-설치.command`** 파일을 내려받아 더블클릭 → 설치 후 Claude Code가 열려요.
거기서 `/spongebot-setup` 한 번만 입력. (첫 실행 시 보안경고가 뜨면 우클릭 → 열기 → 열기.)

> 그 뒤는 스킬이 봇 만들기·연결·**바탕화면 버튼 생성**까지 한 단계씩 안내해요.

## 무엇을 해주나
1. 지금 어디까지 됐는지 진단 → **덜 됐으면 그 단계부터 이어서** 안내, **다 됐으면 바로 버튼만** 생성
2. 봇 만들기(BotFather)·Bun·플러그인·토큰·페어링·보안잠금까지 한 단계씩
3. **설정 완료가 확인되면** 바탕화면에 `<원하는 이름>.command` 버튼 생성 (스폰지 아이콘)
   - 원하면 **자기 이미지로 커스텀 아이콘**도 가능 (정사각형 권장)
4. 평소엔 그 버튼만 더블클릭 → 폰에서 Claude 사용

## 구성
- `telegram@claude-plugins-official` (Anthropic 공식, 실제 송수신) 위에 얹은 가이드 + 런처 생성기
- macOS 전용(.command + 아이콘). 봇 토큰·페어링은 **보안상 본인이 직접** 입력.

## 주의
- 런처 기본값은 `--dangerously-skip-permissions`(폰 명령 무확인 실행) → 본인 PC 전용.
  안전모드는 런처에서 그 플래그만 빼면 민감작업 시 폰으로 🔐Allow/Deny 버튼(CC v2.1.81+).

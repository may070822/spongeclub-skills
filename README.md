# 스폰지클럽 스킬 — spongebot

폰 텔레그램으로 내 PC의 Claude Code를 조작하게 끝까지 연결하고,
**설정이 완료되면 바탕화면에 아이콘 버튼을 자동 생성**하는 대화형 설치 도우미.

## 멤버 설치법 (Claude Code 입력창에 한 줄씩)

```
/plugin marketplace add <github-아이디>/spongeclub-skills
```
```
/plugin install spongebot@spongeclub-skills
```
```
/reload-plugins
```

그다음 실행:
```
/spongebot-setup
```

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

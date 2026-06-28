#!/bin/zsh
# 스폰지봇 한방 설치 — 더블클릭하면 마켓플레이스 추가 + 플러그인 설치까지 끝.
# 끝나면 Claude Code 가 열리고, 거기서 /spongebot-setup 한 번만 치면 됩니다.
clear
echo "🧽 스폰지봇 설치를 시작합니다..."
echo ""

# claude 경로 자동탐지 (v2.1.80+)
ver_ge() {  # "2.1.156 ..." >= 2.1.80 ?
  local v="${1%% *}" mj mn pt
  mj="${v%%.*}"; v="${v#*.}"; mn="${v%%.*}"; pt="${v#*.}"; pt="${pt%%[^0-9]*}"
  [[ -z "$mj$mn$pt" ]] && return 1
  (( mj>2 )) && return 0; (( mj<2 )) && return 1
  (( mn>1 )) && return 0; (( mn<1 )) && return 1
  (( pt>=80 ))
}
CLAUDE=""
for c in "$(command -v claude 2>/dev/null)" "$HOME/.npm-global/bin/claude" "$HOME/.claude/local/claude" /opt/homebrew/bin/claude /usr/local/bin/claude; do
  [[ -n "$c" && -x "$c" ]] || continue
  v="$("$c" --version 2>/dev/null | head -1)"; [[ -n "$v" ]] || continue
  ver_ge "$v" && { CLAUDE="$c"; break; }
done
if [[ -z "$CLAUDE" ]]; then
  echo "❌ Claude Code(v2.1.80+) 를 못 찾았어요. 먼저 Claude Code를 설치/업데이트해 주세요."
  echo "   (설치: https://claude.com/claude-code )"
  echo ""; read "?엔터를 누르면 닫혀요..."; exit 1
fi
echo "✓ claude 발견: $CLAUDE"
echo ""

echo "① 스폰지클럽 마켓플레이스 추가..."
"$CLAUDE" plugin marketplace add may070822/spongeclub-skills || { echo "마켓플레이스 추가 실패(인터넷 확인)"; read "?엔터..."; exit 1; }
echo ""
echo "② 스폰지봇 플러그인 설치..."
"$CLAUDE" plugin install spongebot@spongeclub-skills || { echo "플러그인 설치 실패"; read "?엔터..."; exit 1; }
echo ""
echo "✅ 설치 완료!"
echo ""
echo "잠시 후 Claude Code 가 열리고 설치가 자동으로 시작돼요."
echo "화면의 질문에 답만 하시면 봇 연결부터 바탕화면 버튼까지 끝나요. 🧽"
echo ""
read "?준비되면 엔터를 누르세요..."
cd "$HOME"
# 인터랙티브 Claude를 초기 프롬프트와 함께 실행 → spongebot-setup 스킬 자동 시작
exec "$CLAUDE" "spongebot-setup 스킬을 실행해서 텔레그램 봇 연결을 처음부터 끝까지 안내해줘. 마지막에 바탕화면 아이콘 버튼 생성까지 진행해줘."

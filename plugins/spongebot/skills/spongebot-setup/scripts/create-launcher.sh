#!/bin/zsh
# 스폰지봇 런처 생성기.
#   1) 텔레그램 연동 설정이 "완료"됐는지 먼저 검증한다 (토큰·플러그인·페어링).
#   2) 완료된 경우에만 바탕화면에 "<이름>.command" 버튼을 만들고 스폰지 아이콘을 입힌다.
# 사용법: create-launcher.sh "봇이름" ["커스텀아이콘.png"]
#   - 이름 생략 시 "스폰지봇"
#   - 2번째 인자로 이미지(png/jpg)를 주면 그 이미지를 아이콘으로 사용(없으면 기본 스폰지)
#   FORCE=1 create-launcher.sh "이름"       (검증 실패해도 강제 생성 — 비권장)
set -e

NAME="${1:-스폰지봇}"
CUSTOM_ICON="${2:-}"
SCRIPT_DIR="${0:A:h}"
ICON_SRC="$SCRIPT_DIR/../assets/sponge_icon_1024.png"
# 커스텀 아이콘이 주어지고 존재하면 그걸로 교체
if [[ -n "$CUSTOM_ICON" && -f "$CUSTOM_ICON" ]]; then
  ICON_SRC="$CUSTOM_ICON"
fi
LAUNCHER="$HOME/Desktop/${NAME}.command"
CH="$HOME/.claude/channels/telegram"

# ── 1) 설정 완료 검증 ─────────────────────────────────────────────
missing=()
# (a) 봇 토큰
if [[ ! -f "$CH/.env" ]] || ! grep -q "^TELEGRAM_BOT_TOKEN=" "$CH/.env" 2>/dev/null; then
  missing+=("봇 토큰 미등록 → /telegram:configure <토큰>")
fi
# (b) 공식 플러그인
if ! grep -q "telegram@claude-plugins-official" "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
  missing+=("텔레그램 플러그인 미설치 → /plugin install telegram@claude-plugins-official 후 /reload-plugins")
fi
# (c) 폰 페어링 (allowFrom 에 ID가 1개 이상). JSON이 여러 줄이라 평탄화 후 매칭.
ACCESS_FLAT=""
[[ -f "$CH/access.json" ]] && ACCESS_FLAT="$(tr -d '\n\r' < "$CH/access.json" 2>/dev/null)"
if ! echo "$ACCESS_FLAT" | grep -qE '"allowFrom"[[:space:]]*:[[:space:]]*\[[[:space:]]*"'; then
  missing+=("폰 페어링 안 됨 → 받는 창 켠 뒤 봇에 메시지 → /telegram:access pair <코드>")
fi

if (( ${#missing[@]} > 0 )) && [[ "${FORCE:-0}" != "1" ]]; then
  echo "⛔ 아직 설정이 끝나지 않아 바탕화면 버튼을 만들지 않았어요. 남은 단계:" >&2
  for m in "${missing[@]}"; do echo "   • $m" >&2; done
  echo "   (다 끝낸 뒤 이 스킬을 다시 실행하면 버튼이 생성돼요.)" >&2
  exit 2
fi

# (선택) 보안 잠금 권고
if ! grep -q '"dmPolicy"[[:space:]]*:[[:space:]]*"allowlist"' "$CH/access.json" 2>/dev/null; then
  echo "⚠️  권고: 아직 allowlist 잠금 전이에요. /telegram:access policy allowlist 로 잠그면 더 안전해요."
fi

# ── 2) --channels 지원 claude 경로 자동탐지 (버전 v2.1.80+) ─────────
ver_ge_2_1_80() {
  local v="${1%% *}" mj mn pt
  mj="${v%%.*}"; v="${v#*.}"; mn="${v%%.*}"; pt="${v#*.}"; pt="${pt%%[^0-9]*}"
  [[ -z "$mj" || -z "$mn" || -z "$pt" ]] && return 1
  (( mj > 2 )) && return 0; (( mj < 2 )) && return 1
  (( mn > 1 )) && return 0; (( mn < 1 )) && return 1
  (( pt >= 80 ))
}
CLAUDE=""
find_claude() {
  local cands=(
    "$(command -v claude 2>/dev/null)"
    "$HOME/.npm-global/bin/claude" "$HOME/.claude/local/claude"
    "/opt/homebrew/bin/claude" "/usr/local/bin/claude"
  )
  local c v
  for c in $cands; do
    [[ -n "$c" && -x "$c" ]] || continue
    v="$("$c" --version 2>/dev/null | head -1)"; [[ -n "$v" ]] || continue
    ver_ge_2_1_80 "$v" || continue
    CLAUDE="$c"; return 0
  done
  return 1
}
find_claude || { echo "❌ --channels 지원 claude(v2.1.80+) 를 못 찾음. Claude Code 업데이트 필요." >&2; exit 1; }

# ── 3) 런처(.command) 작성 ────────────────────────────────────────
cat > "$LAUNCHER" <<EOF
#!/bin/zsh
# ${NAME} — 텔레그램 받는 창. 더블클릭하면 폰↔Claude 연결이 켜집니다.
# 이 창을 닫으면 연결이 끊겨요. 폰에서 봇 쓰는 동안은 열어두세요.
export PATH="\$HOME/.npm-global/bin:/opt/homebrew/bin:/usr/local/bin:\$PATH"
cd "\$HOME"
clear
echo "📞 ${NAME} 받는 창을 켭니다... (이 창을 닫으면 연결이 끊겨요)"
echo ""
exec "$CLAUDE" --channels plugin:telegram@claude-plugins-official --dangerously-skip-permissions
EOF
chmod +x "$LAUNCHER"

# ── 4) 스폰지 아이콘 입히기 ───────────────────────────────────────
if [[ -f "$ICON_SRC" ]]; then
  TMP="$(mktemp -d)"; cp "$ICON_SRC" "$TMP/icon.png"
  sips -i "$TMP/icon.png" >/dev/null 2>&1 || true
  DeRez -only icns "$TMP/icon.png" > "$TMP/icon.rsrc" 2>/dev/null || true
  if [[ -s "$TMP/icon.rsrc" ]]; then
    Rez -append "$TMP/icon.rsrc" -o "$LAUNCHER" 2>/dev/null || true
    SetFile -a C "$LAUNCHER" 2>/dev/null || true
  fi
  rm -rf "$TMP"
fi
touch "$LAUNCHER"; killall Finder 2>/dev/null || true

echo "✅ 완료! 바탕화면 '${NAME}' 버튼을 더블클릭하면 켜져요."
echo "   (첫 실행만 우클릭 → 열기 → 열기 / claude=$CLAUDE)"

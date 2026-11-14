#!/bin/bash
# CLAUDE.md とスキルのバッククォート内のパスが実在するかを確かめる。パスは動かした瞬間に腐り、腐った指示はエージェントを嘘の場所へ送る。
# 散文の言い換えまでは追わない(誤検知で門が鳴りっぱなしになると誰も見なくなる)。
cd "$(dirname "$0")/.." || exit 1

# 実在しなくてよい参照。理由の無い項目を足さないこと
EXEMPT='
'

missing=0
while IFS= read -r line; do
  file=${line%%:*} ref=${line#*:}
  # コマンド(空白を含む)、<雛形>、URL は対象外
  case "$ref" in *" "*|*"<"*|*://*) continue ;; esac
  grep -q "^${ref}|" <<<"$EXEMPT" && continue
  if [[ "$ref" == */* ]]; then
    [ -e "$ref" ] && continue
  elif [[ "$ref" =~ \.(yml|yaml|md|swift|sh|json|plist)$ ]]; then
    # ファイル名だけの参照(`BrushingView.swift` など)は、リポジトリのどこかにあればよい。
    # 拡張子で絞るのは、`.task` や `@AppStorage` のようなコードの名前をパスとして拾わないため
    [ -n "$(find . -name "$ref" -not -path './.git/*' -print -quit)" ] && continue
  else
    continue
  fi
  echo "✖ $file の参照先がありません: $ref" >&2
  missing=1
done < <(grep -oE '`[^`]+`' CLAUDE.md .claude/skills/*/SKILL.md | tr -d '`' | sort -u)

[ "$missing" -eq 0 ] && echo "✓ CLAUDE.md とスキルの参照はすべて実在します"
exit "$missing"

#!/bin/bash
# CLAUDE.md のバッククォート内のパスが実在するかを確かめる。パスは動かした瞬間に腐り、腐った指示はエージェントを嘘の場所へ送る。
# 散文の言い換えまでは追わない(誤検知で門が鳴りっぱなしになると誰も見なくなる)。
cd "$(dirname "$0")/.." || exit 1

# 実在しなくてよい参照。理由の無い項目を足さないこと
EXEMPT='
'

missing=0
while IFS= read -r ref; do
  # コマンド(空白を含む)、<雛形>、URL は対象外
  case "$ref" in *" "*|*"<"*|*://*) continue ;; esac
  # / を含むか、ファイルの拡張子で終わるものだけをパスとみなす(`.task` や `@AppStorage` のようなコードの名前を拾わないため)
  [[ "$ref" == */* || "$ref" =~ \.(yml|yaml|md|swift|sh|json|plist)$ ]] || continue
  grep -q "^${ref}|" <<<"$EXEMPT" && continue
  [ -e "$ref" ] && continue
  echo "✖ CLAUDE.md の参照先がありません: $ref" >&2
  missing=1
done < <(grep -oE '`[^`]+`' CLAUDE.md | tr -d '`' | sort -u)

[ "$missing" -eq 0 ] && echo "✓ CLAUDE.md の参照はすべて実在します"
exit "$missing"

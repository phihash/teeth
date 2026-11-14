#!/bin/bash
# Claude Code の PostToolUse フック(Bash)。Swift のファイルを含むコミットができた直後に、
# その差分を design-system スキルに照らして見直すよう一言差し込む。
# 決まりは書いてあるだけでは差分に当てられないので、当てる工程をコミットのたびに呼び出す。
# 編集のたびに言うと読み飛ばされるので、言うのはコミットごと。
# 判定できないとき(JSON が読めない、git が失敗した)は黙る。迷ったら言わないほうへ倒す
payload=$(cat)

[ "$(jq -r '.tool_name // empty' <<<"$payload" 2>/dev/null)" = "Bash" ] || exit 0
command=$(jq -r '.tool_input.command // empty' <<<"$payload")
[[ "$command" =~ git[^\|\;\&]*commit ]] || exit 0
[[ "$command" =~ --(amend|fixup|squash) ]] && exit 0

# 新しいコミットができると git は「[ブランチ ハッシュ] 件名」を出す。版によって tool_response は文字列のことも、stdout を持つオブジェクトのこともある
stdout=$(jq -r '.tool_response | if type == "object" then (.stdout // "") else (. // "" | tostring) end' <<<"$payload")
hash=$(grep -oE '^\[[^]]+ [0-9a-f]{7,40}\]' <<<"$stdout" | head -1 | grep -oE '[0-9a-f]{7,40}\]$' | tr -d ']')
[ -n "$hash" ] || exit 0

# フック経由だと GIT_DIR が渡ることがあり、cwd より優先される。外さないと別のリポジトリを見る
files=$(env -u GIT_DIR -u GIT_WORK_TREE git -C "${CLAUDE_PROJECT_DIR:-.}" show --name-only --format= "$hash" 2>/dev/null) || exit 0
grep -qE '^teeth/.+\.swift$' <<<"$files" || exit 0

jq -n '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: "このコミットは画面のコード(Swift)を含んでいます。.claude/skills/design-system/SKILL.md を読み、この差分が決まり(背景色・文字の色と大きさ・角丸・画面の作り)を破っていないかを確かめてください。破っている箇所があれば決まりの文を引用して報告し、次のコミットで直してください。なければ「なし」と報告してください。"}}'

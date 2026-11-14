#!/bin/bash
# DesignSystem/ で定義した名前(色・文字・角丸)が、どこかで使われているかを確かめる。
# 使わなくなった値が残ると、新しく画面を作るときに「今ある名前」として選ばれ、意図しない色や大きさが広がるため。
# lint にしないのは、SwiftLint の custom_rules はファイルを1つずつ見るだけで、ほかのファイルでの使われ方を数えられないため
cd "$(dirname "$0")/.." || exit 1

# コメントを除いたコードだけを数える(コメントに名前が出てくるだけでは、使われていることにしない)
code=$(find teeth -name '*.swift' -exec sed -e 's://.*$::' {} +)

unused=0
check() {
  local name=$1 pattern=$2
  # 定義している行そのものは数えない
  if ! grep -vE "static (let|func) $name\b" <<<"$code" | grep -qE "$pattern"; then
    echo "✖ 使われていない: $name" >&2
    unused=1
  fi
}

# private の定義はファイルの中だけで使う部品なので数えない
for name in $(grep -hE '^\s*static (let|func) ' teeth/DesignSystem/Colors.swift teeth/DesignSystem/Typography.swift | grep -oE 'static (let|func) [A-Za-z]+' | awk '{print $3}'); do
  check "$name" "\.$name\b"
done
# 角丸は s・m など短い名前なので、Radius. を付けた形だけを数える
for name in $(grep -hoE 'static let [A-Za-z]+' teeth/DesignSystem/Radius.swift | awk '{print $3}'); do
  check "$name" "Radius\.$name\b"
done

if [ "$unused" -eq 0 ]; then
  echo "✓ DesignSystem の名前はすべて使われています"
else
  echo "  使わなくなった名前は DesignSystem/ から消す" >&2
fi
exit "$unused"

# teeth — 歯みがきアプリ(SwiftUI)

## ルールの置き場所

| 決まりの種類 | 置き場所 | どう効くか |
|---|---|---|
| 機械で判定できる(デザインの値の直書きなど) | `.swiftlint.yml` | ビルド中と push 前に止まる。文章には書かない |
| 機械で判定できるが、ファイルをまたいで数える(使われていない値) | `scripts/audit-unused-tokens.sh` | push 前に止まる |
| 判断が要る見た目の決まり | `.claude/skills/design-system/SKILL.md` | UIを触るときに読む。コミット後にフックが見直させる |
| 触る前に知っておくべきこと | このファイル | 毎回読まれる。長くしない |

新しい決まりは、上の行から順に当てはまるかを考えて置き場所を決める。

## 構成

| パス | 役割 |
|---|---|
| `teeth/` | 画面と記録のモデル(SwiftData の `BrushRecord`)。同期フォルダなので、ファイルを足しても pbxproj の編集は要らない |
| `teeth/DesignSystem/` | 色・文字・角丸・画面の共通の見た目。値はここにだけ書く |
| `.claude/skills/design-system/` | 見た目の決まり(どの場面でどの名前を使うか) |
| `.claude/settings.json`、`scripts/` | Claude のフック(コミット後にスキルで見直させる) |
| `.githooks/` | push 前の検査(使われていない値の検査 → ビルド。ビルドの最初の段階で SwiftLint も走る) |

## レイヤー構造

層は分けていない。画面(View)が SwiftData(`@Query`、`modelContext`)と `@AppStorage` を直接読み書きし、見た目は `DesignSystem/` の名前を使う。画面の外に出すのは、複数の画面で使う見た目(`DesignSystem/`)とデータのモデル(`BrushRecord`)だけ。ロジックが複数の画面で要るようになるまでは、ViewModel などの層を作らない。

## 注意点

- 歯みがきの記録は、最後まで磨いたときだけ保存される。途中で戻ると `.task` がキャンセルされ、保存の行まで来ない(`BrushingView`)。
- `@AppStorage` のキー(`careful`、`reminderOn`、`reminderTime`)は、名前を変えると保存済みの設定が読めなくなる。`careful` はコース選択と設定の両方の画面で使っているので、変えるなら両方を合わせる。
- `BrushRecord` に項目を足すときは既定値を付ける。付けないと、既存の記録を読み込めなくなるおそれがある。
- 歯の並びは右端から時計回りで、左上・右上・右下・左下の先頭は 14・21・0・7(`BrushingView` の `firstTooth`)。本数や並びを変えるときは、ここも合わせる。
- 書体はヒラギノ丸ゴの W4 だけで、日本語には太字も斜体も効かない。
- 通知の許可を拒否されると、設定のスイッチが自動でオフに戻る。許可し直すのは iOS の設定アプリから。

## 作業

- UIを作る・変えるときは、先に `.claude/skills/design-system/SKILL.md` を読む。
- ビルド: `xcodebuild -project teeth.xcodeproj -scheme teeth -destination 'generic/platform=iOS Simulator' build`
- SwiftLint は `brew install swiftlint` で入れる。clone し直したら `git config core.hooksPath .githooks` を1回実行する。

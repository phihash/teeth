import SwiftUI

// 文字はすべてヒラギノ丸ゴ。.rounded にしないのは、丸くなるのが英数字だけで日本語は角ゴのままになるため。
// iOS に入っている丸ゴは W4 の1種類だけなので、太さと斜体は指定しない(指定しても日本語には効かない)。
// relativeTo を付けて、端末の文字サイズ設定に合わせて大きさが変わるようにする
extension Font {
    private static func maru(_ size: CGFloat, relativeTo style: TextStyle) -> Font {
        custom("HiraMaruProN-W4", size: size, relativeTo: style)
    }

    /// 歯みがき中のカウントダウン
    static let display = maru(64, relativeTo: .largeTitle)
    /// コース名(• ミント •)
    static let brand = maru(34, relativeTo: .largeTitle)
    /// ホームの今日の一言
    static let hero = maru(28, relativeTo: .title)
    /// push 先の画面のタイトル
    static let screenTitle = maru(26, relativeTo: .title)
    /// ホームのツールバーのアイコン。SF Symbols は丸ゴでは太さが選べないので system のまま
    static let toolbarIcon = system(size: 28, weight: .medium)
    /// 大きめの見出し・ボタンの文字
    static let heading = maru(22, relativeTo: .title2)
    /// 節の見出し・設定の項目名・説明文
    static let section = maru(20, relativeTo: .title3)
    static let bodyText = maru(17, relativeTo: .body)
    /// 記録カードのバッジ
    static let badge = maru(15, relativeTo: .subheadline)
    /// 記録カードの日時
    static let note = maru(13, relativeTo: .footnote)

    /// 絵文字をイラストとして使うときの大きさ。文字ではないので役割の名前は付けない
    static func emoji(_ size: CGFloat) -> Font { system(size: size) }
}

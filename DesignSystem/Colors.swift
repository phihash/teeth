import SwiftUI

extension Color {
    static let cream = Color(red: 0.99, green: 0.97, blue: 0.93)
    static let sand = Color(red: 0.93, green: 0.90, blue: 0.85)
    static let sky = Color(red: 0.73, green: 0.82, blue: 0.86)
    static let slate = Color(red: 0.21, green: 0.31, blue: 0.37)
    static let ink = Color(red: 0.12, green: 0.16, blue: 0.20)
    static let mist = Color(white: 0.94)
    /// 歯みがき中の画面の背景
    static let grape = Color(red: 0.36, green: 0.24, blue: 0.43)

    /// 案内や空のときの文言など、主役でない文字
    static let slateMuted = slate.opacity(0.7)
    /// 色の付いた背景の上に置く、半透明の白い面(丸ボタン・記録カード)
    static let glass = Color.white.opacity(0.3)
}

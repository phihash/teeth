import CoreGraphics

// 角丸は4段とシート用だけ。内側の角丸は外側より小さくして、入れ子の角が平行に見えるようにする(m の中に s)
enum Radius {
    static let xs: CGFloat = 6
    static let s: CGFloat = 10
    static let m: CGFloat = 14
    static let l: CGFloat = 20
    static let sheet: CGFloat = 40
}

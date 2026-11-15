import SwiftUI

struct Illustration: View {
    let size: CGFloat

    var body: some View {
        Text("🦷")
            .font(.emoji(size))
            .overlay(alignment: .topTrailing) {
                Text("🌿").font(.emoji(size * 0.45)).offset(x: size * 0.25, y: -size * 0.15)
            }
            .frame(width: size * 1.6, height: size * 1.6)
    }
}

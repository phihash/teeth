import SwiftUI

extension View {
    /// push 先の画面共通: 背景色・手書き風タイトル・タイトルなしの戻るボタン
    func screen(_ title: String, background: Color) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background)
            .toolbarRole(.editor)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.screenTitle)
                        .foregroundStyle(Color.ink)
                }
            }
    }
}

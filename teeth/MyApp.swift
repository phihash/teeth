import SwiftData
import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // フォントを指定していない文字(既定の本文、DatePicker の項目名など)も丸ゴにそろえる
                .font(.bodyText)
        }
        .modelContainer(for: BrushRecord.self)
    }
}

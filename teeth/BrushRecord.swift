import Foundation
import SwiftData

// 最後まで磨ききったときだけ自動で保存される
@Model
final class BrushRecord {
    var date: Date
    var seconds: Int

    init(date: Date = .now, seconds: Int) {
        self.date = date
        self.seconds = seconds
    }
}

import SwiftData
import SwiftUI

struct BrushingView: View {
    let secondsPerArea: Int
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var area = 0
    @State private var remaining = 0
    @State private var step = 0

    private let areas = ["左上", "右上", "右下", "左下"]
    private let toothCount = 28
    private let brushWidth = 3  // 一度に磨く歯の本数
    private var steps: Int { toothCount / 4 - brushWidth + 1 }
    private var done: Bool { area >= areas.count }
    // 今磨く歯の先頭インデックス。歯は右端から時計回りに並ぶので、左上=14, 右上=21, 右下=0, 左下=7 から始まる
    private var firstTooth: Int { [14, 21, 0, 7][area] + step }

    var body: some View {
        ZStack {
            Color.grape.ignoresSafeArea()
            VStack {
                HStack {
                    CircleButton(systemName: "chevron.left") { dismiss() }
                    Spacer()
                }
                VStack(spacing: 8) {
                    Text(done ? "ピカピカ！" : areas[area]).font(.heading)
                    Text(done ? "🎉" : "\(remaining)")
                        .font(.display)
                        .monospacedDigit()
                }
                .foregroundStyle(.white)
                .padding(.top, 24)

                mouth
            }
            .padding(.horizontal, 24)
        }
        .animation(.easeInOut, value: firstTooth)
        .task {
            for i in areas.indices {
                area = i
                for s in stride(from: secondsPerArea, to: 0, by: -1) {
                    remaining = s
                    step = (secondsPerArea - s) * steps / secondsPerArea
                    guard (try? await Task.sleep(for: .seconds(1))) != nil else { return }
                }
            }
            area = areas.count
            // 途中で戻るとタスクがキャンセルされてここまで来ないので、記録されない
            context.insert(BrushRecord(seconds: secondsPerArea * areas.count))
        }
    }

    private var mouth: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let rx = geo.size.width / 2 - 50
            let ry = geo.size.height / 2 - 30
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color.mouthGlow, .clear], center: .center, startRadius: 0, endRadius: 110))
                    .frame(width: 220, height: 220)
                    .position(c)
                Text("🦷").font(.emoji(80)).position(c)

                ForEach(0..<toothCount, id: \.self) { i in
                    let a = angle(i)
                    let size = 34 + 20 * abs(cos(a))
                    Circle()
                        .fill(!done && (firstTooth..<firstTooth + brushWidth).contains(i) ? Color.toothBrushing : Color.toothIdle)
                        .frame(width: size, height: size)
                        .position(x: c.x + rx * cos(a), y: c.y + ry * sin(a))
                }

                if !done {
                    let a = angle(firstTooth + brushWidth / 2)
                    Text("🪥")
                        .font(.emoji(44))
                        .position(x: c.x + (rx + 50) * cos(a), y: c.y + (ry + 30) * sin(a))
                }
            }
        }
    }

    private func angle(_ i: Int) -> Double {
        (Double(i) + 0.5) / Double(toothCount) * 2 * .pi
    }
}

private struct CircleButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.heading)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.glass, in: .circle)
        }
    }
}

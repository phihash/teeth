import SwiftData
import SwiftUI

struct CourseSheet: View {
    @AppStorage("careful") private var careful = false
    @State private var brushing = false

    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 4) {
                Text("• ミント •").font(.brand)
                Illustration(size: 90)
            }

            Text("寝ぼけた歯もゆっくりピカピカに。\nやさしいリズムでみがこう。")
                .font(.section)
                .multilineTextAlignment(.center)

            HStack(spacing: 0) {
                ModeOption(title: "ふつう", subtitle: "2分", isOn: !careful) { careful = false }
                ModeOption(title: "より丁寧に", subtitle: "3分", isOn: careful) { careful = true }
            }
            .padding(6)
            .background(Color.sand, in: .rect(cornerRadius: Radius.m))

            Spacer()

            Button {
                brushing = true
            } label: {
                Text("スタート →")
                    .font(.heading)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(.black, in: .capsule)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 32)
        .padding(.bottom, 12)
        .fullScreenCover(isPresented: $brushing) {
            BrushingView(secondsPerArea: careful ? 45 : 30)
        }
        .presentationDetents([.fraction(0.75)])
        .presentationBackground(Color.cream)
        .presentationCornerRadius(Radius.sheet)
    }
}

struct ModeOption: View {
    let title: String
    let subtitle: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(title).font(.section)
                Text(subtitle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isOn ? Color.cream : .clear, in: .rect(cornerRadius: Radius.s))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CourseSheet()
        .modelContainer(for: BrushRecord.self, inMemory: true)
}

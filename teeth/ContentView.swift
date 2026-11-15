import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    @Query private var records: [BrushRecord]
    private var brushedToday: Bool { records.contains { Calendar.current.isDateInToday($0.date) } }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink { SettingsView() } label: { Label("設定", systemImage: "line.3.horizontal") }
                    Spacer()
                    NavigationLink { RecordsView() } label: { Label("記録", systemImage: "calendar") }
                }
                .labelStyle(.iconOnly)
                .font(.toolbarIcon)
                .foregroundStyle(Color.slate)

                Spacer()

                Text(brushedToday ? "ピカピカでごきげん！" : "歯がムズムズしてるみたい…")
                    .font(.hero)
                    .foregroundStyle(Color.ink)

                Button { showSheet = true } label: {
                    Illustration(size: 160)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 40)

                Text("タップしてみがこう")
                    .font(.heading)
                    .foregroundStyle(Color.slateMuted)

                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.sky)
            .sheet(isPresented: $showSheet) { CourseSheet() }
        }
        .tint(.slate)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: BrushRecord.self, inMemory: true)
}

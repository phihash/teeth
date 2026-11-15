import SwiftData
import SwiftUI

struct RecordsView: View {
    @Query(sort: \BrushRecord.date, order: .reverse) private var records: [BrushRecord]
    private var todayCount: Int { records.filter { Calendar.current.isDateInToday($0.date) }.count }

    var body: some View {
        ScrollView {
            Text("今日 \(todayCount)回 · ぜんぶで \(records.count)回")
                .font(.section)
                .foregroundStyle(Color.slate)
                .padding(.vertical, 8)

            if records.isEmpty {
                Text("最後まで磨くと\nここに記録がたまっていくよ")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.slateMuted)
                    .padding(.top, 80)
            }

            LazyVGrid(columns: [GridItem(spacing: 20), GridItem()], spacing: 20) {
                ForEach(records) { RecordCard(record: $0) }
            }
            .padding(.horizontal, 24)
        }
        .screen("わたしの記録 ✨", background: .sky)
    }
}

private struct RecordCard: View {
    let record: BrushRecord

    var body: some View {
        VStack(spacing: 20) {
            Text(record.seconds >= 180 ? "丁寧" : "ふつう")
                .font(.badge)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.sky, in: .rect(cornerRadius: Radius.xs))
            Text("🦷").font(.emoji(56))
            Text(record.date.formatted(.dateTime.month().day().hour().minute()))
                .font(.note)
        }
        .foregroundStyle(Color.slate)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.glass, in: .rect(cornerRadius: Radius.l))
    }
}

#Preview {
    NavigationStack { RecordsView() }
        .modelContainer(for: BrushRecord.self, inMemory: true)
}

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("careful") private var careful = false
    @AppStorage("reminderOn") private var reminderOn = false
    @AppStorage("reminderTime") private var reminderTime = Calendar.current.date(from: DateComponents(hour: 21))!.timeIntervalSinceReferenceDate

    private var time: Binding<Date> {
        Binding(get: { Date(timeIntervalSinceReferenceDate: reminderTime) },
                set: { reminderTime = $0.timeIntervalSinceReferenceDate })
    }

    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 12) {
                Text("みがく時間").font(.section)
                HStack(spacing: 0) {
                    ModeOption(title: "ふつう", subtitle: "2分", isOn: !careful) { careful = false }
                    ModeOption(title: "より丁寧に", subtitle: "3分", isOn: careful) { careful = true }
                }
                .padding(6)
                .background(Color.sand, in: .rect(cornerRadius: Radius.m))
            }

            VStack(spacing: 12) {
                Toggle("毎日お知らせ", isOn: $reminderOn)
                    .font(.section)
                if reminderOn {
                    DatePicker("時刻", selection: time, displayedComponents: .hourAndMinute)
                        .font(.bodyText)
                }
            }

            Text("V: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                .font(.bodyText)
        }
        .foregroundStyle(Color.ink)
        .tint(.slate)
        .padding(.horizontal, 40)
        .animation(.default, value: reminderOn)
        .screen("設定", background: .mist)
        .onChange(of: reminderOn) { Task { await schedule() } }
        .onChange(of: reminderTime) { Task { await schedule() } }
    }

    private func schedule() async {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        guard reminderOn else { return }
        // 拒否されていたらスイッチを戻す（許可は iOS の設定アプリから）
        guard (try? await center.requestAuthorization(options: [.alert, .sound])) == true else {
            reminderOn = false
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "歯みがきの時間だよ 🦷"
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time.wrappedValue), repeats: true)
        try? await center.add(UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger))
    }
}

#Preview {
    NavigationStack { SettingsView() }
}

//
// Created by Rob on 13/5/21.
// Created using Paul Hudson's video on enabling & scheduling notifications: https://www.youtube.com/watch?v=ERy8RnYUKjI
//

import SwiftUI
import UserNotifications

struct EnableNotificationsButton: View {
    var body: some View {
        Button(action: {
            AppAnalytics.event(.tapEnableNotificationsButton)
            UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if (success) {
                            print("User authorized notifications. Scheduling now.")
                            scheduleNotification(timeOfDay: .am)
                            scheduleNotification(timeOfDay: .pm)
                            print("Scheduled reminder notifications.")
                        } else if let e = error {
                            print(e.localizedDescription)
                        } else {
                            print("Notification authorization request failed in a less common way.")
                        }
                    }
        }, label: {
            HStack {
                Text("Enable notifications")
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .padding(10)
                Image(systemName: "bell.fill")
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
            }
        })
                .background(Color.blue)
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 4, y: 4)
    }

    private func scheduleNotification(timeOfDay: TimeOfDay) {
        let timeOfDayString = timeOfDay == .am ? "morning" : "evening"
        let notificationIdentifier = "skin-recording-reminder--\(timeOfDayString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        let content = UNMutableNotificationContent()
        content.title = "Tap here to make this \(timeOfDayString)'s recording."
        content.subtitle = ""
        content.sound = UNNotificationSound.default
        var date = DateComponents()
        date.hour = timeOfDay == .am ? 7 : 22
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}


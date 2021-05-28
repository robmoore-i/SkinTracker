//
// Created by Rob on 17/5/21.
// Created using Paul Hudson's video on enabling & scheduling notifications: https://www.youtube.com/watch?v=ERy8RnYUKjI
//

import UserNotifications

struct ReminderNotificationScheduler {
    func scheduleReminders() {
        UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if (success) {
                        print("User authorized notifications. Scheduling now.")
                        scheduleReminderNotification(timeOfDay: .am)
                        scheduleReminderNotification(timeOfDay: .pm)
                        print("Scheduled reminder notifications.")
                    } else if let e = error {
                        print(e.localizedDescription)
                    } else {
                        print("Notification authorization request failed in a less common way.")
                    }
                }
    }

    func removeReminders() {
        print("Removing all notifications")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func scheduleReminderNotification(timeOfDay: TimeOfDay) {
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

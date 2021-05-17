//
// Created by Rob on 17/5/21.
//

import SwiftUI

struct NotificationConfigurationButtonRow: View {
    @Environment(\.presentationMode) var presentation
    private let reminderNotificationScheduler = ReminderNotificationScheduler()

    var body: some View {
        HStack {
            Button(action: {
                AppAnalytics.event(.tapEnableNotificationsModalButton)
                reminderNotificationScheduler.scheduleReminders()
                presentation.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Text("Enable")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                            .padding([.leading, .top, .bottom], 10)
                    Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                }
            })
                    .background(Color.blue)
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            Button(action: {
                AppAnalytics.event(.tapDisableNotificationsModalButton)
                reminderNotificationScheduler.removeReminders()
                presentation.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Text("Disable")
                            .font(.subheadline)
                            .foregroundColor(Color.red)
                            .padding([.leading, .top, .bottom], 10)
                    Image(systemName: "bell.slash.fill")
                            .foregroundColor(.red)
                            .padding(.trailing, 10)
                }
            })
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            Button(action: {
                AppAnalytics.event(TrackedEvent.tapCancelNotificationsModalButton)
                presentation.wrappedValue.dismiss()
            }, label: {
                Text("Dismiss")
                        .font(.subheadline)
                        .foregroundColor(Color.blue)
                        .padding(10)
            })
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
        }
    }
}


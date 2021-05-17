//
// Created by Rob on 13/5/21.
// Created using Paul Hudson's video on creating a full screen modal: https://www.youtube.com/watch?v=SdIWZzl9h-w
//

import SwiftUI

struct EnableNotificationsModal: View {
    @Environment(\.presentationMode) var presentation
    private let reminderNotificationScheduler = ReminderNotificationScheduler()

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("You've made your").font(.largeTitle)
                Text("first recording! 🎉").font(.largeTitle)
            }.padding()
            Text("Would you like to get a notification in the morning (7am) and evening (10pm) to make recordings?")
                    .multilineTextAlignment(.center).padding()
            HStack {
                Button(action: {
                    AppAnalytics.event(.tapEnableNotificationsModalButton)
                    reminderNotificationScheduler.scheduleReminders()
                    presentation.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text("Enable notifications")
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
                        .padding()
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
            Spacer()
        }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
    }
}

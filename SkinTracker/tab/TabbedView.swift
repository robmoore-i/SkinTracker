//
// Created by Rob on 2/5/21.
//

import SwiftUI

private var tabCounter: Int = 1

private func nextTab() -> Int {
    tabCounter += 1
    return tabCounter - 1
}

struct TabbedView<Content: View>: View {
    let tabName: String
    let tabIconSfImageName: String

    @ViewBuilder let content: () -> Content

    @State private var showFeedbackModal = false
    @State private var showNotificationsModal = false

    var body: some View {
        VStack(spacing: 0) {
            TabHeader(text: tabName,
                    showFeedbackModal: $showFeedbackModal,
                    showNotificationsModal: $showNotificationsModal)
            content()
        }
                .sheet(isPresented: $showFeedbackModal, onDismiss: {
                    UsageAnalytics.event(.dismissFeedbackModal)
                }, content: FeedbackModal.init)
                .sheet(isPresented: $showNotificationsModal, onDismiss: {
                    UsageAnalytics.event(TrackedEvent.dismissNotificationsModal)
                }, content: {
                    VStack {
                        VStack(spacing: 0) {
                            Text("Reminder Notifications").font(.largeTitle)
                        }.padding()
                        VStack(spacing: 0) {
                            let font: Font = .headline
                            Text("Reminder notifications are sent daily").font(font)
                            Text("in the morning (7am) and evening (10pm).").font(font)
                            Text("Would you like them?").font(font)
                        }.padding()
                        Text("This app sends no other notifications.").foregroundColor(.gray).padding(.bottom)
                        NotificationConfigurationButtonRow(buttons: [.enable, .disable, .dismiss])
                        Spacer()
                    }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                }).tag(nextTab()).tabItem {
                    Label(tabName, systemImage: tabIconSfImageName)
                }
    }
}
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
    let tabIconSubtitle: String
    let tabIconSfImageName: String
    let tabHeader: String

    @ViewBuilder let content: () -> Content

    @State private var showFeedbackModal = false
    @State private var showNotificationsModal = false

    var body: some View {
        VStack(spacing: 0) {
            TabHeader(text: tabHeader,
                    showFeedbackModal: $showFeedbackModal,
                    showNotificationsModal: $showNotificationsModal)
            content()
        }
                .sheet(isPresented: $showFeedbackModal, onDismiss: {
                    AppAnalytics.event(.dismissFeedbackModal)
                }, content: FeedbackModal.init)
                .sheet(isPresented: $showNotificationsModal, onDismiss: {
                    AppAnalytics.event(TrackedEvent.dismissNotificationsModal)
                }, content: {
                    NotificationsModal {
                        VStack(spacing: 0) {
                            Text("Reminder Notifications").font(.largeTitle)
                        }.padding()
                        VStack(spacing: 0) {
                            let font: Font = .headline
                            Text("Reminders are sent daily in the").font(font)
                            Text("morning (7am) and evening (10pm).").font(font)
                            Text("Would you like them?").font(font)
                        }.padding()
                        Text("This app sends no other notifications.").foregroundColor(.gray)
                    }
                }).tag(nextTab()).tabItem {
                    Label(tabIconSubtitle, systemImage: tabIconSfImageName)
                }
    }
}
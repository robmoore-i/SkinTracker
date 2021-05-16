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
    @Binding var showFeedbackModal: Bool

    @ViewBuilder let content: Content

    var body: some View {
        content.tag(nextTab()).tabItem {
            Label(tabIconSubtitle, systemImage: tabIconSfImageName)
        }.sheet(isPresented: $showFeedbackModal, onDismiss: {
            AppAnalytics.event(.dismissFeedbackModal)
        }) {
            FeedbackModal()
        }
    }
}
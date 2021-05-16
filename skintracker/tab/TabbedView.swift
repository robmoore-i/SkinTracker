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

    var body: some View {
        VStack(spacing: 0) {
            TabHeader(text: tabHeader, showFeedbackModal: $showFeedbackModal)
            content()
        }.sheet(isPresented: $showFeedbackModal, onDismiss: {
            AppAnalytics.event(.dismissFeedbackModal)
        }) {
            FeedbackModal()
        }.tag(nextTab()).tabItem {
            Label(tabIconSubtitle, systemImage: tabIconSfImageName)
        }
    }
}
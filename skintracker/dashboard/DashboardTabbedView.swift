//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct DashboardTabbedView: View {
    let recordingStorage: RecordingStorage
    @Binding var selectedTab: Int

    @State private var showFeedbackModal = false

    var body: some View {
        TabbedView(tabIconSubtitle: "Dashboard", tabIconSfImageName: "chart.bar.xaxis", showFeedbackModal: $showFeedbackModal) {
            VStack(spacing: 0) {
                TabHeader(text: "Visualize", showFeedbackModal: $showFeedbackModal)
                AllTimeProgressDataView(recordingStorage: recordingStorage, selectedTab: $selectedTab).padding()
                YourRecordingsListHeader(recordingStorage: recordingStorage)
                YourRecordingsListView(recordingStorage: recordingStorage, selectedTab: $selectedTab)
            }
        }
    }
}

struct FeedbackModal: View {
    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack {
            Text("hey")
        }
    }
}
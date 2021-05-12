//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct DashboardTabbedView: View {
    let recordingStorage: RecordingStorage
    @Binding var selectedTab: Int

    let emojis = ["🙏", "👊", "🙌", "👏", "👑", "🌞", "⭐️", "☀️", "🌈"]

    var body: some View {
        TabbedView("Track progress", "chart.bar.xaxis") {
            VStack(spacing: 0) {
                TabHeader("SkinTracker \(emojis.randomElement()!)")
                AllTimeProgressDataView(recordingStorage: recordingStorage, selectedTab: $selectedTab).padding()
                YourRecordingsListHeader(recordingStorage: recordingStorage)
                YourRecordingsListView(recordingStorage: recordingStorage, selectedTab: $selectedTab)
            }
        }
    }
}
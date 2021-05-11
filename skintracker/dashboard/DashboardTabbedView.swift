//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct DashboardTabbedView: View {
    private let recordingStorage: RecordingStorage

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView("Dashboard", "chart.bar.xaxis") {
            VStack(spacing: 0) {
                TabHeader("You're getting there 🙏")
                AllTimeProgressDataView(recordingStorage: recordingStorage).padding()
                YourRecordingsListHeader(recordingStorage: recordingStorage)
                YourRecordingsListView(recordingStorage: recordingStorage)
            }
        }
    }
}
//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct DashboardTabbedView: View {
    @ObservedObject var recordingStorage: RecordingStorage
    let photoStorage: PhotoStorage
    @Binding var selectedTab: Int

    init(_ recordingStorage: RecordingStorage, _ photoStorage: PhotoStorage, _ selectedTab: Binding<Int>) {
        self.recordingStorage = recordingStorage
        self.photoStorage = photoStorage
        self._selectedTab = selectedTab
    }

    var body: some View {
        TabbedView(tabName: "Dashboard", tabIconSfImageName: "newspaper") {
            DashboardDataVisualizationView(recordingStorage: recordingStorage, selectedTab: $selectedTab).padding()
            YourRecordingsListHeader(recordingStorage: recordingStorage)
            YourRecordingsList(recordingStorage: recordingStorage, photoStorage: photoStorage)
        }
    }
}

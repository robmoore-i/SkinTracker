//
// Created by Rob on 10/5/21.
//

import SwiftUI

struct DashboardDataVisualizationView: View {
    @ObservedObject var recordingStorage: RecordingStorage
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            if (recordingStorage.all.isEmpty) {
                UserActivationDemoView(selectedTab: $selectedTab)
            } else {
                LastTwoWeeksProgressView(recordingStorage: recordingStorage)
            }
            Spacer()
        }
    }
}
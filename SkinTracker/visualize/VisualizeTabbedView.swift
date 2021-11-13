//
// Created by Rob on 20/6/21.
//

import SwiftUI

struct VisualizeTabbedView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView(tabName: "Visualize", tabIconSfImageName: "chart.bar.xaxis") {
            if ((!recordingStorage.all.isEmpty) && (recordingStorage.all.totalSpotCount() > 0)) {
                AllTimeProgressView(recordingStorage: recordingStorage).padding()
                MostAffectedRegionsView(recordingStorage: recordingStorage).padding()
            }
        }
    }
}
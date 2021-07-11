//
// Created by Rob on 20/6/21.
//

import SwiftUI

struct VisualizeTabbedView: View {
    private let recordingStorage: RecordingStorage

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView(tabName: "Visualize", tabIconSfImageName: "chart.bar.xaxis") {
            if (!recordingStorage.all.isEmpty) {
                AllTimeProgressView(recordingStorage: recordingStorage).padding()
                MostAffectedRegionsView(recordingStorage: recordingStorage).padding()
            }
        }
    }
}
//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct VisualizeTabbedView: View {
    private let recordingStorage: RecordingStorage

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView("Visualize", "chart.bar.xaxis") {
            VStack(spacing: 0) {
                TabHeader("You're getting there 🙏")
                HStack {
                    Text("Recordings").font(.title).padding()
                    ExportRecordingsButton(recordingStorage: recordingStorage)
                    Spacer()
                }
                RecordingsListView(recordingStorage: recordingStorage)
            }
        }
    }
}

private struct ExportRecordingsButton: View {
    var recordingStorage: RecordingStorage

    var body: some View {
        Button(action: {
            print("--- Exporting all recordings to JSON ---")
            print(recordingStorage.allAsJson())
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                        .scaleEffect(1.5, anchor: .center)
                        .accentColor(Color.blue)
            }
        }
    }
}
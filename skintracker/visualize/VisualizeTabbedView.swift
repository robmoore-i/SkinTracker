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
                HStack {
                    Text("You're getting there 🙏")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    Spacer()
                }.padding()
                Divider()
                RecordingsListView(recordingStorage)
            }
        }
    }
}

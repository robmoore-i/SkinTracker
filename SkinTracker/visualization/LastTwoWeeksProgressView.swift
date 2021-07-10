//
// Created by Rob on 10/7/21.
//

import SwiftUI

struct LastTwoWeeksProgressView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        ProgressLineChartView(
                recordingStorage: recordingStorage,
                // TODO: Implement
                recordingsSelector: { recordings in recordings },
                chartAnnotations: ChartAnnotations(title: "Last 2 weeks", legend: "Total spot count"))
    }
}

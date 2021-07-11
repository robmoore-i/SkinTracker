//
// Created by Rob on 20/6/21.
//

import SwiftUI

struct AllTimeProgressView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        ProgressLineChartView(
                recordingStorage: recordingStorage,
                recordingsSelector: { recordings in recordings },
                chartAnnotations: ChartAnnotations(title: "All time", legend: "Total spot count"))
    }
}
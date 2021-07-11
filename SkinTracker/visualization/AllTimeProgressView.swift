//
// Created by Rob on 20/6/21.
//

import SwiftUI

struct AllTimeProgressView: View {
    var recordingStorage: RecordingStorage

    var body: some View {
        ProgressLineChartView(
                recordings: recordingStorage.all,
                chartAnnotations: ChartAnnotations(title: "All time", legend: "Total spot count"))
    }
}

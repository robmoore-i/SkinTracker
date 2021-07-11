//
// Created by Rob on 10/7/21.
//

import SwiftUI

struct LastTwoWeeksProgressView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        ProgressLineChartView(
                recordingStorage: recordingStorage,
                recordingsSelector: { $0.filter { $0.isInLastTwoWeeks() } },
                chartAnnotations: ChartAnnotations(title: "Two weeks", legend: "Total spot count"))
    }
}

extension Recording {
    func isInLastTwoWeeks() -> Bool {
        isInLast(numberOfDays: 14, beforeDate: Date())
    }
}

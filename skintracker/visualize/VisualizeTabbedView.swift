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
                FromTheStartDataView(recordingStorage: recordingStorage).padding()
                HStack {
                    Text("Your Recordings").font(.title).padding(.trailing)
                    ExportRecordingsButton(recordingStorage: recordingStorage).padding(.trailing)
                    ImportRecordingsButton(recordingStorage: recordingStorage)
                    Spacer()
                }.padding(.leading).padding(.top)
                RecordingsListView(recordingStorage: recordingStorage)
            }
        }
    }
}

import SwiftUICharts

struct FromTheStartDataView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        HStack {
            LineChartView(data: recordingStorage.all.map {
                Double($0.totalSpotCount())
            }.reversed(),
                    title: "From the start",
                    rateValue: nil,
                    dropShadow: false,
                    valueSpecifier: "%.0f")
            Spacer()
        }
    }
}
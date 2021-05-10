//
// Created by Rob on 10/5/21.
//

import SwiftUI
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
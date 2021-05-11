//
// Created by Rob on 10/5/21.
//

import SwiftUI
import SwiftUICharts

struct FromTheStartDataView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        HStack {
            let data: [Double] = recordingStorage.all.map {
                Double($0.totalSpotCount())
            }.reversed()
            let percentageChange = 100 * (data.last! - data.first!) / data.first!
            LineChartView(data: data,
                    title: "From the start",
                    rateValue: nil,
                    dropShadow: false,
                    valueSpecifier: "%.0f")
            TrendArrow(percentageChange: percentageChange).padding()
            Spacer()
        }
    }
}

private struct TrendArrow: View {
    let percentageChange: Double

    var body: some View {
        if (percentageChange > 0) {
            VStack {
                Image(systemName: "arrowtriangle.up").foregroundColor(Color.blue)
                Text("\(percentageChange, specifier: "%.0f")%")
            }
        } else if (percentageChange == 0) {
            VStack {
                Image(systemName: "ellipsis").foregroundColor(Color.blue)
                Text("No change")
            }
        } else {
            VStack {
                Image(systemName: "arrowtriangle.down").foregroundColor(Color.blue)
                Text("\(percentageChange, specifier: "%.0f")%")
            }
        }
    }
}
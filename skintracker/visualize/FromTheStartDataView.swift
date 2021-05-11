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
                    title: "All time",
                    legend: "Total spot count",
                    rateValue: nil,
                    dropShadow: false,
                    valueSpecifier: "%.0f spots")
            TrendIndicator(percentageChange: percentageChange).padding(.leading)
            Spacer()
        }
    }
}

private struct TrendIndicator: View {
    let percentageChange: Double

    var body: some View {
        if (percentageChange < 0) {
            decreasingSpotsTrendIndicator()
        } else if (percentageChange == 0) {
            noChangeTrendIndicator()
        } else {
            increasingSpotsTrendIndicator()
        }
    }

    private func decreasingSpotsTrendIndicator() -> some View {
        trendIndicator("arrowtriangle.down", Text("\(percentageChange, specifier: "%.0f")% spot count"))
    }

    private func noChangeTrendIndicator() -> some View {
        trendIndicator("ellipsis", Text("No change in spot count"))
    }

    private func increasingSpotsTrendIndicator() -> some View {
        trendIndicator("arrowtriangle.up", Text("+\(percentageChange, specifier: "%.0f")% spot count"))
    }

    private func trendIndicator(_ systemImageName: String, _ text: Text) -> some View {
        VStack {
            Image(systemName: systemImageName)
                    .scaleEffect(1.5, anchor: .center)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 5)
            text
        }
    }
}
//
// Created by Rob on 10/5/21.
//

import SwiftUI
import SwiftUICharts

struct FromTheStartDataView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        HStack {
            // Requires region-aware interpolation to gracefully account for any potentially missing readings.
            let twiceDailyTotals: [Double] = recordingStorage.all.map {
                Double($0.totalSpotCount())
            }.reversed()
            LineChartView(data: twiceDailyTotals,
                    title: "All time",
                    legend: "Total spot count",
                    rateValue: nil,
                    dropShadow: false,
                    valueSpecifier: "%.0f spots")
            TrendIndicator(
                    percentageChange: 100 * (twiceDailyTotals.last! - twiceDailyTotals.first!) / twiceDailyTotals.first!
                    // Requires the date range in order to show the time period over which this change has happened
            ).padding(.leading)
            Spacer()
        }
    }
}

private struct TrendIndicator: View {
    let percentageChange: Double

    var body: some View {
        if (percentageChange < 0) {
            decreasingSpotsTrendIndicator(percentageChange)
        } else if (percentageChange == 0) {
            noChangeTrendIndicator()
        } else {
            increasingSpotsTrendIndicator(percentageChange)
        }
    }

    private func decreasingSpotsTrendIndicator(_ percentageChange: Double) -> some View {
        trendIndicator("arrowtriangle.down", Text("\(percentageChange, specifier: "%.0f")% spot count"))
    }

    private func noChangeTrendIndicator() -> some View {
        trendIndicator("ellipsis", Text("No change in spot count"))
    }

    private func increasingSpotsTrendIndicator(_ percentageChange: Double) -> some View {
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
//
// Created by Rob on 10/7/21.
//

import SwiftUI
import SwiftUICharts
import SwiftDate

struct ProgressLineChartView: View {
    let recordings: [Recording]
    let chartAnnotations: ChartAnnotations

    var body: some View {
        HStack {
            // At some point, this will require region-aware interpolation to gracefully account for any potentially
            // missing readings.
            let twiceDailyTotals: [Double] = recordings.map {
                Double($0.totalSpotCount())
            }.reversed()
            LineChartView(data: twiceDailyTotals,
                    title: chartAnnotations.title,
                    legend: chartAnnotations.legend,
                    rateValue: nil,
                    dropShadow: false,
                    valueSpecifier: "%.0f spots")
            TrendIndicator(
                    percentageChange: 100 * (twiceDailyTotals.last! - twiceDailyTotals.first!) / twiceDailyTotals.first!,
                    dateRange: recordings.dateRange()
            ).padding(.leading)
        }
    }
}

struct ChartAnnotations {
    let title: String
    let legend: String
}

struct TrendIndicator: View {
    let percentageChange: Double
    let dateRange: Range<Date>

    var body: some View {
        if (percentageChange < 0) {
            decreasingSpotsTrendIndicator()
        } else if (percentageChange > 0) {
            increasingSpotsTrendIndicator()
        } else {
            noChangeTrendIndicator()
        }
    }

    private func decreasingSpotsTrendIndicator() -> some View {
        trendIndicator(
                "arrowtriangle.down",
                Text("\(percentageChange, specifier: "%.0f")% \(whatIsBeingDescribed())")
        )
    }

    private func noChangeTrendIndicator() -> some View {
        trendIndicator("ellipsis", Text("No change in \(whatIsBeingDescribed())"))
    }

    private func increasingSpotsTrendIndicator() -> some View {
        trendIndicator("arrowtriangle.up", Text("+\(percentageChange, specifier: "%.0f")% \(whatIsBeingDescribed())"))
    }

    private func trendIndicator(_ systemImageName: String, _ text: Text) -> some View {
        VStack {
            Image(systemName: systemImageName)
                    .scaleEffect(1.5, anchor: .center)
                    .foregroundColor(Color.black)
                    .padding(.bottom, 5)
            text
        }
    }

    private func whatIsBeingDescribed() -> String {
        "spot count in last \(dateRange.lengthDescription())"
    }
}

extension Range where Bound == Date {
    // Take the sentence "X has happened in the last Y", in which some event(s) X have happened within a certain
    // date range (i.e. Range<Date>), and we want to describe it using the above sentence.
    // The String Y is the return value of this method.
    func lengthDescription() -> String {
        let mostRecentDate = upperBound.convertTo(region: Region.current)
        let startDate = lowerBound.convertTo(region: Region.current)
        let dayCount: Int = mostRecentDate.difference(in: .day, from: startDate)!
        if (dayCount == 0) {
            return "several hours"
        } else if (dayCount <= 3) {
            return "\(dayCount.days.in(.hour)!) hours"
        } else if (dayCount <= 30) {
            return "\(dayCount) days"
        } else {
            return "\(dayCount.days.in(.weekOfYear)!) weeks"
        }
    }
}

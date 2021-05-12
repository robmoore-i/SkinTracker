//
// Created by Rob on 10/5/21.
//

import SwiftUI
import SwiftUICharts
import SwiftDate

struct AllTimeProgressDataView: View {
    @ObservedObject var recordingStorage: RecordingStorage
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            // Requires region-aware interpolation to gracefully account for any potentially missing readings.
            let twiceDailyTotals: [Double] = recordingStorage.all.map {
                Double($0.totalSpotCount())
            }.reversed()
            if (!twiceDailyTotals.isEmpty) {
                LineChartView(data: twiceDailyTotals,
                        title: "All time",
                        legend: "Total spot count",
                        rateValue: nil,
                        dropShadow: false,
                        valueSpecifier: "%.0f spots")
                TrendIndicator(
                        percentageChange: 100 * (twiceDailyTotals.last! - twiceDailyTotals.first!) / twiceDailyTotals.first!,
                        dateRange: recordingStorage.dateRange()
                ).padding(.leading)
            } else {
                let demoTotals: [Double] = [5, 5, 6, 6, 5, 4, 4, 4, 4, 3, 3, 3, 1, 1, 1]
                LineChartView(data: demoTotals,
                        title: "All time",
                        legend: "Total spot count",
                        rateValue: nil,
                        dropShadow: false,
                        valueSpecifier: "%.0f spots")
                VStack(alignment: .leading) {
                    Text("You might be doing this well.")
                            .foregroundColor(.blue)
                            .font(.headline)
                            .padding(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    Text("But you don't have visibility, so you don't know.")
                            .foregroundColor(.blue)
                            .font(.headline)
                            .padding()
                            .fixedSize(horizontal: false, vertical: true)
                    Button(action: {
                        selectedTab = 2
                    }, label: {
                        HStack {
                            Text("Record now")
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .fixedSize(horizontal: false, vertical: true)
                            Image(systemName: "chevron.right.2")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 5)
                        }
                    })
                            .background(Color.blue)
                            .cornerRadius(5)
                            .padding(.leading)
                            .shadow(color: Color.black.opacity(0.4), radius: 4, x: 4, y: 4)
                }
            }
            Spacer()
        }
    }
}

private struct TrendIndicator: View {
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
                    .foregroundColor(Color.blue)
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
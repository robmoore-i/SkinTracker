//
// Created by Rob on 10/5/21.
//

import SwiftUI
import SwiftUICharts

struct MostAffectedRegionsView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    private let dataProcessor = MostAffectedRegionsViewDataProcessor()

    var body: some View {
        HStack {
            let data: [(String, Int)] = dataProcessor.mostAffectedRegionsAggregated(recordingStorage.all)
            BarChartView(data: ChartData(values: data),
                    title: "Most Affected Areas",
                    legend: "Aggregate of all recordings",
                    dropShadow: false,
                    cornerImage: nil,
                    valueSpecifier: "%.0f")
            VStack {
                Text("The areas of your face most likely to be the most affected area on any given day:")
                Text(dataProcessor.mostAffectedRegionDescription(data))
            }.padding(.leading)
            Spacer()
        }
    }
}

struct MostAffectedRegionsViewDataProcessor {
    /**
     A sorted list of tuples, linking the identifying name of a side-specific face region, to the number of times that
     region was among the most affected, across all recordings.
     */
    func mostAffectedRegionsAggregated(_ recordings: [Recording]) -> [(String, Int)] {
        // Maps the identifying name of a region, to the number of days on which it has been among the most affected.
        var regions: [String: Int] = [:]
        recordings.forEach({ (recording: Recording) in
            recording.mostAffectedRegions().forEach({ (region: String) in
                if let currentCount = regions[region] {
                    regions[region] = currentCount + 1
                } else {
                    regions[region] = 1
                }
            })
        })
        return regions.map { (key: String, value: Int) in
            (key, value)
        }.sorted { tuple1, tuple2 in
            // Sorted by the number of times the region has been among the most affected
            tuple1.1 > tuple2.1
        }
    }

    /**
     A string with a list of the areas of the face most likely to be most affected area on any given day. Lists the
     most significant areas with their percentage likelihood, in order, down until at least 80% of recordings have been
     accounted for.

     Take an example like this one:
        Cheeks: 80%
        Right Jawline: 10%
        Other: 10%

     The 'Other' category will never have more than 20% of the recordings.

     There is an exception to this though! If the list would contain more than five elements (i.e. more than four
     specific regions), then it would be truncated and the 'Other' category would contain more than 20% of the
     recordings.

     The 'data' parameter that is passed in, is a sorted list of tuples, which map the name of a region onto the
     number of times it has been the most affected region. It is guaranteed that the name of the underlying FaceRegion
     instance will be contained in the string, but with an undefined capitalization.
     */
    func mostAffectedRegionDescription(_ data: [(String, Int)]) -> String {
        func mostAffectedRegionDescription(_ data: [(String, Int)], _ fullTotal: Int, _ totalRemaining: Int, _ aggregator: String) -> String {
            // If the totalRemaining is less than 20% of the full total, or the number of entries is more than 4,
            // then append 'Other' and call it a day
            let percentageRemaining: Int = Int(100 * (Double(totalRemaining) / Double(fullTotal)))
            let numberOfEntries = aggregator.split(whereSeparator: { $0 == "\n" }).count
            if (percentageRemaining < 20 || numberOfEntries == 4) {
                return aggregator
                        + "\nOther: \(percentageRemaining)%"
            }

            // Check if the first two are the same. If they are, we'll consume both of them.
            var regionalMatch: (Bool, FaceRegion?) = (false, nil)
            FaceRegion.allCases.forEach { (region: FaceRegion) in
                let firstTwoAreForThisRegion = [0, 1].allSatisfy({ (i: Int) -> Bool in
                    data[i].0.lowercased().contains(region.rawValue.lowercased())
                })
                if (firstTwoAreForThisRegion) {
                    regionalMatch = (true, region)
                }
            }
            let regionDescriptor: String
            let regionalOccurrences: Int
            let percentageRegionalOccurrences: Int
            let numberOfEntriesConsumed: Int
            if (regionalMatch.0) {
                // If the first two are the same, combine them and use them together
                regionDescriptor = regionalMatch.1!.rawValue
                regionalOccurrences = data[0].1 + data[1].1
                numberOfEntriesConsumed = 2
            } else {
                // If the first two are different, use only the first one
                regionDescriptor = data[0].0
                regionalOccurrences = data[0].1
                numberOfEntriesConsumed = 1
            }

            // Recurse, appending the selected region's associated data to the aggregator, and deducting the consumed
            // data from the input set.
            percentageRegionalOccurrences = Int(100 * (Double(regionalOccurrences) / Double(fullTotal)))
            return mostAffectedRegionDescription(
                    data.suffix(data.count - numberOfEntriesConsumed),
                    fullTotal,
                    totalRemaining - regionalOccurrences,
                    aggregator + "\n\(regionDescriptor.capitalized): \(percentageRegionalOccurrences)%")
        }

        let total = data.map { $0.1 }.reduce(0) { $0 + $1 }
        return mostAffectedRegionDescription(data, total, total, "")
    }
}

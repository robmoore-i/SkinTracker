//
// Created by Rob on 10/5/21.
//

import SwiftUI
import SwiftUICharts

struct MostAffectedRegionsDataView: View {
    @ObservedObject var recordingStorage: RecordingStorage
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            if (recordingStorage.all.isEmpty) {
                UserActivationDemoView(selectedTab: $selectedTab)
            } else {
                let data: [(String, Int)] = mostAffectedRegionsAggregated()
                BarChartView(data: ChartData(values: data),
                        title: "Most Affected Areas",
                        legend: "Aggregate of all recordings",
                        cornerImage: nil,
                        valueSpecifier: "%.0f")
            }
            Spacer()
        }
    }

    /**
     A sorted list of tuples, linking the identifying name of a side-specific face region, to the number of times that
     region was among the most affected, across all recordings.
     */
    func mostAffectedRegionsAggregated() -> [(String, Int)] {
        // Maps the identifying name of a region, to the number of days on which it has been among the most affected.
        var regions: [String: Int] = [:]
        recordingStorage.all.forEach({ (recording: Recording) in
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
}
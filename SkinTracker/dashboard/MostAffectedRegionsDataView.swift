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
                let data: [(String, Int)] = [("2018 Q4", 63150), ("2019 Q1", 50900), ("2019 Q2", 77550), ("2019 Q3", 79600), ("2019 Q4", 92550)]
                BarChartView(data: ChartData(values: data),
                        title: "Sales",
                        legend: "Quarterly",
                        cornerImage: nil,
                        valueSpecifier: "%.0f")
            }
            Spacer()
        }
    }
}
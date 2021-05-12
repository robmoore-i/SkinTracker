//
// Created by Rob on 12/5/21.
//

import SwiftUI
import SwiftUICharts

struct UserActivationDemoDataView: View {
    @Binding var selectedTab: Int

    var body: some View {
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
}

//
// Created by Rob on 12/5/21.
//

import SwiftUI
import SwiftUICharts

struct UserActivationDemoView: View {
    @Binding var selectedTab: Int

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showCopyLine1 = false
    @State private var showCopyLine2 = false
    @State private var showCallToAction = false

    private let initialDate = Date()

    var body: some View {
        let demoTotals: [Double] = [5, 4, 5, 5, 6, 6, 5, 4, 4, 4, 4, 3, 3, 3, 1, 1, 0, 0, 0, 0]
        LineChartView(data: demoTotals,
                title: "All time",
                legend: "Total spot count",
                rateValue: nil,
                dropShadow: false,
                valueSpecifier: "%.0f spots")
        VStack(alignment: .leading) {
            if (showCopyLine1) {
                CopyLine1(color: .blue)
            } else {
                CopyLine1(color: .white)
            }
            if (showCopyLine2) {
                CopyLine2(color: .blue)
            } else {
                CopyLine2(color: .white)
            }
            GetStartedButton(show: $showCallToAction, selectedTab: $selectedTab)
        }.onReceive(timer, perform: updateDisplayedCopy)
    }

    private func updateDisplayedCopy(output: Date) {
        let difference = output.difference(in: .second, from: initialDate)
        if difference == 2 {
            withAnimation {
                self.showCopyLine1 = true
            }
        } else if difference == 4 {
            withAnimation {
                self.showCopyLine2 = true
            }
        } else if (difference == 6) {
            withAnimation {
                self.showCallToAction = true
            }
        }
    }
}

private struct CopyLine1: View {
    let color: Color

    var body: some View {
        Text("Are you trending towards zero outbreaks?")
                .foregroundColor(color)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
                .fixedSize(horizontal: false, vertical: true)
    }
}

private struct CopyLine2: View {
    let color: Color

    var body: some View {
        Text("...Do you know?")
                .foregroundColor(color)
                .font(.headline)
                .padding()
                .fixedSize(horizontal: false, vertical: true)
    }
}

private struct GetStartedButton: View {
    @Binding var show: Bool
    @Binding var selectedTab: Int

    var body: some View {
        Button(action: {
            selectedTab = 2
        }, label: {
            HStack {
                Text("Start recording")
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
                .background(show ? Color.blue : Color.white)
                .cornerRadius(5)
                .padding(.leading)
                .shadow(color: show ? Color.black.opacity(0.4) : Color.white, radius: 4, x: 4, y: 4)
    }
}
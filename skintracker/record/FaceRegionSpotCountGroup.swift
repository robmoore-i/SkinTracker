//
// Created by Rob on 6/5/21.
//

import SwiftUI

struct FaceRegionSpotCountGroup: View {
    @Binding var selection: RegionalSpotCount

    var body: some View {
        List(FaceRegion.allCases, id: \.rawValue) { region in
            FaceRegionSpotCountField(region: region, regionalSpotCount: $selection)
        }
    }
}

private struct FaceRegionSpotCountField: View {
    let region: FaceRegion
    @Binding var regionalSpotCount: RegionalSpotCount

    var body: some View {
        HStack {
            Text("\(region.rawValue.capitalized)").onTapHideKeyboard()
            Spacer()
            SpotCountTextField(label: "Left", region: region, regionalSpotCount: $regionalSpotCount,
                    updateSpotCountsForRegion: { regionalSpotCounts, spotCountInput in
                        regionalSpotCounts.put(region: region, left: spotCountInput)
                    })
            SpotCountTextField(label: "Right", region: region, regionalSpotCount: $regionalSpotCount,
                    updateSpotCountsForRegion: { regionalSpotCount, spotCountInput in
                        regionalSpotCount.put(region: region, right: spotCountInput)
                    })
        }
    }
}

private struct SpotCountTextField: View {
    let label: String
    let region: FaceRegion
    @Binding var regionalSpotCount: RegionalSpotCount
    let updateSpotCountsForRegion: (_: inout RegionalSpotCount, _: Int) -> ()

    @State private var text: String = ""

    var body: some View {
        Text(label).onTapHideKeyboard()
        TextField("0", text: $text)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 40)
                .onChange(of: text) { newText in
                    updateSpotCountsForRegion(&regionalSpotCount, Int(newText) ?? 0)
                    print("Selection[\(region)] is \(regionalSpotCount.get(region))")
                }
    }
}

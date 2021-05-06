//
// Created by Rob on 6/5/21.
//

import SwiftUI

struct FaceRegionSpotCountGroup: View {
    @Binding var selection: [FaceRegion: (left: Int, right: Int)]

    var body: some View {
        List(FaceRegion.allCases, id: \.rawValue) { region in
            FaceRegionSpotCountField(region: region, regionalSpotCounts: $selection)
        }
    }
}

private struct FaceRegionSpotCountField: View {
    let region: FaceRegion
    @Binding var regionalSpotCounts: [FaceRegion: (left: Int, right: Int)]

    var body: some View {
        HStack {
            Text("\(region.rawValue.capitalized)").onTapHideKeyboard()
            Spacer()
            SpotCountTextField(label: "Left", region: region, regionalSpotCounts: $regionalSpotCounts,
                    updateSpotCountsForRegion: { regionalSpotCounts, spotCountInput in
                        regionalSpotCounts[region]?.left = spotCountInput
                    })
            SpotCountTextField(label: "Right", region: region, regionalSpotCounts: $regionalSpotCounts,
                    updateSpotCountsForRegion: { regionalSpotCounts, spotCountInput in
                        regionalSpotCounts[region]?.right = spotCountInput
                    })
        }
    }
}

private struct SpotCountTextField: View {
    let label: String
    let region: FaceRegion
    @Binding var regionalSpotCounts: [FaceRegion: (left: Int, right: Int)]
    let updateSpotCountsForRegion: (_: inout [FaceRegion: (left: Int, right: Int)], _: Int) -> ()

    @State private var text: String = ""

    var body: some View {
        Text(label).onTapHideKeyboard()
        TextField("0", text: $text)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 40)
                .onChange(of: text) { newText in
                    if (regionalSpotCounts[region] == nil) {
                        regionalSpotCounts[region] = (0, 0)
                    }
                    updateSpotCountsForRegion(&regionalSpotCounts, Int(newText) ?? 0)
                    print("Selection[\(region)] is \(regionalSpotCounts[region]!)")
                }
    }
}

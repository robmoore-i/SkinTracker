//
// Created by Rob on 6/5/21.
//

import SwiftUI

struct FaceRegionSpotCountGroup: View {
    @Binding var selectedSpotCounts: RegionalSpotCount
    @Binding var formRecording: FormRecording

    var body: some View {
        List(FaceRegion.allCases, id: \.rawValue) { region in
            FaceRegionSpotCountField(
                    region: region,
                    formRecording: $formRecording,
                    selectedRegionalSpotCount: $selectedSpotCounts)
        }
    }
}

private struct FaceRegionSpotCountField: View {
    let region: FaceRegion
    @Binding var formRecording: FormRecording
    @Binding var selectedRegionalSpotCount: RegionalSpotCount

    var body: some View {
        HStack {
            Text("\(region.rawValue.capitalized)").onTapGesture {
                UsageAnalytics.event(.tapFaceRegionSpotCountFieldRegionName, properties: ["region": "\(region.rawValue)"])
                hideKeyboard()
            }
            Spacer()
            SpotCountTextField(sideLabel: SideLabel.left, region: region,
                    formRecording: $formRecording,
                    selectedRegionalSpotCount: $selectedRegionalSpotCount)
            SpotCountTextField(sideLabel: SideLabel.right, region: region,
                    formRecording: $formRecording,
                    selectedRegionalSpotCount: $selectedRegionalSpotCount)
        }
    }
}

private enum SideLabel: String {
    case left = "Left"
    case right = "Right"
}

private struct SpotCountTextField: View {
    let sideLabel: SideLabel
    let region: FaceRegion
    @Binding var formRecording: FormRecording
    @Binding var selectedRegionalSpotCount: RegionalSpotCount

    @State private var text: String = ""

    var body: some View {
        Text(sideLabel.rawValue).onTapGesture {
            UsageAnalytics.event(.tapFaceRegionSpotCountFieldSideLabel, properties: ["side": sideLabel.rawValue.lowercased()])
            hideKeyboard()
        }
        TextField(placeholderText(), text: $text)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 40)
                .onChange(of: text) { newText in
                    UsageAnalytics.event(.changeRecordingSpotCountEntry,
                            properties: [
                                "side": "\(sideLabel.rawValue.lowercased())",
                                "region": "\(region.rawValue)"])
                    if (newText.isEmpty) {
                        clearEntry()
                    } else {
                        updateSelection(spotCountInput: Int(newText) ?? 0)
                    }
                    print("Selection[\(region)] is \(selectedRegionalSpotCount.get(region))")
                }
    }

    private func clearEntry() {
        switch sideLabel {
        case .left:
            selectedRegionalSpotCount.delete(leftEntryFor: region)
        case .right:
            selectedRegionalSpotCount.delete(rightEntryFor: region)
        }
    }

    private func updateSelection(spotCountInput: Int) {
        switch sideLabel {
        case .left:
            selectedRegionalSpotCount.put(region: region, left: spotCountInput)
        case .right:
            selectedRegionalSpotCount.put(region: region, right: spotCountInput)
        }
    }

    private func placeholderText() -> String {
        let counts: (left: Int, right: Int) = formRecording.placeholderSpotCount(forRegion: region)
        switch sideLabel {
        case .left:
            return "\(counts.left)"
        case .right:
            return "\(counts.right)"
        }
    }
}

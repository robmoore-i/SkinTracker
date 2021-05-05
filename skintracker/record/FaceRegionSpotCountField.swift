//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct FaceRegionSpotCountField: View {
    private let region: FaceRegion

    @State private var left = ""
    @State private var right = ""

    init(region: FaceRegion) {
        self.region = region
    }

    var body: some View {
        HStack {
            formRowText("\(region.rawValue.capitalized)")
            Spacer()
            formRowText("Left")
            TextField("0", text: $left)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 40)
            formRowText("Right")
            TextField("0", text: $right)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 40)
        }
    }

    private func formRowText(_ s: String) -> some View {
        Text(s).onTapGesture(perform: hideKeyboard)
    }
}

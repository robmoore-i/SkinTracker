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
            Text("\(region.rawValue.capitalized)").onTapHideKeyboard()
            Spacer().onTapHideKeyboard()
            Text("Left").onTapHideKeyboard()
            TextField("0", text: $left)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 40)
            Text("Right").onTapHideKeyboard()
            TextField("0", text: $right)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 40)
        }
    }
}

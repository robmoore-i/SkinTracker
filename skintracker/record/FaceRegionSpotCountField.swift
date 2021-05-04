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
            Text("\(region.rawValue.capitalized) |")
            Spacer()
            Text("L")
            TextField("0", text: $left)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("R")
            TextField("0", text: $right)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

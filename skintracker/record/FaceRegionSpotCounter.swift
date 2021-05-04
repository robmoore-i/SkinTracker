//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct FaceRegionSpotCounter: View {
    @Binding var selection: FaceRegion

    @State private var foreheadLeft = "0"
    @State private var foreheadRight = "0"

    var body: some View {
        HStack {
            Text(FaceRegion.forehead.rawValue.capitalized)
            Spacer()
            Text("Left")
            TextField("\(FaceRegion.forehead.rawValue)-left", text: $foreheadLeft)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Right")
            TextField("\(FaceRegion.forehead.rawValue)-right", text: $foreheadRight)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

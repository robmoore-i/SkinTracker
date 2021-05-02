//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct FaceRegionSpotCounter: View {
    @Binding var selection: FaceRegion

    @State private var forehead = "0"

    var body: some View {
        HStack {
            Text(FaceRegion.forehead.rawValue)
            Spacer()
            TextField("", text: $forehead).keyboardType(.numberPad)
        }
    }
}

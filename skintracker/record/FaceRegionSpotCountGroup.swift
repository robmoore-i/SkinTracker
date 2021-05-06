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


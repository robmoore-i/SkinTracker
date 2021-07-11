//
// Created by Rob on 11/7/21.
//

import SwiftUI

struct PerformanceTestingTabbedView: View {
    var body: some View {
        TabbedView(tabName: "Performance Testing", tabIconSfImageName: "speedometer") {
            Text("SkinTracker").padding()
        }
    }
}

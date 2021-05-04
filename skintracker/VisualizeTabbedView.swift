//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct VisualizeTabbedView: View {
    var body: some View {
        TabbedView("Visualize", "chart.bar.xaxis", 3) {
            Text("Visualize View").padding()
        }
    }
}

//
// Created by Rob on 20/8/21.
//

import SwiftUI

struct ExperimentTabbedView: View {
    var body: some View {
        TabbedView(tabName: "Experiment", tabIconSfImageName: "pyramid") {
            Text("Experiment").padding()
        }
    }
}
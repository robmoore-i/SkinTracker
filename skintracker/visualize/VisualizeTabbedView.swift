//
// Created by Rob on 2/5/21.
//

import SwiftUI
import RealmSwift

struct VisualizeTabbedView: View {
    private let realm: Realm

    init(_ realm: Realm) {
        self.realm = realm
    }

    var body: some View {
        TabbedView("Visualize", "chart.bar.xaxis") {
            RecordingsListView(realm)
        }
    }
}

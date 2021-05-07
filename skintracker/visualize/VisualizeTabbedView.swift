//
// Created by Rob on 2/5/21.
//

import SwiftUI
import RealmSwift

class RecordingsModel: ObservableObject {
    private let realm: Realm

    init(_ realm: Realm) {
        self.realm = realm
    }

    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                load()
            }
        }
    }

    @Published var recordings: [Recording] = []

    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.recordings = self.realm.objects(RecordingRealmObjectV1.self)
                    .map(Recording.fromRealmObjectV1)
            print("Recordings: \(self.recordings)")
            self.loading = false
        }
    }
}

struct VisualizeTabbedView: View {
    @ObservedObject var recordingsModel: RecordingsModel

    var body: some View {
        TabbedView("Visualize", "chart.bar.xaxis") {
            RefreshableScrollView(height: 200, refreshing: self.$recordingsModel.loading) {
                ForEach(recordingsModel.recordings) { recording in
                    Text(recording.description)
                }
            }
        }
    }
}

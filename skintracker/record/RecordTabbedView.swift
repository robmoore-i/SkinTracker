//
// Created by Rob on 2/5/21.
//

import SwiftUI
import RealmSwift

struct RecordTabbedView: View {
    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am
    @State private var selectedSpotCounts: [FaceRegion: (left: Int, right: Int)] = [:]

    private let realm: Realm

    init(_ realm: Realm) {
        self.realm = realm
    }

    var body: some View {
        TabbedView("Record", "plus.square") {
            Form {
                Section {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    TimeOfDayToggle(selection: $selectedTimeOfDay)
                }

                Section {
                    FaceRegionSpotCountGroup(selection: $selectedSpotCounts)
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Save") {
                            onSave()
                        }.frame(maxWidth: 100).padding(10.0)
                        Spacer()
                    }
                }
            }
        }
    }

    private func onSave() {
        let recording = Recording(selectedDate, selectedTimeOfDay, selectedSpotCounts)
        print("Saving: \(recording)")
        do {
            try realm.write {
                realm.add(recording.toRealmObjectV1())
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
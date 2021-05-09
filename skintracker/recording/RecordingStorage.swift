//
// Created by Rob on 7/5/21.
//

import Foundation
import RealmSwift

class RecordingStorage: ObservableObject {
    private let realm: Realm
    @Published public private(set) var all: [Recording] = []

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Couldn't initialise Realm")
        }
        refresh()
    }

    func refresh() {
        all = realm.objects(RecordingRealmObjectV1.self)
                .map(Recording.fromRealmObjectV1)
                .sorted(by: Recording.chronologicalSortCriteria)
        print("Recordings(RecordingStorage): \(all)")
    }

    func hasEntryFor(date: Date, time: TimeOfDay) -> Bool {
        all.anySatisfy { recording in
            recording.isFor(date: date, time: time)
        }
    }

    func store(_ date: Date, _ timeOfDay: TimeOfDay, _ regionalSpotCount: RegionalSpotCount) {
        let newRecord = Recording(date, timeOfDay, regionalSpotCount)
        if let existingRecord = all.first(where: { recording in
            recording.isFor(date: date, time: timeOfDay)
        }) {
            overwrite(existingRecord: existingRecord, newRecord: newRecord)
        } else {
            add(newRecord: newRecord)
        }
    }

    private func overwrite(existingRecord: Recording, newRecord: Recording) {
        print("Overwriting existing entry: \(existingRecord)")
        print("Saving updated entry: \(newRecord)")
        do {
            try realm.write {
                realm.delete(realm.objects(RecordingRealmObjectV1.self).filter {
                    $0.id == existingRecord.id
                })
                all.removeAll {
                    $0.id == existingRecord.id
                }
                realm.add(newRecord.toRealmObjectV1())
                all.insertSorted(newRecord)
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func add(newRecord: Recording) {
        print("Saving new entry: \(newRecord)")
        do {
            try realm.write {
                realm.add(newRecord.toRealmObjectV1())
                all.insertSorted(newRecord)
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteItem(atIndex index: Int) {
        let recordToDelete = all[index]
        print("Deleting record: \(recordToDelete)")
        do {
            try realm.write {
                realm.delete(realm.objects(RecordingRealmObjectV1.self).filter {
                    $0.id == recordToDelete.id
                })
                all.removeAll {
                    $0.id == recordToDelete.id
                }
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension Array {
    func anySatisfy(condition: (Element) -> Bool) -> Bool {
        !allSatisfy { element in
            !condition(element)
        }
    }
}

extension Array where Element == Recording {
    mutating func insertSorted(_ r: Recording) {
        append(r)
        sort(by: Recording.chronologicalSortCriteria)
    }
}
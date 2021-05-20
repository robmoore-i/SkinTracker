//
// Created by Rob on 7/5/21.
//

import Foundation
import RealmSwift

class RecordingStorage: ObservableObject {
    private let realm: Realm
    @Published public private(set) var all: [Recording] = []

    private let versionedStorage = VersionedRecordingRealmStorage()

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Couldn't initialise Realm")
        }

        do {
            // This will execute any data migrations that need to happen.
            // It guarantees that all operations in this class are done on top of the latest version of the data model.
            try versionedStorage.migration(realm)
        } catch let error {
            print(error.localizedDescription)
            print("Recording data migration failed. No disruption should take place.")
        }

        refresh()
    }

    func refresh() {
        refresh(recordings: versionedStorage.readAll(realm))
    }

    func refresh(recordings: [Recording]) {
        all = recordings.sorted(by: Recording.chronologicalSortCriteria)
        print("Recordings(RecordingStorage): \(all)")
    }

    func hasEntryFor(date: Date, time: TimeOfDay) -> Bool {
        all.anySatisfy { recording in
            recording.isFor(date: date, time: time)
        }
    }

    func dateRange() -> Range<Date> {
        // The 'all' collection is ordered from most recent to least recent.
        all.last!.until(all.first!)
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
                versionedStorage.delete(realm, id: existingRecord.id)
                all.remove(id: existingRecord.id)
                versionedStorage.insert(realm, record: newRecord)
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
                versionedStorage.insert(realm, record: newRecord)
                all.insertSorted(newRecord)
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteItem(atIndex index: Int) -> Recording {
        print("Deleting record at index \(index)")
        let recordToDelete = all[index]
        print("Deleting record: \(recordToDelete)")
        do {
            try realm.write {
                versionedStorage.delete(realm, id: recordToDelete.id)
                all.remove(id: recordToDelete.id)
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return recordToDelete
    }

    func allAsJson() -> String {
        "[\(all.map { $0.toJson() }.joined(separator: ", "))]"
    }

    func realmForRecordingObjectImport() -> Realm {
        realm
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

    mutating func remove(id: Int) {
        removeAll {
            $0.id == id
        }
    }
}
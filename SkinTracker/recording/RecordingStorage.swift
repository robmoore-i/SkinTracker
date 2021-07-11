//
// Created by Rob on 7/5/21.
//

import Foundation
import RealmSwift

class RecordingStorage: ObservableObject {
    private let realm: Realm
    @Published public private(set) var all: [Recording] = []

    private let versionedStorage: VersionedRecordingStorage

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Couldn't initialise Realm")
        }

        versionedStorage = VersionedRecordingRealmStorage(realm)

        do {
            // This will execute any data migrations that need to happen.
            // It guarantees that all operations in this class are done on top of the latest version of the data model.
            try versionedStorage.migration()
        } catch let error {
            print(error.localizedDescription)
            print("Recording data migration failed. No disruption should take place.")
        }

        refresh()
    }

    func refresh() {
        refresh(recordings: versionedStorage.readAll())
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

    func entryFor(date: Date, time: TimeOfDay) -> Recording? {
        all.first(where: { recording in
            recording.isFor(date: date, time: time)
        })
    }

    func dateRange() -> Range<Date> {
        // The 'all' collection is ordered from most recent to least recent.
        all.last!.until(all.first!)
    }

    func dateRange(_ recordings: [Recording]) -> Range<Date> {
        // Assumes that the 'recordings' collection is ordered from most recent to least recent.
        recordings.last!.until(recordings.first!)
    }

    func store(_ newRecord: Recording) {
        if let existingRecord = all.first(where: { (recording: Recording) in
            recording.isForSameDateAndTimeAs(other: newRecord)
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
                versionedStorage.delete(id: existingRecord.id)
                all.remove(id: existingRecord.id)
                versionedStorage.insert(record: newRecord)
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
                versionedStorage.insert(record: newRecord)
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
                versionedStorage.delete(id: recordToDelete.id)
                all.remove(id: recordToDelete.id)
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return recordToDelete
    }

    func exportAllToJson() -> String {
        let commandSeparatedJsonObjects = all.map { (recording: Recording) in
            recording.toLatestJson()
        }.joined(separator: ", ")
        return "[\(commandSeparatedJsonObjects)]"
    }

    func importAllFromJson(_ json: String) {
        print("Importing JSON: \(json)")
        let jsonData: Data = json.data(using: .utf8)!
        let importedRecordings = versionedStorage.recordingsFromData(data: jsonData)
        print("Parsed recordings: \(importedRecordings)")
        do {
            try realm.write {
                realm.deleteAll()
                importedRecordings.forEach { (recording: Recording) in
                    versionedStorage.insert(record: recording)
                }
                print("Saved imported recordings successfully")
                refresh(recordings: importedRecordings)
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

    mutating func remove(id: Int) {
        removeAll {
            $0.id == id
        }
    }
}
//
// Created by Rob on 7/5/21.
//

import Foundation

class RecordingStorage: ObservableObject {
    private let realm: RealmAdapter
    @Published public private(set) var all: [Recording] = []

    private let versionedStorage: VersionedRecordingStorage

    init() {
        realm = RealmAdapter()

        versionedStorage = realm.versionedRecordingStorage

        do {
            try versionedStorage.migration()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Recording data migration failed.")
        }

        refresh()
    }

    private func refresh() {
        refresh(recordings: versionedStorage.readAll())
    }

    private func refresh(recordings: [Recording]) {
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
        realm.withinWriteTransaction {
            versionedStorage.delete(id: existingRecord.id)
            all.remove(id: existingRecord.id)
            versionedStorage.insert(record: newRecord)
            all.insertSorted(newRecord)
            print("Wrote successfully")
        }
    }

    private func add(newRecord: Recording) {
        print("Saving new entry: \(newRecord)")
        realm.withinWriteTransaction {
            versionedStorage.insert(record: newRecord)
            all.insertSorted(newRecord)
            print("Wrote successfully")
        }
    }

    func deleteItem(atIndex index: Int) -> Recording {
        print("Deleting record at index \(index)")
        let recordToDelete = all[index]
        print("Deleting record: \(recordToDelete)")
        realm.withinWriteTransaction {
            versionedStorage.delete(id: recordToDelete.id)
            all.remove(id: recordToDelete.id)
            print("Wrote successfully")
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
        let importedRecordings = versionedStorage.recordingsFromJson(json: json)
        print("Parsed recordings: \(importedRecordings)")
        realm.withinWriteTransaction {
            realm.deleteEverything()
            importedRecordings.forEach { (recording: Recording) in
                versionedStorage.insert(record: recording)
            }
            print("Saved imported recordings successfully")
            refresh(recordings: importedRecordings)
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

    func dateRange() -> Range<Date> {
        // Assumes that the array is ordered from most recent to least recent.
        last!.until(first!)
    }
}
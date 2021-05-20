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
        refresh(recordings: readAll())
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
                delete(id: existingRecord.id)
                all.remove(id: existingRecord.id)
                insert(record: newRecord)
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
                insert(record: newRecord)
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
                delete(id: recordToDelete.id)
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

    private func readAll() -> [Recording] {
        readAllV1().map(Recording.fromRealmObjectV1)
    }

    private func insert(record: Recording) {
        realm.add(record.toRealmObjectV1())
    }

    private func delete(id: Int) {
        realm.delete(readAllV1().filter {
            $0.id == id
        })
    }

    private func readAllV1() -> Results<RecordingRealmObjectV1> {
        realm.objects(RecordingRealmObjectV1.self)
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
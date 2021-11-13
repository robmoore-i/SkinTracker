//
// Created by Rob on 7/5/21.
//

import Foundation

class RecordingStorage: ObservableObject {
    @Published public private(set) var all: [Recording] = []

    private let storageProvider: StorageProvider
    private let versionedStorage: VersionedRecordingStorage

    init(_ storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
        versionedStorage = storageProvider.versionedRecordingStorage

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
            recording.recordingTime.isFor(date: date, time: time)
        }
    }

    func entryFor(date: Date, time: TimeOfDay) -> Recording? {
        all.first(where: { recording in
            recording.recordingTime.isFor(date: date, time: time)
        })
    }

    func store(_ newRecording: Recording) {
        if let existingRecording = all.first(where: { (recording: Recording) in
            recording.recordingTime == newRecording.recordingTime
        }) {
            overwrite(existingRecording: existingRecording, newRecording: newRecording)
        } else {
            add(newRecording: newRecording)
        }
    }

    private func overwrite(existingRecording: Recording, newRecording: Recording) {
        print("Overwriting existing entry: \(existingRecording)")
        print("Saving updated entry: \(newRecording)")
        storageProvider.atomicWrite {
            versionedStorage.delete(id: existingRecording.id)
            all.remove(id: existingRecording.id)
            versionedStorage.insert(record: newRecording)
            all.insertSorted(newRecording)
            print("Wrote successfully")
        }
    }

    private func add(newRecording: Recording) {
        print("Saving new entry: \(newRecording)")
        storageProvider.atomicWrite {
            versionedStorage.insert(record: newRecording)
            all.insertSorted(newRecording)
            print("Wrote successfully")
        }
    }

    func deleteItem(atIndex index: Int) -> Recording {
        print("Deleting recording at index \(index)")
        let recordingToDelete = all[index]
        print("Deleting recording: \(recordingToDelete)")
        storageProvider.atomicWrite {
            versionedStorage.delete(id: recordingToDelete.id)
            all.remove(id: recordingToDelete.id)
            print("Wrote successfully")
        }
        return recordingToDelete
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
        storageProvider.atomicWrite {
            storageProvider.deleteEverything()
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
        if (isEmpty) {
            // Not really a beautiful piece of code. I hope it works correctly, but honestly I'm not sure.
            // Sorry, future me.
            let arbitraryDate = Date(year: 2021, month: 7, day: 28, hour: 12, minute: 0)
            let emptyRange = arbitraryDate..<arbitraryDate
            return emptyRange
        }
        // Assumes that the array is ordered from most recent to least recent.
        return (last!).recordingTime.until((first!).recordingTime)
    }

    func totalSpotCount() -> Int {
        map({ r in r.totalSpotCount() }).reduce(0, { acc, next in acc + next})
    }
}
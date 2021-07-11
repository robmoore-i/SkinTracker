//
// Created by Rob on 11/7/21.
//

class EmptyStorageProvider : StorageProvider {
    private(set) var versionedRecordingStorage: VersionedRecordingStorage = EmptyVersionedRecordingStorage()

    func atomicWrite(_ closure: () throws -> ()) {
        do {
            try closure()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteEverything() {
    }
}

class EmptyVersionedRecordingStorage : VersionedRecordingStorage {
    func migration() throws {
    }

    func readAll() -> [Recording] {
        []
    }

    func insert(record: Recording) {
    }

    func delete(id: Int) {
    }

    func recordingsFromJson(json: String) -> [Recording] {
        []
    }
}
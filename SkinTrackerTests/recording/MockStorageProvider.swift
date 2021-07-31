//
// Created by Rob on 31/7/21.
//

@testable import SkinTracker

class MockStorageProvider: StorageProvider {

    class Factory {
        static func usingRecordings(_ recordings: [Recording]) -> MockStorageProvider {
            MockStorageProvider(MockVersionedRecordingStorage(recordings))
        }
    }

    private init(_ versionedRecordingStorage: VersionedRecordingStorage) {
        self.versionedRecordingStorage = versionedRecordingStorage
    }

    var versionedRecordingStorage: VersionedRecordingStorage

    func atomicWrite(_ closure: () throws -> ()) {
        try! closure()
    }

    func deleteEverything() {
    }

    private class MockVersionedRecordingStorage: VersionedRecordingStorage {
        private var recordings: [Recording]

        convenience init() {
            self.init([])
        }

        init(_ initialRecordings: [Recording]) {
            recordings = initialRecordings
        }

        func migration() throws {
        }

        func readAll() -> [Recording] {
            recordings
        }

        func insert(record: Recording) {
        }

        func delete(id: Int) {
        }

        func recordingsFromJson(json: String) -> [Recording] {
            []
        }
    }
}

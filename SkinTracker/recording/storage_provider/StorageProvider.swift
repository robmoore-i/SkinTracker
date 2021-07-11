//
// Created by Rob on 11/7/21.
//

protocol StorageProvider {
    var versionedRecordingStorage: VersionedRecordingStorage { get }

    func atomicWrite(_ closure: () throws -> ())

    func deleteEverything()
}
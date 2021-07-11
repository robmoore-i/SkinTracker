//
// Created by Rob on 11/7/21.
//

import RealmSwift

class EmptyRealmStorageProvider : StorageProvider {
    private let realm: Realm

    private(set) var versionedRecordingStorage: VersionedRecordingStorage = EmptyVersionedRecordingStorage()

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Couldn't initialise Realm")
        }
    }

    func withinWriteTransaction(_ closure: () throws -> ()) {
        do {
            try realm.write { try closure() }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteEverything() {
        realm.deleteAll()
    }
}
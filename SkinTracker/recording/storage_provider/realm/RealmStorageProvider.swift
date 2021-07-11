//
// Created by Rob on 11/7/21.
//

import RealmSwift

class RealmStorageProvider : StorageProvider {
    private let realm: Realm

    lazy var versionedRecordingStorage: VersionedRecordingStorage = {
         RealmVersionedRecordingStorage(realm)
    }()

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Couldn't initialise Realm")
        }
    }

    func atomicWrite(_ closure: () throws -> ()) {
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

//
// Created by Rob on 20/5/21.
//

import RealmSwift

class VersionedRecordingRealmStorage {
    func migration(_ realm: Realm) throws {
        // Collect all older versions all together into the 'all' variable.
        let all: [Recording] = realm.objects(RecordingRealmObjectV1.self).map(Recording.fromRealmObjectV1)
        print("Un-migrated records: \(all)")

        // Only actually execute migration if there are un-migrated records.
        if (!all.isEmpty) {

            // Perform the migration within a Realm transaction.
            try realm.write {

                // Serialize all the older records into the latest version, and save them to Realm.
                all.forEach { (record: Recording) in
                    realm.add(record.toRealmObjectV2())
                }

                // Empty all the storage of the older versions.
                realm.delete(realm.objects(RecordingRealmObjectV1.self))
            }
        }
    }

    func readAll(_ realm: Realm) -> [Recording] {
        readAllV2(realm).map(Recording.fromRealmObjectV2)
    }

    func insert(_ realm: Realm, record: Recording) {
        realm.add(record.toRealmObjectV2())
    }

    func delete(_ realm: Realm, id: Int) {
        realm.delete(readAllV2(realm).filter {
            $0.id == id
        })
    }
}
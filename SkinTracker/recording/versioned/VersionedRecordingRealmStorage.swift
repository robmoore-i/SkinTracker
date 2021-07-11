//
// Created by Rob on 20/5/21.
//

import RealmSwift
import Foundation

class VersionedRecordingRealmStorage : VersionedRecordingStorage {
    private let realm: Realm

    init(_ realm: Realm) {
        self.realm = realm
    }

    func migration() throws {
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

    func readAll() -> [Recording] {
        readAllV2(realm).map(Recording.fromRealmObjectV2)
    }

    func insert(record: Recording) {
        realm.add(record.toRealmObjectV2())
    }

    func delete(id: Int) {
        realm.delete(readAllV2(realm).filter {
            $0.id == id
        })
    }

    func recordingsFromData(data: Data) -> [Recording] {
        let decoder = JSONDecoder()
        if let recordings = try? decoder.decode([RecordingRealmObjectV1].self, from: data) {
            print("Data parsed successfully as V1 Recordings")
            return recordings.map { (o: RecordingRealmObjectV1) in
                Recording.fromRealmObjectV1(o)
            }
        } else if let recordings = try? decoder.decode([RecordingRealmObjectV2].self, from: data) {
            print("Data parsed successfully as V2 Recordings")
            return recordings.map { (o: RecordingRealmObjectV2) in
                Recording.fromRealmObjectV2(o)
            }
        } else {
            print("The provided data couldn't be decoded into any type of Recording object. Giving empty list.")
            return []
        }
    }
}

extension Recording {
    func toLatestJson() -> String {
        toJsonV2()
    }
}
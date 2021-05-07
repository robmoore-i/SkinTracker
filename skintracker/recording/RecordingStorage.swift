//
// Created by Rob on 7/5/21.
//

import RealmSwift

class RecordingStorage {
    private let realm: Realm
    public private(set) var all: [Recording] = []

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
        all = realm.objects(RecordingRealmObjectV1.self)
                .map(Recording.fromRealmObjectV1)
        print("Recordings(RecordingStorage): \(all)")
    }

    func store(_ r: Recording) {
        print("Saving: \(r)")
        do {
            try realm.write {
                realm.add(r.toRealmObjectV1())
                print("Wrote successfully")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
//
// Created by Rob on 20/5/21.
//

import RealmSwift
import Foundation
import SwiftDate

class RecordingRealmObjectV1: Object, Codable {
    @objc dynamic var modelVersion = 1

    @objc dynamic var id = 0
    @objc dynamic var date = Date()
    @objc dynamic var timeOfDay = ""

    @objc dynamic var foreheadLeft = 0
    @objc dynamic var foreheadRight = 0
    @objc dynamic var eyeLeft = 0
    @objc dynamic var eyeRight = 0
    @objc dynamic var cheekLeft = 0
    @objc dynamic var cheekRight = 0
    @objc dynamic var jawlineLeft = 0
    @objc dynamic var jawlineRight = 0
    @objc dynamic var noseLeft = 0
    @objc dynamic var noseRight = 0
    @objc dynamic var mouthLeft = 0
    @objc dynamic var mouthRight = 0
    @objc dynamic var chinLeft = 0
    @objc dynamic var chinRight = 0

    override static func primaryKey() -> String? {
        "id"
    }
}

extension Recording {
    func toRealmObjectV1() -> RecordingRealmObjectV1 {
        let (date, timeOfDay, regionalSpotCount) = realmObjectConversionParts()
        let o = RecordingRealmObjectV1()
        o.id = id
        o.date = date
        o.timeOfDay = timeOfDay.rawValue
        o.foreheadLeft = regionalSpotCount.get(.forehead).left
        o.foreheadRight = regionalSpotCount.get(.forehead).right
        o.eyeLeft = regionalSpotCount.get(.eyebrows).left
        o.eyeRight = regionalSpotCount.get(.eyebrows).right
        o.cheekLeft = regionalSpotCount.get(.cheek).left
        o.cheekRight = regionalSpotCount.get(.cheek).right
        o.jawlineLeft = regionalSpotCount.get(.jawline).left
        o.jawlineRight = regionalSpotCount.get(.jawline).right
        o.noseLeft = regionalSpotCount.get(.nose).left
        o.noseRight = regionalSpotCount.get(.nose).right
        o.mouthLeft = regionalSpotCount.get(.mouth).left
        o.mouthRight = regionalSpotCount.get(.mouth).right
        o.chinLeft = regionalSpotCount.get(.chin).left
        o.chinRight = regionalSpotCount.get(.chin).right
        return o
    }

    static func fromRealmObjectV1(_ r: RecordingRealmObjectV1) -> Recording {
        let regionalSpotCount: RegionalSpotCount = RegionalSpotCount()
        regionalSpotCount.put(region: .forehead, left: r.foreheadLeft, right: r.foreheadRight)
        regionalSpotCount.put(region: .eyebrows, left: r.eyeLeft, right: r.eyeRight)
        regionalSpotCount.put(region: .cheek, left: r.cheekLeft, right: r.cheekRight)
        regionalSpotCount.put(region: .jawline, left: r.jawlineLeft, right: r.jawlineRight)
        regionalSpotCount.put(region: .nose, left: r.noseLeft, right: r.noseRight)
        regionalSpotCount.put(region: .mouth, left: r.mouthLeft, right: r.mouthRight)
        regionalSpotCount.put(region: .chin, left: r.chinLeft, right: r.chinRight)
        let timeOfDay: TimeOfDay = TimeOfDay.init(rawValue: r.timeOfDay)!
        return Recording(r.id, r.date, timeOfDay, regionalSpotCount)
    }

    static func fromJsonV1(_ json: String) -> Recording {
        let dataFromJsonString = json.data(using: .utf8)!
        let realmObjectV1 = try! JSONDecoder().decode(RecordingRealmObjectV1.self, from: dataFromJsonString)
        return Recording.fromRealmObjectV1(realmObjectV1)
    }
}

extension RecordingStorage {
    func importFromJsonV1(_ json: String) {
        print("Using JSON: \(json)")
        let jsonData = json.data(using: .utf8)!
        let v1JsonRecordings = try! JSONDecoder().decode([RecordingRealmObjectV1].self, from: jsonData)
        let importedRecordings = v1JsonRecordings.map {
            Recording.fromRealmObjectV1($0)
        }
        print("Using parsed recordings: \(importedRecordings)")
        let realm = realmForRecordingObjectImport()
        do {
            try realm.write {
                realm.deleteAll()
                importedRecordings.forEach { recording in
                    realm.add(recording.toRealmObjectV1())
                }
                print("Wrote successfully")
                refresh(recordings: importedRecordings)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
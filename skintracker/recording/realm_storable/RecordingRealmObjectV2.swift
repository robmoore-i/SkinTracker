//
// Created by Rob on 20/5/21.
//

import RealmSwift
import Foundation
import SwiftDate

/**
 Changes from V1:
   eye -> eyebrows
 */
class RecordingRealmObjectV2: Object, Codable {
    @objc dynamic var modelVersion = 2

    @objc dynamic var id = 0
    @objc dynamic var date = Date()
    @objc dynamic var timeOfDay = ""

    @objc dynamic var foreheadLeft = 0
    @objc dynamic var foreheadRight = 0
    @objc dynamic var eyebrowsLeft = 0
    @objc dynamic var eyebrowsRight = 0
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
    func toRealmObjectV2() -> RecordingRealmObjectV2 {
        let (date, timeOfDay, regionalSpotCount) = realmObjectConversionParts()
        let o = RecordingRealmObjectV2()
        o.id = id
        o.date = date
        o.timeOfDay = timeOfDay.rawValue
        o.foreheadLeft = regionalSpotCount.get(.forehead).left
        o.foreheadRight = regionalSpotCount.get(.forehead).right
        o.eyebrowsLeft = regionalSpotCount.get(.eyebrows).left
        o.eyebrowsRight = regionalSpotCount.get(.eyebrows).right
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

    static func fromRealmObjectV2(_ r: RecordingRealmObjectV2) -> Recording {
        let regionalSpotCount: RegionalSpotCount = RegionalSpotCount()
        regionalSpotCount.put(region: .forehead, left: r.foreheadLeft, right: r.foreheadRight)
        regionalSpotCount.put(region: .eyebrows, left: r.eyebrowsLeft, right: r.eyebrowsRight)
        regionalSpotCount.put(region: .cheek, left: r.cheekLeft, right: r.cheekRight)
        regionalSpotCount.put(region: .jawline, left: r.jawlineLeft, right: r.jawlineRight)
        regionalSpotCount.put(region: .nose, left: r.noseLeft, right: r.noseRight)
        regionalSpotCount.put(region: .mouth, left: r.mouthLeft, right: r.mouthRight)
        regionalSpotCount.put(region: .chin, left: r.chinLeft, right: r.chinRight)
        let timeOfDay: TimeOfDay = TimeOfDay.init(rawValue: r.timeOfDay)!
        return Recording(r.id, r.date, timeOfDay, regionalSpotCount)
    }

    func toJsonV2() -> String {
        let encodedData = try! JSONEncoder().encode(toRealmObjectV2())
        return String(data: encodedData, encoding: .utf8)!
    }

    static func fromJsonV2(_ json: String) -> Recording {
        let dataFromJsonString = json.data(using: .utf8)!
        let realmObjectV2 = try! JSONDecoder().decode(RecordingRealmObjectV2.self, from: dataFromJsonString)
        return Recording.fromRealmObjectV2(realmObjectV2)
    }
}

extension VersionedRecordingRealmStorage {
    func readAllV2(_ realm: Realm) -> Results<RecordingRealmObjectV2> {
        realm.objects(RecordingRealmObjectV2.self)
    }
}
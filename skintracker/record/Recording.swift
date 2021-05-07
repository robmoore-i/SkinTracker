//
// Created by Rob on 6/5/21.
//

import Foundation

class Recording: CustomStringConvertible, Identifiable {
    private let date: Date
    private let timeOfDay: TimeOfDay
    private let regionalSpotCounts: [FaceRegion: (left: Int, right: Int)]

    init(_ date: Date, _ timeOfDay: TimeOfDay, _ regionalSpotCounts: [FaceRegion: (left: Int, right: Int)]) {
        self.date = date
        self.timeOfDay = timeOfDay
        self.regionalSpotCounts = regionalSpotCounts
    }

    var description: String {
        "Recording(date: \(date), timeOfDay: \(timeOfDay), regionalSpotCounts: \(regionalSpotCounts))"
    }

    var id: Date {
        date
    }
}

import RealmSwift

class RecordingRealmObjectV1: Object {
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
        let o = RecordingRealmObjectV1()
        o.id = UUID().hashValue
        o.date = date
        o.timeOfDay = timeOfDay.rawValue
        o.foreheadLeft = regionalSpotCounts[.forehead]?.left ?? 0
        o.foreheadRight = regionalSpotCounts[.forehead]?.right ?? 0
        o.eyeLeft = regionalSpotCounts[.eye]?.left ?? 0
        o.eyeRight = regionalSpotCounts[.eye]?.right ?? 0
        o.cheekLeft = regionalSpotCounts[.cheek]?.left ?? 0
        o.cheekRight = regionalSpotCounts[.cheek]?.right ?? 0
        o.jawlineLeft = regionalSpotCounts[.jawline]?.left ?? 0
        o.jawlineRight = regionalSpotCounts[.jawline]?.right ?? 0
        o.noseLeft = regionalSpotCounts[.nose]?.left ?? 0
        o.noseRight = regionalSpotCounts[.nose]?.right ?? 0
        o.mouthLeft = regionalSpotCounts[.mouth]?.left ?? 0
        o.mouthRight = regionalSpotCounts[.mouth]?.right ?? 0
        o.chinLeft = regionalSpotCounts[.chin]?.left ?? 0
        o.chinRight = regionalSpotCounts[.chin]?.right ?? 0
        return o
    }

    static func fromRealmObjectV1(_ r: RecordingRealmObjectV1) -> Recording {
        var regionalSpotCounts: [FaceRegion: (left: Int, right: Int)] = [:]
        regionalSpotCounts[.forehead] = (left: r.foreheadLeft, right: r.foreheadRight)
        regionalSpotCounts[.eye] = (left: r.eyeLeft, right: r.eyeRight)
        regionalSpotCounts[.cheek] = (left: r.cheekLeft, right: r.cheekRight)
        regionalSpotCounts[.jawline] = (left: r.jawlineLeft, right: r.jawlineRight)
        regionalSpotCounts[.nose] = (left: r.noseLeft, right: r.noseRight)
        regionalSpotCounts[.mouth] = (left: r.mouthLeft, right: r.mouthRight)
        regionalSpotCounts[.chin] = (left: r.chinLeft, right: r.chinRight)
        let timeOfDay: TimeOfDay = TimeOfDay.init(rawValue: r.timeOfDay)!
        return Recording(r.date, timeOfDay, regionalSpotCounts)
    }
}
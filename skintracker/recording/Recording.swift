//
// Created by Rob on 6/5/21.
//

import Foundation
import SwiftDate

class Recording: CustomStringConvertible, Identifiable, Hashable, Comparable {
    let id: Int

    private let date: Date
    private let timeOfDay: TimeOfDay
    private let regionalSpotCount: RegionalSpotCount

    convenience init(_ date: Date, _ timeOfDay: TimeOfDay, _ regionalSpotCount: RegionalSpotCount) {
        self.init(UUID().hashValue, date, timeOfDay, regionalSpotCount)
    }

    init(_ id: Int, _ date: Date, _ timeOfDay: TimeOfDay, _ regionalSpotCount: RegionalSpotCount) {
        self.id = id
        self.date = date
        self.timeOfDay = timeOfDay
        self.regionalSpotCount = regionalSpotCount
    }

    var description: String {
        "Recording(id: \(id), date: \(date), timeOfDay: \(timeOfDay), regionalSpotCounts: \(regionalSpotCount))"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(timeOfDay)
        hasher.combine(regionalSpotCount)
    }

    static func ==(lhs: Recording, rhs: Recording) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.date != rhs.date {
            return false
        }
        if lhs.timeOfDay != rhs.timeOfDay {
            return false
        }
        if rhs.regionalSpotCount != lhs.regionalSpotCount {
            return false
        }
        return true
    }

    /**
     Interpretation: R1 < R2 <=> R1 is for an earlier date/time than R2.
     */
    static func <(lhs: Recording, rhs: Recording) -> Bool {
        if (lhs.date.year < rhs.date.year) {
            return true
        }
        if (lhs.date.year == rhs.date.year
                && lhs.date.month < rhs.date.month) {
            return true
        }
        if (lhs.date.year == rhs.date.year
                && lhs.date.month == rhs.date.month
                && lhs.date.day < rhs.date.day) {
            return true
        }
        if (lhs.date.year == rhs.date.year
                && lhs.date.month == rhs.date.month
                && lhs.date.day == rhs.date.day
                && lhs.timeOfDay == .am && rhs.timeOfDay == .pm) {
            return true
        }
        return false
    }

    /**
      For the user's timezone, if the date of this instance is the same as the date given, and the time of day of this
      instance is the same as the time of day given, then true. Otherwise false.
     */
    func isFor(date: Date, time: TimeOfDay) -> Bool {
        let convertedDate = date.convertTo(region: self.date.region)
        return self.date.year == convertedDate.year
                && self.date.month == convertedDate.month
                && self.date.day == convertedDate.day
                && isFor(time: time)
    }

    func isFor(time: TimeOfDay) -> Bool {
        timeOfDay == time
    }

    func dateDescription() -> String {
        "\(date.weekdayName(.short)) \(date.ordinalDay) \(date.month) \(date.year)"
    }

    func spotsShortDescription() -> String {
        let mostAffectedRegions = regionalSpotCount.mostAffectedRegions()
        if mostAffectedRegions.isEmpty {
            return "Clear"
        } else {
            return "Total: \(regionalSpotCount.totalSpots()) , Most affected: \(mostAffectedRegions)"
        }
    }

    static let chronologicalSortCriteria: (Recording, Recording) -> Bool = { recording1, recording2 in
        recording1 > recording2
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
        o.id = id
        o.date = date
        o.timeOfDay = timeOfDay.rawValue
        o.foreheadLeft = regionalSpotCount.get(.forehead).left
        o.foreheadRight = regionalSpotCount.get(.forehead).right
        o.eyeLeft = regionalSpotCount.get(.eye).left
        o.eyeRight = regionalSpotCount.get(.eye).right
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
        regionalSpotCount.put(region: .eye, left: r.eyeLeft, right: r.eyeRight)
        regionalSpotCount.put(region: .cheek, left: r.cheekLeft, right: r.cheekRight)
        regionalSpotCount.put(region: .jawline, left: r.jawlineLeft, right: r.jawlineRight)
        regionalSpotCount.put(region: .nose, left: r.noseLeft, right: r.noseRight)
        regionalSpotCount.put(region: .mouth, left: r.mouthLeft, right: r.mouthRight)
        regionalSpotCount.put(region: .chin, left: r.chinLeft, right: r.chinRight)
        let timeOfDay: TimeOfDay = TimeOfDay.init(rawValue: r.timeOfDay)!
        return Recording(r.id, r.date, timeOfDay, regionalSpotCount)
    }
}
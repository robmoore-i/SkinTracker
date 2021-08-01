//
// Created by Rob on 6/5/21.
//

import Foundation
import SwiftDate

class Recording: CustomStringConvertible, Identifiable, Hashable, Comparable {
    let id: Int
    var recordingTime: RecordingTime

    // TODO: Pull out RecordingTime class and shift date-related responsibilities to it
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
        self.recordingTime = RecordingTime(date, timeOfDay)
        self.regionalSpotCount = regionalSpotCount
    }

    var description: String {
        "Recording(id: \(id), time: \(recordingTime), regionalSpotCounts: \(regionalSpotCount))"
    }

    func spotCount(forRegion region: FaceRegion) -> (left: Int, right: Int) {
        regionalSpotCount.get(region)
    }

    func withImposedSpotCounts(_ selectedSpotCount: RegionalSpotCount) -> Recording {
        Recording(date, timeOfDay, selectedSpotCount.imposedOnto(regionalSpotCount))
    }

    func totalSpotCount() -> Int {
        regionalSpotCount.totalSpots()
    }

    func mostAffectedRegions() -> [String] {
        regionalSpotCount.mostAffectedRegions()
    }

    static let chronologicalSortCriteria: (Recording, Recording) -> Bool = { recording1, recording2 in
        recording1 > recording2
    }

    /**
      This method exposes the internal data of the class. This is given in a clearly named
      method in order to make it clear that the purpose of this is to enable serialization
      into Realm objects, and certainly not for anything else.
     */
    func realmObjectConversionParts() -> (Date, TimeOfDay, RegionalSpotCount) {
        let timeParts = recordingTime.realmObjectConversionParts()
        return (timeParts.0, timeParts.1, regionalSpotCount)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(recordingTime)
        hasher.combine(regionalSpotCount)
    }

    static func ==(lhs: Recording, rhs: Recording) -> Bool {
        if lhs === rhs {
            return true
        }
        return differenceDescription(lhs, rhs) == nil
    }

    /**
     Interpretation: R1 < R2 <=> R1 is an earlier recording than R2.
     */
    static func <(lhs: Recording, rhs: Recording) -> Bool {
        lhs.recordingTime < rhs.recordingTime
    }

    static func differenceDescription(_ lhs: Recording, _ rhs: Recording) -> String? {
        if type(of: lhs) != type(of: rhs) {
            return "Type mismatch. Lhs: \(type(of: lhs)) , Rhs: \(type(of: rhs))"
        }
        if lhs.id != rhs.id {
            return "Id mismatch. Lhs: \(lhs.id) , Rhs: \(rhs.id)"
        }
        if (lhs.recordingTime != rhs.recordingTime) {
            return "RecordingTime mismatch. \(String(describing: RecordingTime.differenceDescription(lhs.recordingTime, rhs.recordingTime)))"
        }
        if rhs.regionalSpotCount != lhs.regionalSpotCount {
            return "RegionalSpotCount mismatch. Lhs: \(lhs.regionalSpotCount) , Rhs: \(rhs.regionalSpotCount)"
        }
        return nil
    }
}

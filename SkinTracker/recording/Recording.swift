//
// Created by Rob on 6/5/21.
//

import Foundation

class Recording: CustomStringConvertible, Identifiable, Hashable {
    let id: Int
    var recordingTime: RecordingTime

    private let regionalSpotCount: RegionalSpotCount

    convenience init(_ recordingTime: RecordingTime, _ regionalSpotCount: RegionalSpotCount) {
        self.init(UUID().hashValue, recordingTime, regionalSpotCount)
    }

    init(_ id: Int, _ recordingTime: RecordingTime, _ regionalSpotCount: RegionalSpotCount) {
        self.id = id
        self.recordingTime = recordingTime
        self.regionalSpotCount = regionalSpotCount
    }

    var description: String {
        "Recording{id: \(id), time: \(recordingTime), regionalSpotCounts: \(regionalSpotCount)}"
    }

    func spotCount(forRegion region: FaceRegion) -> (left: Int, right: Int) {
        regionalSpotCount.get(region)
    }

    func withImposedSpotCounts(_ selectedSpotCount: RegionalSpotCount) -> Recording {
        Recording(recordingTime, selectedSpotCount.imposedOnto(regionalSpotCount))
    }

    func totalSpotCount() -> Int {
        regionalSpotCount.totalSpots()
    }

    func mostAffectedRegions() -> [String] {
        regionalSpotCount.mostAffectedRegions()
    }

    static let chronologicalSortCriteria: (Recording, Recording) -> Bool = { recording1, recording2 in
        recording1.recordingTime > recording2.recordingTime
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

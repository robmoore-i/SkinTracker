//
// Created by Rob on 7/5/21.
//

import Foundation

class RegionalSpotCount: Equatable, Hashable, CustomStringConvertible {
    private var map: [FaceRegion: (left: Int?, right: Int?)] = [:]

    init() {
        FaceRegion.allCases.forEach { region in
            map[region] = (left: nil, right: nil)
        }
    }

    private init(_ map: [FaceRegion: (left: Int?, right: Int?)]) {
        self.map = map
    }

    func get(_ region: FaceRegion) -> (left: Int, right: Int) {
        (left: map[region]?.left ?? 0, right: map[region]?.right ?? 0)
    }

    func put(region: FaceRegion, left: Int, right: Int) {
        map[region]?.left = left
        map[region]?.right = right
    }

    func put(region: FaceRegion, left: Int) {
        map[region]?.left = left
    }

    func put(region: FaceRegion, right: Int) {
        map[region]?.right = right
    }

    func delete(leftEntryFor: FaceRegion) {
        map[leftEntryFor]?.left = nil
    }

    func delete(rightEntryFor: FaceRegion) {
        map[rightEntryFor]?.right = nil
    }

    /**
     Impose the non-nil values of this map onto the values of the other map, and return the result.
     */
    func imposedOnto(_ other: RegionalSpotCount) -> RegionalSpotCount {
        var map: [FaceRegion: (left: Int?, right: Int?)] = [:]
        FaceRegion.allCases.forEach { region in
            map[region] = (
                    left: self.map[region]?.left ?? other.map[region]?.left,
                    right: self.map[region]?.right ?? other.map[region]?.right)
        }
        return RegionalSpotCount(map)
    }

    func totalSpots() -> Int {
        map.values.map { pair in
            (pair.left ?? 0) + (pair.right ?? 0)
        }.reduce(0) { (result: Int, next: Int) -> Int in
            result + next
        }
    }

    func mostAffectedRegions() -> [String] {
        var realisedMap: [FaceRegion: (left: Int, right: Int)] = [:]
        FaceRegion.allCases.forEach { region in
            realisedMap[region] = (left: map[region]?.left ?? 0, right: map[region]?.right ?? 0)
        }
        return realisedMap.reduce((n: 1, regionDescriptions: [])) {
            (result: (n: Int, regionDescriptions: [String]),
             tuple: (key: FaceRegion, value: (left: Int, right: Int))) -> (n: Int, regionDescriptions: [String]) in
            var nextResult = result
            if tuple.value.left > nextResult.n {
                nextResult.n = tuple.value.left
                nextResult.regionDescriptions = [regionDescription(side: "left", region: tuple.key)]
            } else if tuple.value.left == nextResult.n {
                nextResult.regionDescriptions.append(regionDescription(side: "left", region: tuple.key))
            }
            if tuple.value.right > nextResult.n {
                nextResult.n = tuple.value.right
                nextResult.regionDescriptions = [regionDescription(side: "right", region: tuple.key)]
            } else if tuple.value.right == nextResult.n {
                nextResult.regionDescriptions.append(regionDescription(side: "right", region: tuple.key))
            }
            return nextResult
        }.regionDescriptions
    }

    /**
     The String returned by this function is a description of this specific part of the face. It must contain the
     `rawValue` of the associated FaceRegion, `region`.
     */
    private func regionDescription(side: String, region: FaceRegion) -> String {
        if ([FaceRegion.cheek, FaceRegion.jawline].contains(region)) {
            return "\(side.capitalized) \(region.rawValue)"
        } else if ([FaceRegion.mouth, FaceRegion.chin, FaceRegion.jawline, FaceRegion.forehead, FaceRegion.nose].contains(region)) {
            return "\(side.capitalized) side of \(region.rawValue)"
        } else {
            return "\(region.rawValue.capitalized) \(side)"
        }
    }

    var description: String {
        var d = "RegionalSpotCount("
        FaceRegion.allCases.forEach { region in
            d.append("[\(region): (\(map[region]?.left?.description ?? "nil"), \(map[region]?.right?.description ?? "nil"))],")
        }
        return "\(d))"
    }

    func hash(into hasher: inout Hasher) {
        FaceRegion.allCases.forEach { region in
            hasher.combine(map[region]?.left)
            hasher.combine(map[region]?.right)
        }
    }

    static func ==(lhs: RegionalSpotCount, rhs: RegionalSpotCount) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        return FaceRegion.allCases.allSatisfy({ region in
            let rhsRegion = rhs.map[region]
            let lhsRegion = lhs.map[region]
            return rhsRegion?.left == lhsRegion?.left && rhsRegion?.right == lhsRegion?.right
        })
    }
}
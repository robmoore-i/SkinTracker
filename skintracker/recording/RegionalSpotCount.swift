//
// Created by Rob on 7/5/21.
//

import Foundation

class RegionalSpotCount: Equatable, Hashable, CustomStringConvertible {
    private var map: [FaceRegion: (left: Int, right: Int)] = [:]

    init() {
        FaceRegion.allCases.forEach { region in
            map[region] = (left: 0, right: 0)
        }
    }

    func get(_ region: FaceRegion) -> (left: Int, right: Int) {
        map[region] ?? (left: 0, right: 0)
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

    func totalSpots() -> Int {
        map.values.map { pair in
            pair.left + pair.right
        }.reduce(0) { (result: Int, next: Int) -> Int in
            result + next
        }
    }

    func mostAffectedRegions() -> [String] {
        map.reduce((n: 1, regionDescriptions: [])) {
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

    private func regionDescription(side: String, region: FaceRegion) -> String {
        if ([.cheek, .eye].contains(region)) {
            return "\(side.capitalized) \(region.rawValue)"
        } else if ([.mouth, .chin, .jawline, .forehead, .nose].contains(region)) {
            return "\(side.capitalized) side of \(region.rawValue)"
        } else {
            return "\(region.rawValue.capitalized) \(side)"
        }
    }

    var description: String {
        "RegionalSpotCount(map: \(map))"
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
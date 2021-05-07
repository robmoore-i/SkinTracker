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
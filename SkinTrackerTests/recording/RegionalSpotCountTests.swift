//
// Created by Rob on 24/5/21.
//

import XCTest
@testable import SkinTracker

class RegionalSpotCountTests: XCTestCase {
    func testEverythingStartsZeroed() throws {
        let r = RegionalSpotCount()
        FaceRegion.allCases.forEach { region in
            XCAssertEqualCounts(expected: (left: 0, right: 0), actual: r.get(region))
        }
    }

    func testPutValuesIn() throws {
        let r = RegionalSpotCount()
        r.put(region: .cheek, left: 5)
        XCAssertEqualCounts(expected: (left: 5, right: 0), actual: r.get(.cheek))
        r.put(region: .jawline, right: 1)
        XCAssertEqualCounts(expected: (left: 0, right: 1), actual: r.get(.jawline))
        r.put(region: .forehead, left: 2, right: 4)
        XCAssertEqualCounts(expected: (left: 2, right: 4), actual: r.get(.forehead))
        XCAssertEqualCounts(expected: (left: 0, right: 0), actual: r.get(.nose))
    }

    func testCountTotalSpots() throws {
        let r = RegionalSpotCount()
        r.put(region: .cheek, left: 5)
        r.put(region: .jawline, right: 1)
        r.put(region: .forehead, left: 2, right: 4)
        XCTAssertEqual(12, r.totalSpots())
    }

    func testDetermineMostAffectedRegions() throws {
        let r = RegionalSpotCount()
        r.put(region: .cheek, left: 5)
        r.put(region: .jawline, right: 1)
        r.put(region: .forehead, left: 2, right: 5)
        let actual = r.mostAffectedRegions()
        XCTAssert(actual.contains("Left cheek"))
        XCTAssert(actual.contains("Right side of forehead"))
    }

    func testMergingTogether() throws {
        let r1 = RegionalSpotCount()
        r1.put(region: .cheek, left: 5)
        r1.put(region: .eyebrows, left: 3)
        r1.put(region: .jawline, right: 1)
        r1.put(region: .forehead, left: 6)
        r1.delete(leftEntryFor: .forehead)

        let r2 = RegionalSpotCount()
        r2.put(region: .cheek, left: 4, right: 1)
        r2.put(region: .eyebrows, left: 1)
        r2.put(region: .forehead, left: 2, right: 5)

        let r3 = r1.imposedOnto(r2)
        print("\(r1)")
        print("\(r2)")
        print("\(r3)")

        XCAssertEqualCounts(expected: (left: 5, right: 1), actual: r3.get(.cheek))
        XCAssertEqualCounts(expected: (left: 3, right: 0), actual: r3.get(.eyebrows))
        XCAssertEqualCounts(expected: (left: 0, right: 1), actual: r3.get(.jawline))
        XCAssertEqualCounts(expected: (left: 2, right: 5), actual: r3.get(.forehead))
    }

    private func XCAssertEqualCounts(expected: (left: Int, right: Int), actual: (left: Int, right: Int)) {
        XCTAssertEqual(expected.left, actual.left)
        XCTAssertEqual(expected.right, actual.right)
    }
}
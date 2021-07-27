//
// Created by Rob on 7/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingListDateRangeTests: XCTestCase {
    func testEmptyListDateRange() {
        let range = [].dateRange()
        let arbitraryDate = Date(year: 2021, month: 7, day: 28, hour: 12, minute: 0)
        let emptyRange = arbitraryDate..<arbitraryDate
        XCTAssert(range.isEmpty)
        XCTAssert(!range.contains(arbitraryDate))
        XCTAssertEqual(emptyRange, range)
    }

    func testSingletonListDateRange() {
        let arbitraryDate = Date(year: 2021, month: 7, day: 28, hour: 12, minute: 0)
        let range = [Recording(arbitraryDate, .am, RegionalSpotCount())].dateRange()
        let convertedDate = Date(year: 2021, month: 7, day: 28, hour: 7, minute: 0, region: Region.current)
        let singletonRange = convertedDate..<(convertedDate + 1.days)
        XCTAssert(!range.isEmpty)
        XCTAssert(range.contains(convertedDate))
        XCTAssert(!range.contains(convertedDate + 1.days))
        XCTAssertEqual(singletonRange, range)
    }
}
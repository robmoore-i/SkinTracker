//
// Created by Rob on 11/7/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingIsInLastTests: XCTestCase {
    func testRecordingIsInLastRange() throws {
        let presentDate = Date(year: 2021, month: 7, day: 13, hour: 13, minute: 23)
        let recordingDate = Date(year: 2021, month: 7, day: 11, hour: 13, minute: 23)
        let recording = Recording(recordingDate, .am, RegionalSpotCount())
        XCTAssert(recording.isInLast(numberOfDays: 5, beforeDate: presentDate))
    }

    func testRecordingIsNotInLastRange() throws {
        let presentDate = Date(year: 2021, month: 7, day: 20, hour: 13, minute: 23)
        let recordingDate = Date(year: 2021, month: 7, day: 11, hour: 13, minute: 23)
        let recording = Recording(recordingDate, .am, RegionalSpotCount())
        XCTAssert(!recording.isInLast(numberOfDays: 5, beforeDate: presentDate))
    }

    func testWorksForTwoWeekTimePeriod() throws {
        let presentDate = Date(year: 2021, month: 7, day: 20, hour: 13, minute: 23)
        let recordingDate = Date(year: 2021, month: 7, day: 11, hour: 13, minute: 23)
        let recording = Recording(recordingDate, .am, RegionalSpotCount())
        XCTAssert(recording.isInLast(numberOfDays: 14, beforeDate: presentDate))
    }

    func testIncludesTheFarthestBackDayInTimeRange() throws {
        let presentDate = Date(year: 2021, month: 7, day: 11, hour: 13, minute: 40)
        let recordingDate = Date(year: 2021, month: 6, day: 27, hour: 8, minute: 15)
        let recording = Recording(recordingDate, .am, RegionalSpotCount())
        XCTAssert(recording.isInLast(numberOfDays: 14, beforeDate: presentDate))
    }

    func testExcludesTheFirstTooFarBackDayInTimeRange() throws {
        let presentDate = Date(year: 2021, month: 7, day: 11, hour: 13, minute: 40)
        let recordingDate = Date(year: 2021, month: 6, day: 26, hour: 23, minute: 15)
        let recording = Recording(recordingDate, .pm, RegionalSpotCount())
        XCTAssert(!recording.isInLast(numberOfDays: 14, beforeDate: presentDate))
    }

    func testCurrentDateIsIncludedInLastTimeRange() throws {
        let presentDate = Date(year: 2021, month: 7, day: 11, hour: 13, minute: 40)
        let recordingDate = Date(year: 2021, month: 7, day: 11, hour: 10, minute: 15)
        let recording = Recording(recordingDate, .am, RegionalSpotCount())
        XCTAssert(recording.isInLast(numberOfDays: 14, beforeDate: presentDate))
    }
}
//
// Created by Rob on 9/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingTimeLessThanTests: XCTestCase {
    func testRecordingComparisonUsesYear() throws {
        let t1 = RecordingTimeFactory.get(year: 2020)
        let t2 = RecordingTimeFactory.get(year: 2021)
        XCTAssert(t1 < t2)
    }

    func testRecordingComparisonUsesMonth() throws {
        let t1 = RecordingTimeFactory.get(month: 4)
        let t2 = RecordingTimeFactory.get(month: 5)
        XCTAssert(t1 < t2)
    }

    func testRecordingComparisonIgnoresMonthForDifferentYear() throws {
        let t1 = RecordingTimeFactory.get(year: 2020, month: 12)
        let t2 = RecordingTimeFactory.get(year: 2021, month: 1)
        XCTAssert(t1 < t2)
    }

    func testRecordingComparisonUsesDay() throws {
        let t1 = RecordingTimeFactory.get(day: 5)
        let t2 = RecordingTimeFactory.get(day: 20)
        XCTAssert(t1 < t2)
    }

    func testRecordingComparisonUsesTimeOfDay() throws {
        let t1 = RecordingTimeFactory.get(timeOfDay: .am)
        let t2 = RecordingTimeFactory.get(timeOfDay: .pm)
        XCTAssert(t1 < t2)
    }

    func testEqualRecordingsAreNotLessThan() throws {
        let t1 = RecordingTimeFactory.get()
        let t2 = RecordingTimeFactory.get()
        XCTAssert(!(t1 < t2))
        XCTAssert(!(t1 > t2))
    }

    func testWorksForDaysWhoseDateVariesAcrossTimezones() throws {
        let t1 = RecordingTimeFactory.get(day: 13, hour: 2, timeOfDay: .am, timezone: Zones.australiaBrisbane)
        let t2 = RecordingTimeFactory.get(day: 12, hour: 22, timeOfDay: .pm, timezone: Zones.gmt)
        XCTAssert(t1 < t2)
    }

    func testWorksWhenMorningRecordingIsAddedAfterEveningRecording() throws {
        let t1 = RecordingTimeFactory.get(month: 7, day: 16, hour: 11, timeOfDay: .am, timezone: Zones.asiaSingapore)
        let t2 = RecordingTimeFactory.get(month: 7, day: 16, hour: 0, timeOfDay: .pm, timezone: Zones.asiaSingapore)
        XCTAssert(t1 < t2)
    }

    func testDatesInGmt() throws {
        let t1 = RecordingTimeFactory.get(month: 7, day: 14, hour: 15, timeOfDay: .pm, timezone: Zones.gmt)
        let t2 = RecordingTimeFactory.get(month: 7, day: 16, hour: 3, timeOfDay: .am, timezone: Zones.gmt)
        XCTAssert(t1 < t2)
    }
}
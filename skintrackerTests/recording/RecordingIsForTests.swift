//
// Created by Rob on 7/5/21.
//

import XCTest
import SwiftDate
@testable import skintracker

class RecordingIsForTests: XCTestCase {
    let GMT = Region(zone: TimeZone(abbreviation: "GMT")!)

    func testRecordingMatchesOwnDate() throws {
        let date = Date(year: 2021, month: 5, day: 7, hour: 3, minute: 29, second: 45, region: GMT)
        let recording = Recording(date, .am, RegionalSpotCount())
        XCTAssert(recording.isFor(date: date, time: .am))
    }

    func testRecordingUsesTimezone() throws {
        let gmtDate = Date(year: 2021, month: 5, day: 7, hour: 11, minute: 45, second: 45, region: GMT)
        let recording = Recording(gmtDate, .am, RegionalSpotCount())
        let sgtDate = Date(year: 2021, month: 5, day: 8, hour: 6, minute: 29, second: 45, region: Region(zone: TimeZone(abbreviation: "SGT")!))
        XCTAssert(recording.isFor(date: sgtDate, time: .am))
    }

    func testRecordingDoesntMatchWayOutDays() throws {
        let date = Date(year: 2021, month: 5, day: 7, hour: 7, minute: 45, second: 45, region: GMT)
        let recording = Recording(date, .am, RegionalSpotCount())
        let tooEarly = Date(year: 2021, month: 5, day: 6, hour: 11, minute: 29, second: 45, region: GMT)
        let tooLate = Date(year: 2021, month: 5, day: 8, hour: 8, minute: 29, second: 45, region: GMT)
        XCTAssert(!recording.isFor(date: tooEarly, time: .am))
        XCTAssert(!recording.isFor(date: tooLate, time: .am))
    }

    func testRecordingChecksTimeOfDay() throws {
        let date = Date(year: 2021, month: 5, day: 7, hour: 7, minute: 45, second: 45, region: GMT)
        let recording = Recording(date, .am, RegionalSpotCount())
        let similarTime = Date(year: 2021, month: 5, day: 7, hour: 12, minute: 29, second: 45, region: GMT)
        XCTAssert(!recording.isFor(date: similarTime, time: .pm))
    }
}
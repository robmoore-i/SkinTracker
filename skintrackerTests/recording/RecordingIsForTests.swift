//
// Created by Rob on 7/5/21.
//

import XCTest
import SwiftDate
@testable import skintracker

class RecordingIsForTests: XCTestCase {
    func testRecordingMatchesOwnDate() throws {
        let date = Date(year: 2021, month: 5, day: 7, hour: 3, minute: 29)
        let recording = Recording(date, .am, RegionalSpotCount())
        XCTAssert(recording.isFor(date: date, time: .am))
    }

    func testRecordingDoesntMatchWayOutDays() throws {
        let date = Date(year: 2021, month: 5, day: 7, hour: 7, minute: 45)
        let recording = Recording(date, .am, RegionalSpotCount())
        let tooEarly = Date(year: 2021, month: 5, day: 6, hour: 11, minute: 29)
        let tooLate = Date(year: 2021, month: 5, day: 8, hour: 8, minute: 29)
        XCTAssert(!recording.isFor(date: tooEarly, time: .am))
        XCTAssert(!recording.isFor(date: tooLate, time: .am))
    }

    func testRecordingChecksTimeOfDay() throws {
        let date = Date(year: 2021, month: 5, day: 7, hour: 7, minute: 45)
        let recording = Recording(date, .am, RegionalSpotCount())
        let similarTime = Date(year: 2021, month: 5, day: 7, hour: 12, minute: 29)
        XCTAssert(!recording.isFor(date: similarTime, time: .pm))
    }

    func testSingaporeTimezoneWorksOk() throws {
        let singaporeMorning = Date(year: 2021, month: 5, day: 10, hour: 23, minute: 45)
        let morningRecording = Recording(singaporeMorning, .am, RegionalSpotCount())
        let singaporePreviousMorning = Date(year: 2021, month: 5, day: 10, hour: 1, minute: 15)
        XCTAssert(!morningRecording.isFor(date: singaporePreviousMorning, time: .am))
    }
}
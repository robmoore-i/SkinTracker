//
// Created by Rob on 7/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

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

    private func t(_ day: Int, _ hour: Int) -> Date {
        Date(year: 2021, month: 5, day: day, hour: hour, minute: 35)
    }

    /** This test gathers the different possible representations of a few adjacent dates, in terms of their day number
     and hour in GMT, and it validates that only dates that represent the same actual day, are considered matching. It
     currently passes, which makes me think it's definitely useless, but let's see if I still have this bug tomorrow
     morning. */
    func testSingaporeTimezone() throws {
        let x__ = 9
        let _x_ = 10
        let __x = 11
        let am = 23 // For those made early in Singapore
        let pm = 13 // For those made later in Singapore

        let xMinusOne = [t(x__, pm)]
        let x = [t(x__, am), t(_x_, pm)]
        let xPlusOne = [t(_x_, am), t(__x, pm)]

        for representativeDate in xMinusOne {
            let amRecording = Recording(representativeDate, .am, RegionalSpotCount())
            let pmRecording = Recording(representativeDate, .pm, RegionalSpotCount())
            for matchingDate in xMinusOne {
                XCTAssert(amRecording.isFor(date: matchingDate, time: .am))
                XCTAssert(!amRecording.isFor(date: matchingDate, time: .pm))
                XCTAssert(!pmRecording.isFor(date: matchingDate, time: .am))
                XCTAssert(pmRecording.isFor(date: matchingDate, time: .pm))
            }
            for nonMatchingDate in x + xPlusOne {
                XCTAssert(!amRecording.isFor(date: nonMatchingDate, time: .am))
                XCTAssert(!amRecording.isFor(date: nonMatchingDate, time: .pm))
                XCTAssert(!pmRecording.isFor(date: nonMatchingDate, time: .am))
                XCTAssert(!pmRecording.isFor(date: nonMatchingDate, time: .pm))
            }
        }

        for representativeDate in x {
            let amRecording = Recording(representativeDate, .am, RegionalSpotCount())
            let pmRecording = Recording(representativeDate, .pm, RegionalSpotCount())
            for nonMatchingDate in xMinusOne + xPlusOne {
                XCTAssert(!amRecording.isFor(date: nonMatchingDate, time: .am))
                XCTAssert(!amRecording.isFor(date: nonMatchingDate, time: .pm))
                XCTAssert(!pmRecording.isFor(date: nonMatchingDate, time: .am))
                XCTAssert(!pmRecording.isFor(date: nonMatchingDate, time: .pm))
            }
            for matchingDate in x {
                XCTAssert(amRecording.isFor(date: matchingDate, time: .am))
                XCTAssert(!amRecording.isFor(date: matchingDate, time: .pm))
                XCTAssert(!pmRecording.isFor(date: matchingDate, time: .am))
                XCTAssert(pmRecording.isFor(date: matchingDate, time: .pm))
            }
        }

        for representativeDate in xPlusOne {
            let amRecording = Recording(representativeDate, .am, RegionalSpotCount())
            let pmRecording = Recording(representativeDate, .pm, RegionalSpotCount())
            for nonMatchingDate in xMinusOne + x {
                XCTAssert(!amRecording.isFor(date: nonMatchingDate, time: .am))
                XCTAssert(!amRecording.isFor(date: nonMatchingDate, time: .pm))
                XCTAssert(!pmRecording.isFor(date: nonMatchingDate, time: .am))
                XCTAssert(!pmRecording.isFor(date: nonMatchingDate, time: .pm))
            }
            for matchingDate in xPlusOne {
                XCTAssert(amRecording.isFor(date: matchingDate, time: .am))
                XCTAssert(!amRecording.isFor(date: matchingDate, time: .pm))
                XCTAssert(!pmRecording.isFor(date: matchingDate, time: .am))
                XCTAssert(pmRecording.isFor(date: matchingDate, time: .pm))
            }
        }
    }
}
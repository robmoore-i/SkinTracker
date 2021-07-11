//
// Created by Rob on 9/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingLessThanTests: XCTestCase {
    func testRecordingComparisonUsesYear() throws {
        let recording1 = recordingOn(year: 2020)
        let recording2 = recordingOn(year: 2021)
        XCTAssert(recording1 < recording2)
    }

    func testRecordingComparisonUsesMonth() throws {
        let recording1 = recordingOn(month: 4)
        let recording2 = recordingOn(month: 5)
        XCTAssert(recording1 < recording2)
    }

    func testRecordingComparisonIgnoresMonthForDifferentYear() throws {
        let recording1 = recordingOn(year: 2020, month: 12)
        let recording2 = recordingOn(year: 2021, month: 1)
        XCTAssert(recording1 < recording2)
    }

    func testRecordingComparisonUsesDay() throws {
        let recording1 = recordingOn(day: 5)
        let recording2 = recordingOn(day: 20)
        XCTAssert(recording1 < recording2)
    }

    func testRecordingComparisonUsesTimeOfDay() throws {
        let recording1 = recordingOn(timeOfDay: .am)
        let recording2 = recordingOn(timeOfDay: .pm)
        XCTAssert(recording1 < recording2)
    }

    func testEqualRecordingsAreNotLessThan() throws {
        let recording1 = recordingOn()
        let recording2 = recordingOn()
        XCTAssert(!(recording1 < recording2))
        XCTAssert(!(recording1 > recording2))
    }

    func testWorksForDaysWhoseDateVariesAcrossTimezones() throws {
        let recording1 = recordingOn(day: 13, hour: 2, timeOfDay: .am, timezone: Zones.australiaBrisbane)
        let recording2 = recordingOn(day: 12, hour: 22, timeOfDay: .pm, timezone: Zones.gmt)
        XCTAssert(recording1 < recording2)
    }

    private func recordingOn(year: Int = 2021, month: Int = 1, day: Int = 1, hour: Int = 1, timeOfDay: TimeOfDay = .am, timezone: ZoneConvertible = Zones.gmt) -> Recording {
        Recording(Date(year: year, month: month, day: day, hour: hour, minute: 15, region: Region(zone: timezone)), timeOfDay, RegionalSpotCount())
    }
}
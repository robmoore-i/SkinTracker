//
// Created by Rob on 31/7/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingTimeEquatableTests: XCTestCase {
    func testInstanceEqualsItself() throws {
        let t = recordingTime()
        XCTAssert(t == t)
    }

    func testInstancesCanBeEqualWithDifferentHour() throws {
        let t1 = recordingTime(hour: 9)
        let t2 = recordingTime(hour: 10)
        XCTAssert(t1 == t2)
    }

    func testInstancesCannotBeEqualWithDifferentTimeOfDay() throws {
        let t1 = recordingTime(timeOfDay: .am)
        let t2 = recordingTime(timeOfDay: .pm)
        XCTAssert(t1 != t2)
    }

    func testInstancesCannotBeEqualWithDifferentDay() throws {
        let t1 = recordingTime(day: 15)
        let t2 = recordingTime(day: 16)
        XCTAssert(t1 != t2)
    }

    func testInstancesCannotBeEqualWithDifferentMonth() throws {
        let t1 = recordingTime(month: 7)
        let t2 = recordingTime(month: 8)
        XCTAssert(t1 != t2)
    }

    func testInstancesCannotBeEqualWithDifferentYear() throws {
        let t1 = recordingTime(year: 2021)
        let t2 = recordingTime(month: 2022)
        XCTAssert(t1 != t2)
    }

    func testInstancesCanBeEqualWithDifferentDayIfTimezonesPutThemOnTheSameDay() throws {
        let t1 = recordingTime(day: 15, hour: 22, timeOfDay: .pm, timezone: Zones.gmt)
        let t2 = recordingTime(day: 16, hour: 5, timeOfDay: .pm, timezone: Zones.asiaSingapore)
        XCTAssert(t1 == t2)
    }

    func testInstancesCanBeEqualWithDifferentDayAndMonthIfTimezonesPutThemOnTheSameDay() throws {
        let t1 = recordingTime(month: 7, day: 31, hour: 22, timeOfDay: .pm, timezone: Zones.gmt)
        let t2 = recordingTime(month: 8, day: 1, hour: 5, timeOfDay: .pm, timezone: Zones.asiaSingapore)
        XCTAssert(t1 == t2)
    }

    func testInstancesCanBeEqualWithDifferentDayAndMonthAndYearIfTimezonesPutThemOnTheSameDay() throws {
        let t1 = recordingTime(year: 2021, month: 12, day: 31, hour: 22, timeOfDay: .pm, timezone: Zones.gmt)
        let t2 = recordingTime(year: 2022, month: 1, day: 1, hour: 5, timeOfDay: .pm, timezone: Zones.asiaSingapore)
        XCTAssert(t1 == t2)
    }

    private func recordingTime(year: Int = 2021, month: Int = 1, day: Int = 1, hour: Int = 1, timeOfDay: TimeOfDay = .am, timezone: ZoneConvertible = Zones.gmt) -> RecordingTime {
        RecordingTime(Date(year: year, month: month, day: day, hour: hour, minute: 15, region: Region(zone: timezone)), timeOfDay)
    }
}
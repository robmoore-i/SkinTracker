//
// Created by Rob on 25/5/21.
//

import Foundation
import SwiftDate
import XCTest
@testable import SkinTracker

class TimeOfDayFromGuessTests: XCTestCase {
    func testSingapore() throws {
        XCTAssertEqual(TimeOfDay.pm, TimeOfDay.fromGuess(basedOn: gmtTime(hour: 12)))
        XCTAssertEqual(TimeOfDay.pm, TimeOfDay.fromGuess(basedOn: gmtTime(hour: 19)))
        XCTAssertEqual(TimeOfDay.am, TimeOfDay.fromGuess(basedOn: gmtTime(hour: 23)))
        XCTAssertEqual(TimeOfDay.am, TimeOfDay.fromGuess(basedOn: gmtTime(hour: 5)))

        XCTAssertEqual(TimeOfDay.pm, TimeOfDay.fromGuess(basedOn: sgtTime(hour: 20)))
        XCTAssertEqual(TimeOfDay.pm, TimeOfDay.fromGuess(basedOn: sgtTime(hour: 1)))
        XCTAssertEqual(TimeOfDay.am, TimeOfDay.fromGuess(basedOn: sgtTime(hour: 7)))
        XCTAssertEqual(TimeOfDay.am, TimeOfDay.fromGuess(basedOn: sgtTime(hour: 13)))
    }

    private func gmtTime(hour: Int) -> Date {
        Date(year: 2021, month: 05, day: 25, hour: hour, minute: 36, region: Region(zone: TimeZone(abbreviation: "GMT")!))
    }

    private func sgtTime(hour: Int) -> Date {
        Date(year: 2021, month: 05, day: 25, hour: hour, minute: 36, region: Region(zone: TimeZone(abbreviation: "SGT")!))
    }
}
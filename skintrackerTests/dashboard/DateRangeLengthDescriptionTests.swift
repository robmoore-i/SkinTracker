//
// Created by Rob on 11/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class DateRangeLengthDescriptionTests: XCTestCase {
    func testLessThanADayShowsVagueHours() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 5, day: 11, hour: 21)
        XCTAssertEqual((date1..<date2).lengthDescription(), "several hours")
    }

    func testOneDaysShowsHours() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 5, day: 12, hour: 9)
        XCTAssertEqual((date1..<date2).lengthDescription(), "24 hours")
    }

    func testTwoDaysShowsHours() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 5, day: 13, hour: 9)
        XCTAssertEqual((date1..<date2).lengthDescription(), "48 hours")
    }

    func testFiveDaysShowsDays() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 5, day: 16, hour: 9)
        XCTAssertEqual((date1..<date2).lengthDescription(), "5 days")
    }

    func testThirtyDaysShowsDays() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 6, day: 10, hour: 9)
        XCTAssertEqual((date1..<date2).lengthDescription(), "30 days")
    }

    func testThirtyOneDaysShowsWeeks() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 6, day: 13, hour: 9)
        XCTAssertEqual((date1..<date2).lengthDescription(), "4 weeks")
    }

    func testTwoAndAHalfMonthsShowsWeeks() throws {
        let date1 = dateOn(month: 5, day: 11, hour: 9)
        let date2 = dateOn(month: 7, day: 27, hour: 9)
        XCTAssertEqual((date1..<date2).lengthDescription(), "11 weeks")
    }

    private func dateOn(year: Int = 2021, month: Int = 1, day: Int = 1, hour: Int = 9) -> Date {
        Date(year: year, month: month, day: day, hour: hour, minute: 0)
    }
}
//
// Created by Rob on 17/7/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class InitialDateTimeGuessTests: XCTestCase {

    // TimeOfDay

    func testInitialTimeOfDayGuess() {
        assertInitialHourYieldsTimeOfDayGuess(hour: 9, expectedTimeOfDayGuess: .am)
        assertInitialHourYieldsTimeOfDayGuess(hour: 13, expectedTimeOfDayGuess: .am)
        assertInitialHourYieldsTimeOfDayGuess(hour: 23, expectedTimeOfDayGuess: .pm)
        assertInitialHourYieldsTimeOfDayGuess(hour: 1, expectedTimeOfDayGuess: .pm)
    }

    private func assertInitialHourYieldsTimeOfDayGuess(hour: Int, expectedTimeOfDayGuess: TimeOfDay) {
        XCTAssertEqual(TimeOfDay.fromGuess(basedOn: dateOf(hour: hour)), expectedTimeOfDayGuess)
    }

    // Date

    func testInitialDateGuess() {
        assertGuessIsSameDay(forHour: 7)
        assertGuessIsSameDay(forHour: 23)
        assertGuessIsPreviousDay(forHour: 0)
        assertGuessIsPreviousDay(forHour: 1)
    }

    private func assertGuessIsSameDay(forHour: Int) {
        assertDateGuessIsCorrect(forHour: forHour, forPreviousDay: false)
    }

    private func assertGuessIsPreviousDay(forHour: Int) {
        assertDateGuessIsCorrect(forHour: forHour, forPreviousDay: true)
    }

    private func assertDateGuessIsCorrect(forHour: Int, forPreviousDay: Bool) {
        let difference = Date.differenceDescription(
                lhs: Date.fromGuess(basedOn: dateOf(day: 10, hour: forHour)),
                rhs: dateOf(day: 10 - (forPreviousDay ? 1 : 0), hour: forHour))
        XCTAssert(difference == nil, "Incorrect for hour \(forHour) : \(difference!)")
    }

    // TimeOfDay and Date together

    func testInitialDateAndTimeGuesses() {
        assertInitialDateYieldsGuesses(initialDay: 10, initialHour: 9, expectedDayGuess: 10, expectedTimeOfDayGuess: .am)
        assertInitialDateYieldsGuesses(initialDay: 10, initialHour: 23, expectedDayGuess: 10, expectedTimeOfDayGuess: .pm)
        assertInitialDateYieldsGuesses(initialDay: 10, initialHour: 0, expectedDayGuess: 9, expectedTimeOfDayGuess: .pm)
        assertInitialDateYieldsGuesses(initialDay: 10, initialHour: 1, expectedDayGuess: 9, expectedTimeOfDayGuess: .pm)
    }

    private func assertInitialDateYieldsGuesses(
            initialDay: Int, initialHour: Int, expectedDayGuess: Int, expectedTimeOfDayGuess: TimeOfDay) {
        let guessedInitialDate = Date.fromGuess(basedOn: dateOf(day: initialDay, hour: initialHour))
        let initialTimeOfDay = TimeOfDay.fromGuess(basedOn: guessedInitialDate)
        XCTAssertEqual(guessedInitialDate, dateOf(day: expectedDayGuess, hour: initialHour))
        XCTAssertEqual(initialTimeOfDay, expectedTimeOfDayGuess)
    }

    // Factory

    private func dateOf(day: Int = 1, hour: Int = 1) -> Date {
        Date(year: 2021, month: 7, day: day, hour: hour, minute: 15, region: Region(zone: Zones.asiaSingapore))
    }
}
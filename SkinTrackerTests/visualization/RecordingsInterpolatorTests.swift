//
// Created by Rob on 17/7/21.
//

import XCTest
import Foundation
import SwiftDate
@testable import SkinTracker

class RecordingsInterpolatorTests: XCTestCase {
    let r = RecordingsInterpolator()

    func testEmptyList() {
        let data = r.twiceDailyTotals(fromRecordings: [])
        XCTAssertEqual([], data)
    }

    func testNoGaps() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 6),
            RecordingFactory.get(day: 17, timeOfDay: .am, dailyTotal: 5),
            RecordingFactory.get(day: 16, timeOfDay: .pm, dailyTotal: 4),
            RecordingFactory.get(day: 16, timeOfDay: .am, dailyTotal: 3),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 2),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testSingleGapOfSizeOneAscending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 6),
            RecordingFactory.get(day: 17, timeOfDay: .am, dailyTotal: 5),
            RecordingFactory.get(day: 16, timeOfDay: .am, dailyTotal: 3),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 2),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testSingleGapOfSizeTwoAscending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 6),
            RecordingFactory.get(day: 17, timeOfDay: .am, dailyTotal: 5),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 2),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testSingleGapOfSizeThreeAscending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 6),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 2),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testTwoGapsOfSizeOneAscending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 6),
            RecordingFactory.get(day: 16, timeOfDay: .pm, dailyTotal: 4),
            RecordingFactory.get(day: 16, timeOfDay: .am, dailyTotal: 3),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testTwoGapsOfDifferentSizesAscending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 6),
            RecordingFactory.get(day: 16, timeOfDay: .pm, dailyTotal: 4),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testSingleGapOfSizeOneDescending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 1),
            RecordingFactory.get(day: 17, timeOfDay: .am, dailyTotal: 2),
            RecordingFactory.get(day: 16, timeOfDay: .am, dailyTotal: 4),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 5),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 6),
        ])
        XCTAssertEqual([6, 5, 4, 3, 2, 1], data)
    }

    func testSingleGapOfSizeTwoDescending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 1),
            RecordingFactory.get(day: 17, timeOfDay: .am, dailyTotal: 2),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 5),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 6),
        ])
        XCTAssertEqual([6, 5, 4, 3, 2, 1], data)
    }

    func testSingleGapOfSizeThreeDescending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 1),
            RecordingFactory.get(day: 15, timeOfDay: .pm, dailyTotal: 5),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 6),
        ])
        XCTAssertEqual([6, 5, 4, 3, 2, 1], data)
    }

    func testTwoGapsOfSizeOneDescending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 1),
            RecordingFactory.get(day: 16, timeOfDay: .pm, dailyTotal: 3),
            RecordingFactory.get(day: 16, timeOfDay: .am, dailyTotal: 4),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 6),
        ])
        XCTAssertEqual([6, 5, 4, 3, 2, 1], data)
    }

    func testTwoGapsOfDifferentSizesDescending() {
        let data = r.twiceDailyTotals(fromRecordings: [
            RecordingFactory.get(day: 17, timeOfDay: .pm, dailyTotal: 1),
            RecordingFactory.get(day: 16, timeOfDay: .pm, dailyTotal: 3),
            RecordingFactory.get(day: 15, timeOfDay: .am, dailyTotal: 6),
        ])
        XCTAssertEqual([6, 5, 4, 3, 2, 1], data)
    }
}
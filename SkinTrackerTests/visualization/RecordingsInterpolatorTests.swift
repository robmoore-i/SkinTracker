//
// Created by Rob on 17/7/21.
//

import XCTest
import Foundation
import SwiftDate
@testable import SkinTracker

class RecordingsInterpolatorTests: XCTestCase {
    let r = RecordingsInterpolator()

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

    func testEmptyList() {
        let data = r.twiceDailyTotals(fromRecordings: [])
        XCTAssertEqual([], data)
    }
}
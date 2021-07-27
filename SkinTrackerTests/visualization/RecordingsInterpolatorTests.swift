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
            recordingOn(timeOfDay: .pm, day: 17, dailyTotal: 6),
            recordingOn(timeOfDay: .am, day: 17, dailyTotal: 5),
            recordingOn(timeOfDay: .pm, day: 16, dailyTotal: 4),
            recordingOn(timeOfDay: .am, day: 16, dailyTotal: 3),
            recordingOn(timeOfDay: .pm, day: 15, dailyTotal: 2),
            recordingOn(timeOfDay: .am, day: 15, dailyTotal: 1),
        ])
        XCTAssertEqual([1, 2, 3, 4, 5, 6], data)
    }

    func testEmptyList() {
        let data = r.twiceDailyTotals(fromRecordings: [])
        XCTAssertEqual([], data)
    }

    private func recordingOn(timeOfDay: TimeOfDay, day: Int = 1, dailyTotal: Int) -> Recording {
        let emptyRegionalSpotCount = RegionalSpotCount()
        emptyRegionalSpotCount.put(region: .cheek, left: dailyTotal)
        return Recording(
                Date(year: 2021, month: 7, day: day, hour: 12, minute: 15,
                        region: Region(zone: Zones.asiaSingapore)),
                timeOfDay, emptyRegionalSpotCount)
    }
}
//
// Created by Rob on 5/9/21.
//

import XCTest
@testable import SkinTracker

class RecordingTimeFormatFilenameTest: XCTestCase {
    func testFilenameNeedingLeadingZeroes() throws {
        let recordingTime = RecordingFactory.get(year: 2021, month: 9, day: 5, timeOfDay: .am).recordingTime
        XCTAssertEqual(recordingTime.formatFilename(), "2021-09-05_am")
    }

    func testEasyFilename() throws {
        let recordingTime = RecordingFactory.get(year: 2021, month: 11, day: 16, timeOfDay: .pm).recordingTime
        XCTAssertEqual(recordingTime.formatFilename(), "2021-11-16_pm")
    }
}
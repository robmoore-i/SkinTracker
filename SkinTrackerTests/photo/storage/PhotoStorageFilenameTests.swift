//
// Created by Rob on 29/9/21.
//


import XCTest
@testable import SkinTracker

class PhotoStorageFilenameTests: XCTestCase {
    func testParseRecordingTimeFromFilename() {
        let input = "photo_2021-09-20_pm.png"
        let recordingTime = PhotoStorage.recordingTimeForFilename(fileName: input)
        XCTAssertEqual(recordingTime, RecordingFactory.get(year: 2021, month: 9, day: 20, hour: 22, minute: 30, timeOfDay: .pm).recordingTime)
    }
}
//
// Created by Rob on 7/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingToJsonTests: XCTestCase {
    func testRecordingMatchesOwnDate() throws {
        let regionalSpotCount = RegionalSpotCount()
        regionalSpotCount.put(region: .chin, right: 1)
        regionalSpotCount.put(region: .cheek, left: 3)
        regionalSpotCount.put(region: .cheek, right: 1)
        let recording = Recording(-6800752135313250389, Date(year: 2021, month: 5, day: 7, hour: 3, minute: 29), .am, regionalSpotCount)
        let actualJson = recording.toJson()
        let expectedJson = """
                           {
                             "id": -6800752135313250389,
                             "foreheadRight": 0,
                             "chinLeft": 0,
                             "chinRight": 1,
                             "noseLeft": 0,
                             "eyeLeft": 0,
                             "modelVersion": 1,
                             "eyeRight": 0,
                             "noseRight": 0,
                             "date": 642050940,
                             "timeOfDay": "am",
                             "foreheadLeft": 0,
                             "jawlineLeft": 0,
                             "mouthRight": 0,
                             "jawlineRight": 0,
                             "cheekLeft": 3,
                             "cheekRight": 1,
                             "mouthLeft": 0
                           }
                           """

        let actualRecording = Recording.fromJsonV1(actualJson)
        let expectedRecording = Recording.fromJsonV1(expectedJson)
        XCTAssertEqual(actualRecording, expectedRecording)
    }
}
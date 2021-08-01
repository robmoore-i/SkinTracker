//
// Created by Rob on 7/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingToJsonTests: XCTestCase {
    func testJsonV1() throws {
        let regionalSpotCount = RegionalSpotCount()
        regionalSpotCount.put(region: .chin, right: 1)
        regionalSpotCount.put(region: .cheek, left: 3)
        regionalSpotCount.put(region: .cheek, right: 1)
        let recording = Recording(-6800752135313250389, RecordingTime(Date(year: 2021, month: 5, day: 7, hour: 3, minute: 29), .am), regionalSpotCount)
        let actualJson = recording.toJsonV1()
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

    func testJsonV2() throws {
        let regionalSpotCount = RegionalSpotCount()
        regionalSpotCount.put(region: .eyebrows, left: 1)
        regionalSpotCount.put(region: .forehead, left: 2)
        regionalSpotCount.put(region: .mouth, left: 2)
        regionalSpotCount.put(region: .mouth, right: 1)
        regionalSpotCount.put(region: .cheek, left: 3)
        regionalSpotCount.put(region: .cheek, right: 4)
        regionalSpotCount.put(region: .jawline, right: 3)
        let recording = Recording(422722367996623605,
                RecordingTime(
                        Date(year: 2021, month: 7, day: 17,
                                hour: 2, minute: 22, second: 10, nanosecond: 20504951,
                                region: Region(zone: Zones.gmt)),
                        .am),
                regionalSpotCount)
        let actualJson = recording.toJsonV2()
        let expectedJson = """
                           {
                             "id": 422722367996623605,
                             "foreheadRight": 0,
                             "chinLeft": 0,
                             "chinRight": 0,
                             "noseLeft": 0,
                             "eyebrowsLeft": 1,
                             "modelVersion": 2,
                             "noseRight": 0,
                             "date": 648181330.02050495,
                             "timeOfDay": "am",
                             "eyebrowsRight": 0,
                             "foreheadLeft": 2,
                             "jawlineLeft": 0,
                             "mouthRight": 1,
                             "cheekLeft": 3,
                             "cheekRight": 4,
                             "jawlineRight": 3,
                             "mouthLeft": 2
                           }
                           """

        let actualRecording = Recording.fromJsonV2(actualJson)
        let expectedRecording = Recording.fromJsonV2(expectedJson)
        let difference = Recording.differenceDescription(actualRecording, expectedRecording)
        XCTAssert(difference == nil, difference!)
    }
}

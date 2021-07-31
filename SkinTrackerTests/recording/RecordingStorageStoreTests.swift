//
// Created by Rob on 31/7/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingStorageStoreTests: XCTestCase {
    func testOverwritesIfRecordingTimeMatchesExistingRecording() throws {
        let provider = MockStorageProvider.Factory.usingRecordings([recordingOn(month: 7, day: 31, hour: 9, timeOfDay: .am)])
        let storage = RecordingStorage(provider)

        storage.store(recordingOn(month: 7, day: 31, hour: 11, timeOfDay: .am))

        XCTAssertEqual(storage.all.count, 1)
    }

    func testAppendsIfRecordingTimeIsUnique() throws {
        let provider = MockStorageProvider.Factory.usingRecordings([recordingOn(month: 7, day: 31, hour: 9, timeOfDay: .am)])
        let storage = RecordingStorage(provider)

        storage.store(recordingOn(month: 8, day: 1, hour: 9, timeOfDay: .am))

        XCTAssertEqual(storage.all.count, 2)
    }

    private func recordingOn(year: Int = 2021, month: Int = 1, day: Int = 1, hour: Int = 1, timeOfDay: TimeOfDay = .am, timezone: ZoneConvertible = Zones.gmt) -> Recording {
        Recording(Date(year: year, month: month, day: day, hour: hour, minute: 15, region: Region(zone: timezone)), timeOfDay, RegionalSpotCount())
    }
}
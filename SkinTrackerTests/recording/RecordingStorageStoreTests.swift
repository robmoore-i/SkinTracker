//
// Created by Rob on 31/7/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class RecordingStorageStoreTests: XCTestCase {
    func testOverwritesIfRecordingTimeMatchesExistingRecording() throws {
        let provider = MockStorageProvider.Factory.usingRecordings([RecordingFactory.get(month: 7, day: 31, hour: 9, timeOfDay: .am)])
        let storage = RecordingStorage(provider)

        storage.store(RecordingFactory.get(month: 7, day: 31, hour: 11, timeOfDay: .am))

        XCTAssertEqual(storage.all.count, 1)
    }

    func testAppendsIfRecordingTimeIsUnique() throws {
        let provider = MockStorageProvider.Factory.usingRecordings([RecordingFactory.get(month: 7, day: 31, hour: 9, timeOfDay: .am)])
        let storage = RecordingStorage(provider)

        storage.store(RecordingFactory.get(month: 8, day: 1, hour: 9, timeOfDay: .am))

        XCTAssertEqual(storage.all.count, 2)
    }
}
//
// Created by Rob on 20/5/21.
//

import XCTest
import SwiftDate
@testable import SkinTracker

class ExportRecordingsFilenameTests: XCTestCase {
    func testNameOfExportedFile() throws {
        let d: DateInRegion = Date(year: 2021, month: 5, day: 20, hour: 12, minute: 55, second: 5)
                .convertTo(region: Region(zone: TimeZone(abbreviation: "GMT")!))
        let fileName = RecordingsBackupDocument.filenameBasedOnDate(d)
        XCTAssertEqual(fileName, "saved_2021-5-20_12.55.5_SkinTracker")
    }
}
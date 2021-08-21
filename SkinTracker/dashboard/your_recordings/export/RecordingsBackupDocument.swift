//
// Created by Rob on 20/5/21.
//

import UniformTypeIdentifiers
import SwiftDate
import SwiftUI

struct RecordingsBackupDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.json]
    }

    var recordingsJson: String

    init(json: String) {
        recordingsJson = json
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
                else {
            throw RecordingsBackupError.fileReadMisconfiguration
        }
        recordingsJson = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: recordingsJson.data(using: .utf8)!)
    }

    static func defaultFilename() -> String {
        filenameBasedOnDate(Date().convertTo(region: Region.current))
    }

    static func filenameBasedOnDate(_ d: DateInRegion = Date().convertTo(region: Region.current)) -> String {
        "saved_\(d.year)-\(d.month)-\(d.day)_\(d.hour).\(d.minute).\(d.second)_SkinTracker"
    }
}

private enum RecordingsBackupError: Error {
    case fileReadMisconfiguration
}

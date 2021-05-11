//
// Created by Rob on 10/5/21.
// Copied from this blog post: https://betterprogramming.pub/importing-and-exporting-files-in-swiftui-719086ec712
//

import SwiftUI
import SwiftDate

struct ExportRecordingsButton: View {
    let recordingStorage: RecordingStorage

    @State private var isExporting = false

    var body: some View {
        Button(action: {
            print("Exporting recordings")
            print(recordingStorage.allAsJson())
            isExporting = true
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                        .scaleEffect(1.5, anchor: .center)
                        .accentColor(Color.blue)
            }
        }.fileExporter(
                isPresented: $isExporting,
                document: RecordingsBackupDocument(json: recordingStorage.allAsJson()),
                contentType: .json,
                defaultFilename: defaultFilename()) { result in
            if case .success = result {
                print("Exported file successfully")
            } else {
                print("Failed to export file")
            }
        }
    }

    private func defaultFilename() -> String {
        let d = Date().convertTo(region: Region.current)
        return "SkinTracker_recordings_backup_\(d.year)-\(d.month)-\(d.day)_\(d.hour).\(d.minute).\(d.second)"
    }
}

import UniformTypeIdentifiers

private struct RecordingsBackupDocument: FileDocument {
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
}

private enum RecordingsBackupError: Error {
    case fileReadMisconfiguration
}

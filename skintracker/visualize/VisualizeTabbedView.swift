//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct VisualizeTabbedView: View {
    private let recordingStorage: RecordingStorage

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView("Visualize", "chart.bar.xaxis") {
            VStack(spacing: 0) {
                TabHeader("You're getting there 🙏")
                HStack {
                    Text("Recordings").font(.title).padding()
                    ExportRecordingsButton(recordingStorage: recordingStorage)
                    Spacer()
                }
                RecordingsListView(recordingStorage: recordingStorage)
            }
        }
    }
}

import SwiftDate

private struct ExportRecordingsButton: View {
    let recordingStorage: RecordingStorage

    @State private var isExporting = false

    var body: some View {
        Button(action: {
            print("--- Exporting all recordings to JSON ---")
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
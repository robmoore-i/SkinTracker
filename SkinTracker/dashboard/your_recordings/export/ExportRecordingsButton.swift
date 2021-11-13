//
// Created by Rob on 10/5/21.
// Copied from this blog post: https://betterprogramming.pub/importing-and-exporting-files-in-swiftui-719086ec712
//

import SwiftUI
import SwiftDate

struct ExportRecordingsButton: View {
    @ObservedObject var recordingStorage: RecordingStorage

    @State private var isExporting = false

    var body: some View {
        Button(action: {
            UsageAnalytics.event(.tapExportRecordings)
            isExporting = true
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                        .scaleEffect(1.5, anchor: .center)
                        .accentColor(Color.blue)
            }
        }.fileExporter(
                isPresented: $isExporting,
                document: RecordingsBackupDocument(json: recordingStorage.exportAllToJson()),
                contentType: .json,
                defaultFilename: RecordingsBackupDocument.defaultFilename()) { result in
            if case .success = result {
                print("Exported file successfully")
            } else {
                print("Failed to export file")
            }
        }
    }
}
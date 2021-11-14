//
// Created by Rob on 10/5/21.
// Copied from this blog post: https://betterprogramming.pub/importing-and-exporting-files-in-swiftui-719086ec712
// With the help of this StackOverflow answer: https://stackoverflow.com/a/64351217
//

import SwiftUI
import SwiftDate

struct ImportRecordingsButton: View {
    @ObservedObject var recordingStorage: RecordingStorage

    @State private var isImporting = false
    @State private var json = ""

    var body: some View {
        Button(action: {
            UsageAnalytics.event(.tapImportRecordings)
            print("Importing recordings")
            isImporting = true
        }) {
            VStack {
                Image(systemName: "square.and.arrow.down")
                        .scaleEffect(1.5, anchor: .center)
                        .accentColor(Color.blue)
                Text("Import")
            }
        }.fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false) { result in
            do {
                let selectedFile: URL = try result.get().first!
                if selectedFile.startAccessingSecurityScopedResource() {
                    defer {
                        selectedFile.stopAccessingSecurityScopedResource()
                    }
                    if let selectedFileContent = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) {
                        json = selectedFileContent
                        recordingStorage.importAllFromJson(selectedFileContent)
                    } else {
                        print("Couldn't read content of selected file")
                    }
                } else {
                    print("Access denied to file \(selectedFile)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}